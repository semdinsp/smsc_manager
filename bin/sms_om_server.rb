#!/usr/bin/env ruby
# == Synopsis
#   start up the sms om listener.  OM = Operational Measurements. This is the statistics/repoting tool listening to sdp message
# == Usage
#   sms_om_server.rb 
# change the number of threads, and other key variables below to control system performance
# == Useful commands
# sms_om_server.rb 
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'optparse'
def usage
    puts "Usage: sms_topic_server.rb to start up listener " 
   exit
end

require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'

    puts "Starting Operational Measurement (OM) server:"
  #  begin
  # can add additional options to change host/port etc
      sms_listener=SmscManager::SmsStatisticsListener.new({:topic => '/topic/sms', :thread_count => '3'}).run
    #  sms_listener.join
   # rescue Exception => e
      puts "exception found #{e.backtrace}" 
  #  end
   
    
