# Caphook# 

Caphook is a simple Sinatra app to execute Capistrano tasks via HTTP calls.

## Installation ##

    $ git clone git@github.com:konsti/caphook.git
    
Create config.yml according to your needs e.g.

    deploy_folder: /home/konstantin/project
    log_file: /home/konstantin/project_deploy.log
    cap_executable: /usr/local/rvm/gems/ruby-1.9.3-p0/bin/cap

## Dependencies ##

 * Riak (> 1.1.2)
 * Bundler to install Gemse

    $ bundle install

## Server ##
    $ thin start -R config.ru -d -p 4567
    
You can also create a Profile and use foreman (included in the Gemfile)  
  
## Use Caphook ##
Now you're able to deploy your project with HTTP calls

    GET /deploy

## Credits ##
 * Mat Brown (https://github.com/outoftime/clickistrano) for the code to run a shell command