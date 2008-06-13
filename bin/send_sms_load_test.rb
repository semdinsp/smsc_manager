#!/usr/bin/env ruby
require 'optparse'
def usage
    puts "Usage: send_sms_load_test.rb -u user -m msisdn -s source -t text  -c count" 
   puts "to test how long to send c sms"
   exit
end
def parse_options(params)
   opts = OptionParser.new
   puts "argv are #{params}"
   #params_split = params.split(' ')
   #puts "paramsp is #{paramsp}"
   user_flag=msisdn_flag=source_flag=text_flag=count_flag=true
   temp_hash = {}
   opts.on("-u","--user VAL", String) {|val|  temp_hash[:user ] = val
                                           puts "user is #{val}"
                                           user_flag=false }
    opts.on("-h","--host VAL", String) {|val|  temp_hash[:host ] = val
                                                puts "host is #{val}"
                                                   }                                       
                                           
   opts.on("-c","--count VAL", Integer) {|val|  temp_hash[:count ] = val
                                     puts "count is #{val}"
                                     count_flag=false }
   opts.on("-m","--msisdn VAL", String) {|val|  temp_hash[:msisdn ] = val
                                          puts "msiddn is #{val}"
                                          msisdn_flag=false }
  opts.on("-s","--source VAL", String) {|val|  temp_hash[:source ] = val
                                              puts "source is #{val}"
                                              source_flag=false }
   opts.on("-t","--text VAL", String) {|val|  temp_hash[:text ] = val
                                          puts "text is #{val}"
                                          text_flag=false }
   #opts.on("-d","--database VAL", String) {|val|  temp_hash[:db ] = val }
   #opts.on("-p","--password VAL", String) {|val|  temp_hash[:password ] = val }
   #opts.on("-u","--user VAL", String) {|val|  temp_hash[:user ] = val }
   #puts " in test commander option parse #{port} #{url}"
   opts.parse(params)
   # puts " in HTTP #{hostname} port #{port} url: #{url}"
   usage if user_flag or msisdn_flag or source_flag or text_flag or count_flag
   return temp_hash
 end
 arg_hash=parse_options(ARGV)
require 'pp'

require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'

    puts "Finding sms topic to use:"
    begin
      sms_sender=SmscManager::SmsSendTopic.new(arg_hash)    
      sms_sender.setup_auto_close
   rescue Exception => e
      puts "exception found #{e.backtrace}" 
   end  
     user=arg_hash[:user]
     destination=arg_hash[:msisdn]
     source=arg_hash[:source]
     text=arg_hash[:text]
     count=arg_hash[:count]
     start=Time.now
     puts "Time now: #{start}"
     receipt_count=count
     1.upto(count) { |c| 
       puts "sent #{c} messages" if c % 100 == 0   
       final_text = "count: #{c}: #{text} "
       s=SmscManager::Sms.new(final_text,destination,source)
       sms_sender.send_topic_sms_receipt(s) { |m| receipt_count-=1
                                                #  puts "receipt: #{receipt_count}" 
                                                  }
        sleep(1) if c % 100 == 0   
        Thread.pass
      }
      diff = Time.now - start
     # sms_sender.close_topic
          begin
         Timeout::timeout(count*0.5) {
              while true  
                 puts "sent #{count} waiting for #{receipt_count} receipts"
                 exit(0) if receipt_count==0   
                 sleep(1)
                 end  }
           rescue SystemExit
           
           rescue Exception => e
            puts "exception #{e.message} class: #{e.class}"
            puts  "no receipt"
         #   raise "timeout" 
           ensure
            sms_sender.setup_auto_close
           end   
             
      
    	puts "#{Time.now} Sent #{count} in #{diff} seconds";
    	exit(0)
    	
    # puts "Sending user: #{user} destination: #{destination}  text: #{text}"
   #  res= smsc.send(sms)
   #   puts "Response code: #{res.response} body: #{res.response_body}"  
   #  puts "Response code: #{res}"  if res.kind_of? String
   #  puts "pretty print response:"
  #   pp res
    # puts "Response code: #{res.} body: #{res.code}"  if res.kind_of? Net::Http
    
