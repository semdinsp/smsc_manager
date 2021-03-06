#!/usr/bin/env ruby
# == Synopsis
#   start up the sms topic listener.  This is the key component for listening to sdp message
# == Usage
#   sms_topic_server.rb path_to_sms_model_files rails_environment
# change the number of threads, and other key variables below to control system performance
# == Useful commands
# sms_topic_server.rb ./ development    --- if in development environment
# sms_topic_server.rb      --- if in production environment and config ok.
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'optparse'
def usage
    puts "Usage: sms_topic_server.rb to start up listener " 
    puts "Usage: sms_topic_server.rb path_to_smsapp_rails_app environment " 
      puts "eg: sms_topic_server.rb ./ development " 
   exit
end

require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'
   env_setting = ARGV[1] || "production"
   path_setting = ARGV[0] || "/opt/local/rails_apps/smsapp/current/"
   puts "Starting SMSC Topic Server topic server:  path:  #{path_setting} environment: #{env_setting}"
    #puts "Starting topic server:"
  #  begin
      SmscManager::SmscListener.new({:topic => '/topic/sms', :thread_count => '10', :env => env_setting, :root_path => path_setting }).run
   #   sms_listener.join
   # rescue Exception => e
      puts "exception found #{e.backtrace}" 
  #  end
   
    
