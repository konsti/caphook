Caphook
=======

Caphook is a simple Sinatra app to execute Capistrano tasks via HTTP calls.

Dependencies
------------
 * capistrano
 * escape
 * json
 * open4
 * sinatra
 * thin

To install do

    $ gem install [gemname]

Installation
------------

    $ git clone git@github.com:konsti/caphook.git
    
Modify config.yml according to your needs e.g.

    deploy_folder: /home/konstantin/project
    log_file: /home/konstantin/project_deploy.log
    cap_executable: /usr/local/rvm/gems/ruby-1.9.3-p0/bin/cap

Server
------
    $ thin start -R config.ru -d -p 4567

Credits
-------
 * Mat Brown (https://github.com/outoftime/clickistrano) for the code to run a shell command