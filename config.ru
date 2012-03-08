require 'rubygems'
require 'sinatra'
require './caphook'
set :run, false
set :environment, :production
run Sinatra::Application