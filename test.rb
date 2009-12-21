require 'rubygems'
require 'sinatra'
require 'net/irc'
require 'haml'


get '/' do
  'Hello world!'
end


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

#get '/' do
#  haml :index
#end

get '/irc' do
  "hello irc"
end

class Client < Net::IRC::Client
  def initialize(*args)
    super
  end
end

Client.new("esp.jpn.ph", "6668", {
  :nick => "h7log",
  :user => "h7log",
  :real => "h7log",
}).start


#set :public, File.dirname(__FILE__) + '/static'
set :views,  File.dirname(__FILE__) + '/templates'
