require 'rubygems'
require 'sinatra'
require 'net/irc'
require 'kconv'
require 'haml'
require 'yaml'

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

  def on_nick(m)
    nick = m.params[0].to_s
    p nick.toutf8
  end

  def on_message(m)
    @channel = m.params[0].to_s.toutf8
    message  = m.params[1].to_s.toutf8

    #hask key for message[time_key, nick]
    time_key = Time.now

    file = File.open('irclog.yml','w')
    log_message = m.prefix.nick + " : " + message
    YAML.dump(log_message,file)
    file.close
    p m.params
  end

  def on_rpl_welcome(m)
    post JOIN, opts.channel
  end
end

client = Client.new("localhost", 6668,
 {:nick => "h7log",
  :user => "h7log",
  :real => "h7log",
  :channel => "#test"}
)
client.start

#set :public, File.dirname(__FILE__) + '/static'
set :views,  File.dirname(__FILE__) + '/templates'
