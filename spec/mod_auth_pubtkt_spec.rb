require "rubygems"
require File.dirname(__FILE__) + "/../lib/mod_auth_pubtkt.rb"

describe ModAuthPubTkt do

  describe "#create_ticket" do
    
    dsa_key_file = File.dirname(__FILE__) + "/../examples/dsaprivkey.pem"
    rsa_key_file = File.dirname(__FILE__) + "/../examples/rsaprivkey.pem"    
    
    it "should encrypt correctly using a DSA cert" do
            
      tkt     = ModAuthPubTkt.create_ticket 12345, Time.now + 3600, dsa_key_file, "DSA"

      dsa_key = ModAuthPubTkt.open_key_file dsa_key_file, "DSA"

      ModAuthPubTkt.verify(tkt, dsa_key).should == true      
      
    end
    
    it "should encrypt correctly using a RSA cert" do
            
      tkt     = ModAuthPubTkt.create_ticket 12345, Time.now + 3600, rsa_key_file, "RSA"

      rsa_key = ModAuthPubTkt.open_key_file rsa_key_file, "RSA"

      ModAuthPubTkt.verify(tkt, rsa_key).should == true      
      
    end    

    it "should convert the expires time to seconds since epoch" do
      time = Time.now
      tkt     = ModAuthPubTkt.create_ticket 12345, time, dsa_key_file, "DSA"      
      tkt.should =~ /validuntil=#{time.to_i}/
    end
            
  end
  
end
