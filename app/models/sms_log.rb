
class SmsLog < ActiveRecord::Base
  def self.log(user, sms)
      sms_transaction_log = SmsLog.new
 #    sms_transaction_log.user=user
      sms_transaction_log.setup(sms)
      sms_transaction_log.username=user
      sms_transaction_log.save!   
    end
    def self.log_result(res, user, sms,flag)
        sms_transaction_log = SmsLog.new
   #    sms_transaction_log.user=user
        sms_transaction_log.setup(sms)
        sms_transaction_log.username=user
     #   puts "SMS LOG #{sms_transaction_log.inspect}: user #{user} flag: #{flag} res: #{res.inspect}"
        case flag
         when true
              if res.kind_of? Net::HTTPResponse    
                  sms_transaction_log.response=res.code      
                  sms_transaction_log.response_body=res.body
              else
                    sms_transaction_log.response=202
                    sms_transaction_log.response_body=res 
              end
          else
               sms_transaction_log.response=9000
               sms_transaction_log.response_body=res.to_s
         end
      #    puts "SMS LOG before save #{sms_transaction_log.inspect}"
          test= sms_transaction_log.save!
             puts "SMS LOG after save res: #{test.inspect}"
          sms_transaction_log=nil
          test
      end
    def setup(sms)
      self.sms_content=sms.text
      self.destination=sms.destination
      self.source= sms.source
    end
  
  #this needs to be fixed....
  def self.send_sms_and_log(user, sms)

 #    sms_transaction_log.user=user
       successflag=false
       begin
       sms_sender= SmscManager::SmsSendTopic.new
       r= sms_sender.send_topic_sms(sms)
       sms_sender.disconnect_stomp
       successflag=true
     rescue  Exception => e
       r = "send failed with #{e.message}"
     end
      SmscManager::SmsLog.log_result(r,user,sms,successflag)
   end
   
   
   # THIS NEEDs TO bE FixED,,, change to text rather string in database as well.
   def self.send_mms_and_log(user, mms)
       
   #    sms_transaction_log.user=user
          successflag=false
        begin
      
         mms_sender= MmscManager::MmsSendTopic.new
         r= mms_sender.send_topic_mms(mms)
         mms_sender.disconnect_stomp
         successflag=true

       rescue  Exception => e
          r = "send failed with #{e.message}"
       end
        SmscManager::SmsLog.log_result(r,user,mms,successflag)
     end
end
