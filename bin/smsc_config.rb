#!/usr/bin/env ruby
 if ARGV.size !=4
   puts "Usage: smsc_config.rb  hostname username password port"
   exit
end

require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'
require 'pp'
#puts "ENV #{ENV}"
#puts "Argv is: #{ARGV}  argv.size is #{ARGV.size}"
    puts "configuring smsc settings"
    begin
      smsc=SmscManager::SmscConnection.factory
   rescue Exception => e
      puts "exception found"
   ensure
    smsc=SmscManager::SmscConnection.new if smsc==nil
   end
#puts "Argv is: #{ARGV}  argv.size is #{ARGV.size}"   
     smsc.hostname=ARGV[0]
     smsc.port=ARGV[3]
     smsc.username=ARGV[1]
     smsc.password=ARGV[2]
     pp smsc
      #default port is 13013
     puts "saving default smsc successful: #{smsc.dump}"
     puts "smsc configuration follows:"
     pp smsc
