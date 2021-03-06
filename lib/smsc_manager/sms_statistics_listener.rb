require 'yaml'
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
# class to manage statistics
module SmscManager
class SmsStatisticsListener < StompMessage::StompStatisticsServer
  
  #need to define topic, host properly
  
   @debug=false
   def initialize(options={})
     super(options)
   # self.source ={}
  
  
    puts "finished initializing"
  end
  def create_m_statistics(sms)
   # self.source[sms.source] = 0 if !self.source.key?(sms.source)
   # self.source[sms.source] += 1 
  end
  def stomp_REPORT(msg, stomp_msg)
     result = super(msg, stomp_msg)
     #puts " --------------------------------- details"
    # self.source.each_pair { |key,val| puts "     key: #{key}  value: #{val}"}
   #  puts " --------------------------------- "
     [false, '']
  end
  def stomp_SMS(msg, stomp_msg)
     puts "msg command #{msg.command} msg body #{msg.body}" if @debug
     sms=SmscManager::Sms.load_xml(msg.body)
     create_m_statistics(sms)
     puts "#{self.topic} OM report stomp_SMS" if @debug
     [false, '']
	 #  stomp_REPORT(msg) if self.msg_count % 100 == 0
  end
end # smsc listener

end #module
