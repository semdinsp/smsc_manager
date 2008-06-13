#!/usr/bin/env ruby
#!/usr/bin/env ruby
# == Synopsis
#   daemonize the sms topic listener.  For use in production environment
# == Usage
#   sms_topic_server_control.rb start
#  sms_topic_server_control.rb stop
# == Useful commands
# supports other daemons commands
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'optparse'
require 'rubygems'
gem 'smsc_manager'
require 'smsc_manager'
gem 'daemons'
require 'daemons'
 puts "#{ARGV[0]} SMS Topic server:"
  #  begin
  options = {
  #  :ontop => true,
  #  :multiple => true,
    :monitor => true
    
  }
     Daemons.run(File.join(File.dirname(__FILE__), 'sms_topic_server.rb'), options)
     
        

   
    
