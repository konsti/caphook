require "bundler/setup"
Bundler.require(:default)

configure do
  Riak.disable_list_keys_warnings = true
  set :client, Riak::Client.new(:http_backend => :Excon)
  set :bucket, settings.client.bucket('cap')
end

get '/' do
  'Caphook Running...'
end

get '/deploy' do
  config = YAML.load_file('config/caphook.yml')
  status = "None"
  log = Riak::RObject.new(settings.bucket)
  log.content_type = "text/plain"
  log.data = ""
  begin
    FileUtils.cd(config['deploy_folder']) do
      status = Open4.popen4(Escape.shell_command([config['cap_executable'],'deploy'])) do |pid, stdin, stdout, stderr|
        until stderr.eof?
          data = stderr.readline
          log.data += data
        end
      end
      if status != 0
        log.data += "capistrano exited with status #{status}"
      end
    end
    log.store
    log.key
  rescue Exception => e
    log.data += "#{e.class.name}: #{e.message}"
    log.data += "#{e.backtrace}"
    log.store
    log.key
  end  
end

get '/cap/:project' do
  config = YAML.load_file('config/caphook.yml')
  command = params['command']
  if config['projects'].keys.include?(params[:project]) && config['cap_commands'].include?(command)
    status = "None"
    log = Riak::RObject.new(settings.bucket)
    log.content_type = "text/plain"
    log.meta['user'] = params['user'] if params.has_key?('user')
    log.meta['project'] = params[:project]
    log.data = ""
    begin
      FileUtils.cd(config['projects'][params[:project]]) do
        #ENV['BUNDLE_GEMFILE'] = config['projects'][params[:project]] + '/Gemfile'
        status = Open4.popen4(Escape.shell_command([config['cap_executable'].split(' '),command.split(' ')].flatten)) do |pid, stdin, stdout, stderr|
          until stdout.eof?
            data = stdout.readline
            log.data += data
          end
          until stderr.eof?
            data = stderr.readline
            log.data += data
          end
        end
        if status != 0
          log.data += "capistrano exited with status #{status}"
        end
      end
      log.store
      log.key
    rescue Exception => e
      log.data += "#{e.class.name}: #{e.message}"
      log.data += "#{e.backtrace}"
      log.store
      log.key
    end
  else
    "Configuration for '#{params[:project]}' missing or command '#{params[:command]}' unkown."
  end
end

get '/log/delete/all' do
  settings.bucket.keys.each do |key|
    settings.bucket.delete(key)
  end
end

get '/log/delete/:key' do
  begin
    settings.bucket.delete(params[:key])
    redirect to('/logs')
  rescue Exception => e
    "Couldn't delete this log file."
  end
end

get '/log/:key' do
  begin
    object = settings.bucket.get(params[:key])
    @last_modified = object.last_modified
    @code = object.data
    @project = object.meta['project']
    @user = object.meta['user']
    haml :log
  rescue Riak::HTTPFailedRequest => e
    "Couldn't find some log files for this key."
  end
end

get '/logs' do
  @objects = []
  keys = settings.bucket.keys
  keys.each do |key|
    object = settings.bucket.get(key)
    @objects.push({last_modified: object.last_modified, key: key, project: object.meta['project'], user: object.meta['user']})
  end
  @objects.sort! {|x,y| y[:last_modified] <=> x[:last_modified]}
  haml :logs
end