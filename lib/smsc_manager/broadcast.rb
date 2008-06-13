# Sms stuff for handling sms
#require 'monitor'
require 'thread'
module SmscManager
  class BadList < RuntimeError
  end
# this class helps to broadcast sms to list
class Broadcast
  @@MAX_THROUGHPUT =5  # in messages per second
 # old attr_accessor :text, :source, :list,  :num_threads, :attempts, :sent
 attr_accessor :text, :source, :list,  :num_threads, :attempts, :sent
  def common_setup(src)
    @guard    = Mutex.new  
    self.attempts=0
    self.sent=0
    self.source=src
  end
  # initialize with list of destionations, texts  eg different text for each destination
  # initialize with common text and list of destinations
  def initialize(src, lst, txt=nil)
    common_setup(src)
    self.list=lst
    self.text=txt
   # puts "lst.size is #{lst.size}"
    raise BadList.new("use send_sms for lists of size 1") if lst.class==String 
    @list_queue=Queue.new
    self.populate_queue(lst) 
    self.send
  #  raise InvalidPrefix.new("invalid prefix: valid prefix area:" + Sms.valid ) if !prefix_test
  end
  
  # populate thread safe queue
  def populate_queue(lst)
     puts "list is #{lst}"
    lst.each {|key, val|   
                # txt=line[1] ||
                # if value set then send it else send default text value  
                 txt2 =  val==nil ? self.text : val
                 dst =  key
                 puts "text is #{txt2} dest is #{dst}"
                 begin
                 sms=SmscManager::Sms.new(txt2,dst,self.source)
                 @list_queue << sms
                 rescue  Exception => e
                   puts "bad values dst: #{dst} txt: #{txt2} msg: #{e.message}"
                 end
               
              # puts "  dst is #{dst}" 
               }
    puts "populate queue list size #{@list_queue.size}"
  end
 
  #calculate number of threads
  def calculate_threads
    self.num_threads = @@MAX_THROUGHPUT  +1  #sleep 1 after every message
    self.num_threads =1 if self.list.size<=@@MAX_THROUGHPUT 
  end
  
  # send using number of threads
  def send
     self.calculate_threads
     smsc=SmscManager::SmscConnection.factory
     c=0
     thread_mgr=[]
    # puts "queue size is #{@list_queue.size} " 
    # puts "queue empty is #{@list_queue.empty?}"
    while c < self.num_threads 
       thread_mgr << Thread.new(c+=1)  { |ctmp|
           #puts " #{Time.now}Creating retry thread: #{ctmp}"
           begin 
              sms = @list_queue.pop
              if sms!=nil 
                 puts "Thread #{ctmp}  destination: #{sms.destination}  text: #{sms.text}"
                 self.send_sms(smsc,sms)
              end
             end until @list_queue.empty?
         }      
     end
      thread_mgr.each { |aThread|  aThread.join if aThread.alive? }  #wait till all end
    end
    protected 
    def send_sms(smsc,sms)
      begin
     
      res= smsc.send(sms)
      @guard.synchronize { self.attempts +=1 
                           self.sent +=1 if res.kind_of? Net::HTTPAccepted }
      rescue  Exception => e
         puts "Exception found #{e.message}"
       ensure
        sleep(1)
      end
    end
  end
end