$KCODE = 'u'
require 'rubygems'
require 'sinatra'
require 'net/irc'
require 'kconv'
require 'haml'
require 'yaml'
require 'yaml_waml'

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
  file = YAML.load_file("irclog.yml")
  p file
end

class String
  def is_binary_data?
    false
  end
end

class Client < Net::IRC::Client

  def on_nick(m)
    nick = m.params[0].to_s.toutf8
    p nick.toutf8
  end

  def on_message(m)
    @channel = m.params[0].to_s.toutf8
    message  = m.params[1].to_s.toutf8

    #hash key for message[message_key]
    time_key = Time.now.to_s
    message_key = "(" + time_key + ")" + ":" + m.prefix.nick

    #open irclog.yml
    file = File.open('irclog.yml','a')
    
    #initialize log_message(hash).
    log_message = {}

    ##log format = (time.now) nick : message
    log_message[message_key] = message.toutf8
    log_message.to_yaml
    p log_message
    YAML.dump(log_message,file)
    file.close

    p m.params
  end

  def on_rpl_welcome(m)
    post JOIN, opts.channel
  end
end

client = Client.new("esp.jpn.ph", 6668,
 {:nick => "h7log",
  :user => "h7log",
  :real => "h7log",
  :channel => "#test"}
)
client.start

#set :public, File.dirname(__FILE__) + '/static'
set :views,  File.dirname(__FILE__) + '/templates'
