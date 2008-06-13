package com.ficonab;
import javax.jms.MessageListener;
import com.ficonab.FiconabBase;

//@MessageDriven(mappedName = "sms")
public class SmscBean extends FiconabBase  implements MessageListener {
		public  String get_topic() { return "sms"; }
	
	public String get_bootstrap_string() {
	String bootstrap_string = "gem 'smsc_manager' \nrequire 'smsc_manager'\n SmscManager::SmscListener.new({:topic => 'sms', :jms_source => 'smscserver'})"; 
	    return bootstrap_string;
	}
	
}