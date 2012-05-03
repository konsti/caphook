# Caphook

Caphook is a simple Sinatra app to execute Capistrano tasks via HTTP calls.

## Installation ##

    $ git clone git@github.com:konsti/caphook.git
    
 * Create `config/caphook.yml` according to your needs. Look at `config/caphook.yml.sample` for help.
 * Install Riak with localhost access
 
    $ bundle install

## Dependencies ##

 * Ruby (> 1.9.3)
 * Riak (> 1.1.2)

## Server ##
    $ thin start -R config.ru -d -p 4567
    
You can also create a Profile and use foreman (included in the Gemfile)  
  
## Use Caphook ##
Now you're able to deploy your project with HTTP calls

    GET /cap/{project_name}?command={cap_command_included_in_config}
    
Optional Params:
    user={user_string}
    
You can also view your log files with
    
    GET /logs

## Credits ##
 * Mat Brown ([https://github.com/outoftime/clickistrano](https://github.com/outoftime/clickistrano)) for the code to run a shell command
 
## License ##
Caphook is released under the MIT license:   
  [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)