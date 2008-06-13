require 'yaml'
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
module SmscManager
class SmscListener < StompMessage::StompZActiveRecordServer
   @@MAX_THROUGHPUT =5  # in messages per second
   SLEEP_TIME=1/@@MAX_THROUGHPUT    #sleep x seconds to slow down system
  attr_accessor :smsc
  #need to define topic, host properly
  # @@TOPIC='/topic/sms'
  def initialize(options={})
    self.model_list = []
    self.model_list << "sms_log.rb"
    #NEED TO FIX VERSION
     ver_num= self.version_number.to_s + '/'
     options[:root_path]=ENV['JRUBY_HOME']+'/lib/ruby/gems/1.8/gems/smsc_manager-'+ ver_num if RUBY_PLATFORM =~ /java/
    super(options)
    #self.smsc=SmscManager::SmscConnection.factory
  #  puts "finished initializing"
  end
 def archive_sms(res,sms)
   # do I need to do exception handling in here
   puts "---- archiving SMS res: #{res.inspect} sms: #{sms.inspect}"
   flag= res.kind_of? Net::HTTPResponse
   SmsLog.log_result(res, 'stomp_message', sms,flag )
 end
 def setup_thread_specific_items(mythread_number)
    super(mythread_number)
    self.variables[get_id][:smsc]= SmscManager::SmscConnection.factory
      puts " ----created smsc for #{get_id}  "
  end
 
  def stomp_SMS(msg, stomp_msg)
     res=''
     reply_msg="failure in stomp_SMS"
    # puts "thread list is #{Thread.list} keys: #{Thread.current.keys}"
     self.guard.synchronize {
       # puts "---- #{Thread.current[:name]} about to get message "
        tSms=SmscManager::Sms.load_xml(msg.body)
        puts "----> #{Thread.current[:name]}sending sms #{msg.body}" if @debug
        tmp_smsc=self.variables[get_id][:smsc] 
        if tmp_smsc != nil
           res= tmp_smsc.send_sms(tSms) 
           tt=archive_sms(res,tSms) 
          # puts "---- SmsLog result is #{tt.inspect}"
           tt=nil
         end   }
        msg=stomp_msg=nil 
       # puts "<---- #{Thread.current[:name]} exit synchronize "
     
        reply_msg = StompMessage::Message.new('stomp_REPLY', res) 
     
     [true, reply_msg]
   #  sleep(SLEEP_TIME)  #only 5 messages per second max
  end
  
end # smsc listener

end #module
