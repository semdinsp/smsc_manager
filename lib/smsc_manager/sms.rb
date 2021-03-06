require 'rexml/document'
# Sms stuff for handling sms
require 'rubygems'
gem 'stomp_message'
require 'stomp_message'
module SmscManager
class InvalidPrefix < RuntimeError
end
# this class defines creating  a sms
# and strips out the unnecessary junk
class Sms
  @@MAX_SIZE=1500 # 3*160   # max 1500 characters, change if your smsc suports less
  @@msisdn_valid_prefix= %w{ 63999 999 0999 992 930 1000 888 +63999 }
  attr_accessor :text, :source, :destination #, :orig_txt
  def self.max_length
    @@MAX_SIZE
  end
  include StompMessage::XmlHelper
  # create new sms, limit the text,  src  is 1000
  def self.valid
    sentence=" "
    @@msisdn_valid_prefix.each {|t| sentence << t <<" " }
    sentence
  end
  def get_message_content
    self.text
  end
  def self.starts_with?(prefix,dest)
            prefix = prefix.to_s
            return false if dest == nil
            dest[0, prefix.length] == prefix
          end
  def initialize(txt,dest,src='999')
  #  self.orig_txt=txt
    self.destination=dest
    self.source=src
    self.text=strip_text(txt)
    raise InvalidPrefix.new("invalid prefix: #{dest} valid prefix area:" + Sms.valid ) if !prefix_test
  end
  def prefix_test
    Sms.check_destination(self.destination)
  end
  def self.check_destination(dst)
    flag = false
    
    @@msisdn_valid_prefix.each { |w| k= Sms.starts_with? w , dst
                                   flag=true if k }
    flag
  end
  def to_xml
    msg_xml = REXML::Element.new "sms"
    msg_xml =self.add_elements(msg_xml)
    msg_xml.to_s
   # doc= REXML::Document.new sms_xml.to_s
   # doc.to_s
  end
  
  def self.load_xml(xml_string)
    doc=REXML::Document.new(xml_string)
    dest=REXML::XPath.first(doc, "//destination").text
    src=REXML::XPath.first(doc, "//source").text
    text=REXML::XPath.first(doc, "//text").text
    sms=SmscManager::Sms.new(text,dest,src)
  end
  def limit_text(val)
    #limit to @@MAX_SIZE characters
      ret=""
      size=[val.size,@@MAX_SIZE].min-1
 #   0.upto(size) do |i|
   #   ret << val[i]
 #   end
      ret=val[0..size]
    ret
  end
    def strip_text(txt) 
       # puts "text is #{txt} nil #{txt==nil}"
            txt= " " if txt==nil
            result=txt.gsub(/@/,"(at)")   # replace all at signs  return result
        #    result=result.gsub(/\n/," ")   # replace all new lines  return result
         #   result=result.gsub(/\r/," ")   # replace all new lines  return result
           result=result.gsub('_',"-")   # replace all new lines  return result
         #  result=result.gsub(/-/," ")   # replace all - with space...angelo bug return result
        #    result=result4.gsub(/\//,"")   # replace all new lines  return result
        
            limit_text(result)
    end
end
end