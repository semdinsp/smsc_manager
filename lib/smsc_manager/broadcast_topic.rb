# Sms stuff for handling sms
#require 'monitor'
require 'thread'
module SmscManager
  class BadList < RuntimeError
  end
# this class helps to broadcast sms to list
class BroadcastTopic
  @@MAX_THROUGHPUT =5  # in messages per second
 # old attr_accessor :text, :source, :list,  :num_threads, :attempts, :sent
 attr_accessor :text, :source, :list,  :num_threads, :attempts, :sent, :sms_sender
  def common_setup(src)
  
    self.attempts=0
    self.sent=0
    self.source=src
  end
  # initialize with list of destionations, texts  eg different text for each destination
  # initialize with common text and list of destinations
  def initialize(sms_sender, src, lst, txt=nil)
    common_setup(src)
    self.list=lst
    self.text=txt
    self.sms_sender=sms_sender
   # puts "lst.size is #{lst.size}"
    raise BadList.new("use send_sms for lists of size 1") if lst.class==String 
    @list_queue=Queue.new
    self.populate_topic(lst) 
    
  #  raise InvalidPrefix.new("invalid prefix: valid prefix area:" + Sms.valid ) if !prefix_test
  end
  
  # populate thread safe queue
  def populate_topic(lst)
    # puts "list is #{lst}"
    arg_hash = {:host => 'localhost'}
  #  self.sms_sender=SmscManager::SmsSendTopic.new(arg_hash)  
    lst.each {|key, val|   
                # txt=line[1] ||
                # if value set then send it else send default text value  
                 txt2 =  val==nil ? self.text : val
                 dst =  key
             #    puts "text is #{txt2} dest is #{dst}"
                 send_it(txt2,dst) if SmscManager::Sms.check_destination(dst)
               
              # puts "  dst is #{dst}" 
               }
   
     sleep(2)  # should we wait till we get receipts for all?
     puts "populate topic sent #{self.sent}"
    sleep(self.attempts*0.5+1) if self.sent!=self.attempts
     puts "populate topic sent after sleep #{self.sent}"
    #self.sms_sender.disconnect_stomp
  end
  def send_it(txt,dst)
  #  puts "hello from send it"
    begin
     sms=SmscManager::Sms.new(txt,dst,self.source)
    # self.sms_sender.send_topic_sms_receipt(sms)  {|r|  # puts "in receipt handler #{r.to_s}" 
    #                                                    self.sent+=1 }
     self.sms_sender.send_topic_sms(sms)
     self.sent+=1
     self.attempts+=1   # should check for results later
     rescue  Exception => e
       self.sent-=1
       puts "bad values dst: #{dst} txt: #{txt} msg: #{e.message}"
     end
    # self.sms_sender.close_topic
   end
  end
end