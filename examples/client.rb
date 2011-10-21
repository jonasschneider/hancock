#!/usr/bin/env ruby
# Connect to an OpenID provider running on port 9292

require 'rubygems'
require "openid"
require "openid/store/memory"

require 'sinatra'

set :port, 9393

enable :sessions

$openid_store = OpenID::Store::Memory.new

helpers do
  def openid_consumer
    @consumer = OpenID::Consumer.new(session, $openid_store)
  end
end

get '/' do
  oidreq = openid_consumer.begin ARGV[0] || "http://titan:9292/"
  
  return_to = "http://#{request.host_with_port}/complete"
  realm = "http://#{request.host_with_port}"
  
  redirect oidreq.redirect_url(realm, return_to, false)
end

get '/complete' do
  result = openid_consumer.complete params, request.url
  
  if result.status == OpenID::Consumer::SUCCESS
    uid = result.get_signed_ns 'http://openid.net/extensions/sreg/1.1'
    raise "yep, that worked. user data: #{uid.inspect}"
  else
    raise "authentication failed. info: #{result.inspect}"
  end
end