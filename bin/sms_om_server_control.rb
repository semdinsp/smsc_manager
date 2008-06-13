#!/usr/bin/env ruby
require 'optparse'
require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'
gem 'daemons'
require 'daemons'
 puts "#{ARGV[0]} Operational Measurement (OM) server:"
  #  begin
  options = {
  #  :ontop => true,
  #  :multiple => true,
    :monitor => true
    
  }
     Daemons.run(File.join(File.dirname(__FILE__), 'sms_om_server.rb'), options)
    
