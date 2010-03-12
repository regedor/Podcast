require 'rubygems'
require 'sinatra'
require 'haml'

root_dir    = File.dirname(__FILE__)
environment = (ENV['RACK_ENV'] || "production")
log         = File.new(File.join(root_dir, 'log', environment + ".log"), "a")

set :environment, environment.to_sym
set :root,        root_dir
set :views,       root_dir + "/views"
set :public,      root_dir + "/public"
set :app_file,    File.join(root_dir, 'app.rb')

STDOUT.reopen(log)
STDERR.reopen(log)
disable :run, :reload

require 'app'
run Sinatra::Application

