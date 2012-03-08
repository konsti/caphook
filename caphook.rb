require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'fileutils'
require 'open4'
require 'escape'

get '/' do
  'Hello'
end

get '/deploy' do
  config = YAML.load_file('config.yml')
  begin
    FileUtils.cd(config['deploy_folder']) do
      FileUtils.rm(config['log_file']) if File.exist?(config['log_file'])
      status = Open4.popen4(Escape.shell_command([config['cap_executable'],'deploy'])) do |pid, stdin, stdout, stderr|
        until stderr.eof?
          data = stderr.readline
          File.open(config['log_file'], 'a') do |file|
            file << data
          end
        end
      end
      if status == 0
        "Success"
      else
        File.open(config['log_file'], 'a') do |file|
          file.puts("capistrano exited with status #{status}")
        end
        "Failed"
      end
    end
  rescue Exception => e
    File.open(config['log_file'], 'a') do |file|
      file.puts("#{e.class.name}: #{e.message}")
      file.puts(e.backtrace)
    end
    "Error"
  end
end