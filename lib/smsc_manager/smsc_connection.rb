require 'yaml'
require 'erb'
require 'timeout'
require 'net/http'
module SmscManager
class SmscConnection 
 # use block for timers etc
 @@timeout_max = 10 #10 second timeout to contact sms server
 attr_accessor :hostname, :port, :username, :password #, :portmap
  
 # def intialize(pass, user, port=13013, host='localhost')
 # end
  def send_block(text,destination,source)
      @flag=false
      s = Time.now    #max forty second timeout
      @res='before'
      begin
       Timeout::timeout(@@timeout_max) {
         @res= yield 
       }
       rescue Exception => e
        @res = "#{e}"
       ensure
       s= Time.now - s
       end
      #  puts "#{Time.now}  result #{hostname}  flag: #{flag} res: #{res} time #{s}"
       puts "-res #{@res} -time #{s} dest: #{destination} src: #{source}"
       return @res
   end
    def self.path_to_config
      File.join(File.dirname(__FILE__), '../../config/smsc.yml')
    end
    
    def dump
      #change this in database or here
      test_path=SmscManager::SmscConnection.path_to_config
   #   puts "Path to config file is: #{test_path}"
      config = File.open(test_path,'w') { |f| YAML.dump(self,f) }
    end
   def self.load_smsc
     #change this in database or here
     test_path=self.path_to_config
    # puts "Path to config file is: #{test_path}"
     config = File.open(test_path) { |f| YAML.load(f) }
    #puts "config is: #{config} config.class is: #{config.class}"
    if config.class==SmscManager::SmscConnection
      smsc=config
    else
    # puts "hostname is: #{config['hostname']}"
     smsc=SmscManager::SmscConnection.new
     smsc.hostname=config["hostname"]
     smsc.port=config["port"]
     smsc.username=config["username"]
     smsc.password=config["password"]
   end
     smsc
   end
   def send_sms(sms)
       sms_send(sms)
     end
  # def send(sms)
  #    sms_send(sms)
  #  end
   def test(sms)
      send_sms(sms)
   end
   def self.factory
     SmscManager::SmscConnection.load_smsc
   end
   protected
   # send sms using kannel
   #  http://smsbox.host.name:13013/cgi-bin/sendsms?username=foo&password=bar&to=0123456&text=Hello+world
  
   # URL Encoded specific to Kannel that is why not part of model
   # port map chooses which kannelport tosend it out on...
   def portmap(src)
     hash_port=Hash.new('26999')
     ports = %w(930 999 991 992 913 )
     ports.each { |p| hash_port[p]="26#{p}"  }
    # puts "--- src is #{src} port is #{hash_port[src]}"
     hash_port[src]
   end
    def sms_send(sms)
      text= ERB::Util.html_escape(sms.text)
      txt_encoded=ERB::Util.url_encode(text)
    #  txt_encoded=limit_text(txt_encoded)
     # smsc=SmscManager::SmscConnection.factory     
      internal_send(txt_encoded,sms.destination,sms.source)
    end
    private
    def internal_send(text,destination,source)
      self.port=portmap(source)
        puts "hostname: #{self.hostname} port #{self.port} destination #{destination}"
      return send_block(text,destination,source) {  
          ht =Net::HTTP.start(self.hostname,self.port)
        
          url="/cgi-bin/sendsms?username=#{self.username}&password=#{self.password}&from=#{source}&to=#{destination}&text=#{text}"
          r=ht.get(url)
          # puts "url was: #{url}"
          @res = r.code
          puts "r is: #{r.body} r.code is #{r.code}"
          #@flag=true if @res=200 || @res==302
          r   #return the response
         }

   end
 end
end
