#!/usr/bin/env ruby
require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'
#require 'lib/smsc_manager/smsc_connection'
#require 'lib/smsc_manager/sms'
require 'pp'
    puts "finding smsc settings"
   begin
      smsc=SmscManager::SmscConnection.factory
       puts "smsc configuration follows:"
       pp smsc
   rescue Exception => e
      puts "exception found"
      puts "#{e.backtrace}"
   ensure
    puts 'please run smsc_config.rb script as no smsc found' if smsc==nil
   end
    
