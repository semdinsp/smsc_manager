#!/usr/bin/env ruby
# == Synopsis
#   send sms via http
# == Usage
#   send_sms_http.rb -u user -m msisdn -s source -t text 
# == Useful commands
# send_sms_http.rb -u scot -m 639993130030 -s 888 -t 'hello there' 
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
  
   require 'optparse'
   require 'rubygems'
   gem 'stomp_message'
   require 'stomp_message'
   require 'rdoc/usage'

    arg_hash=StompMessage::Options.parse_options(ARGV)
    RDoc::usage if   arg_hash[:msisdn]==nil || arg_hash[:text] == nil || arg_hash[:source] == nil || arg_hash[:help]==true
require 'pp'

require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'

    puts "Finding smsc to use:"
    begin
      smsc=SmscManager::SmscConnection.factory
   rescue Exception => e
      puts "exception found" 
   end
     puts "Found smsc: #{smsc.hostname} port #{smsc.port}"
     
     user=arg_hash[:user]
     destination=arg_hash[:msisdn]
     source=arg_hash[:source]
     text=arg_hash[:text]
     sms=SmscManager::Sms.new(text,destination,source)
     puts "Sending user: #{user} destination: #{destination}  text: #{text}"
     res= smsc.send(sms)
   #   puts "Response code: #{res.response} body: #{res.response_body}"  
     puts "Response code: #{res}"  if res.kind_of? String
     puts "pretty print response:"
     pp res
    # puts "Response code: #{res.} body: #{res.code}"  if res.kind_of? Net::Http
    
