require 'yaml'
require 'erb'
require 'timeout'
require 'net/http'
module SmscManager
class SmscStompConnection 
 # use block for timers etc
 @@timeout_max = 10 #10 second timeout to contact sms server
 attr_accessor :hostname, :port, :username, :password, :url, :topic
  def intialize(args)
    self.url="/TopicSMS/TopicSMS"
    self.topic = 'sms'
    self.hostname = 'x.x.x.x'
    self.port='8161'
  end
 
   def send(sms)
      sms_send(sms)
    end
   def test(sms)
      send(sms)
   end
  # asssumes http post --- can be modified for other messaging of course
    def sms_send(sms)
       puts "create stomp message"
       m=SmscManager::SmsSendTopic.create_stomp_message(sms.text,sms.destination,sms.source)
       puts "message is #{m.to_xml}"
       # original puts "hostname: #{arg_hash[:host]} port #{arg_hash[:port]}"
       arg_hash={}
       arg_hash[:host]=self.hostname
       argh_hash[:port]=self.port
          puts "hostname: #{self.hostname} port #{arg_hash[:port]}"
       url="#{arg_hash[:topic]}?m.to_xml"
       arg_hash[:url]=self.url
       arg_hash[:topic]=self.topic
         msg_sender=StompMessage::StompSendTopic.new(arg_hash) 
         msg_sender.post_stomp(m, {})
    end
 
 end
end
