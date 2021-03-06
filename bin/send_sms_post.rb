#!/usr/bin/env ruby
#!/usr/bin/env ruby
# == Synopsis
#   send sms via http post to sdp topic  --- example for content providers
# == Usage
#   send_sms_post.rb -u user -m msisdn -s source -t text -h host -p port -T topic -U url
# == Sample commands
# send_sms_post.rb  -u scot -s 888 -m 639993130030 -t testing -h localhost -p 8161 -T sms
# send_sms_post.rb  -u scot -s 888 -m 639993130030 -t testingpost -h localhost -p 8161 -T sms -U /demo/message
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

gem 'smsc_manager'
require 'smsc_manager'
require 'net/http'

     user=arg_hash[:user]
     destination=arg_hash[:msisdn]
     source=arg_hash[:source]
     text=arg_hash[:text]
     puts "create stomp message"
     m=SmscManager::SmsSendTopic.create_stomp_message(text,destination,source)
     puts "message is #{m.to_xml}"
      puts "hostname: #{arg_hash[:host]} port #{arg_hash[:port]}"
     url="#{arg_hash[:topic]}?m.to_xml"
     arg_hash[:url]="" << arg_hash[:topic] if arg_hash[:url]==nil
       msg_sender=StompMessage::StompSendTopic.new(arg_hash) 
       msg_sender.post_stomp(m, {})
 
    
