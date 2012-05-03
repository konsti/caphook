# Caphook# 

Caphook is a simple Sinatra app to execute Capistrano tasks via HTTP calls.

## Installation ##

    $ git clone git@github.com:konsti/caphook.git
    
Create caphook.yml according to your needs. Look at `caphook.yml.sample` for help.

## Dependencies ##

 * Riak (> 1.1.2)
 * Bundler to install Gemse

    $ bundle install

## Server ##
    $ thin start -R config.ru -d -p 4567
    
You can also create a Profile and use foreman (included in the Gemfile)  
  
## Use Caphook ##
Now you're able to deploy your project with HTTP calls

    GET /cap/{project_name}?command={cap_command_included_in_config}
    
You can also view your log files with
    
    GET /logs

## Credits ##
 * Mat Brown (https://github.com/outoftime/clickistrano) for the code to run a shell command