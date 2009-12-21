require 'rubygems'
require 'sinatra'
require 'haml'

"""
get '/' do
  'Hello world!'
end
"""

get '/fuck/:name' do
  #matches "GET /fuck/foo" and "GET /fuck/bar"
  #params[:name] is 'foo' or 'bar'
  "fuck #{params[:name]}!"
end

get '/hello/:name' do |n|
  "Hello #{n}!"
end

get '/say/*/to/*' do
  #matches /say/hello/to/world
  params[:splat] # => ["hello,world"]
end

get '/download/*.*' do
  #matches /download/path/to/file.xml
  params[:splat] # => ["path/to/file", "xml"]
end

get '/' do
  haml :index
end

set :public, File.dirname(__FILE__) + '/static'
#set :views,  File.dirname(__FILE__) + '/templates'
