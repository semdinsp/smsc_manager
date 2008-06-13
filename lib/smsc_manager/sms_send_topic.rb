require 'yaml'
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
# This sends the sms to a activemq topic
module SmscManager
class SmsSendTopic < StompMessage::StompSendTopic

  #need to define topic, host properly
  @@TOPIC='sms'
  # must be defined as method in sms_listener
  @@STOMP_SMS_MESSAGE='stomp_SMS'
 def initialize(options={})
   # set up variables using hash
    options[:topic] =   options[:topic]==nil ? @@TOPIC : options[:topic]
   
   
  #   @javaflag = RUBY_PLATFORM =~ /java/
 
     super(options) # if !@javaflag
    #puts "finished initializing"
  end


 def send_sms(text,destination,source)
        sms=SmscManager::Sms.new(text,destination,source)
        self.send_topic_sms(sms)
 end #send_sms
  
def send_topic_sms(sms)
         
           m=StompMessage::Message.new(@@STOMP_SMS_MESSAGE, sms.to_xml)
           headers = {}
             timeout=75
             result=self.send_topic_ack(m,headers,timeout-1)
             sms=nil
             m=nil
            "sent"
 end #send_sms
  def send_topic_sms_receipt(sms, &r_block)
         #sms=SmscManager::Sms.new(text,destination,source)
        # msgbody=sms.to_xml
         m=StompMessage::Message.new(@@STOMP_SMS_MESSAGE, sms.to_xml)
      #   puts "message body is #{msgbody}"
        # headers = {:msisdn =>"#{sms.destination}"}
          headers = {}
           if self.java?
                jms_message_handling(@jms_dest, @jms_conn) {  self.send_jms_message(@session,@producer,headers,msg.to_xml, &r_block)  }
            
            else
              send_topic(m, headers, &r_block) 
            end
        
  end #send_sms

  # simple script to show xml message
  def self.create_stomp_message(txt,dest,src)
       sms=SmscManager::Sms.new(txt,dest,src)
       m=StompMessage::Message.new(@@STOMP_SMS_MESSAGE, sms.to_xml)
      end
  def self.print_example_xml
     text= "hello there #{Time.now}"
     destination = "639993130030"  #must be valid destination
     source = '999'
     sms=SmscManager::Sms.new(text,destination,source)
     m=SmscManager::SmsSendTopic.create_stomp_message( text,destination,source)
     result = "------------ SMS XML----------------\n"
     result << "#{sms.to_xml}\n"
     result << "------------STOMP XML--------------\n"
     result << "#{m.to_xml}\n"
     result << "------------END--------------------"
     result
  end
end # smsc listener

end #module
