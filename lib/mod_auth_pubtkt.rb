require 'openssl'
require 'base64'

#
# A ruby module for creating tickets that are compatible with the Apache module
# mod_auth_pubtkt.
#
# See https://neon1.net/mod_auth_pubtkt/ for more details
#
# @author Matt Haynes <matt@matthaynes.net>
#
module ModAuthPubTkt

  #
  # Create a ticket for use in a mod_auth_pubtkt cookie
  #
  # See https://neon1.net/mod_auth_pubtkt/ for more details
  #
  # === Parameters
  #
  # - uid:      (required; 32 chars max.) 
  #             The user ID / username the ticket has been issued for, passed to the environment in REMOTE_USER
  #
  # - expires:  (required.) 
  #             A Time object that describes when this ticket will expire
  #
  # - key_path: (required.) 
  #             Path to your SSL key to sign the ticket with
  #
  # - key_type: (required.) 
  #             The type of key ("RSA" or "DSA")
  #
  # - cip:      (optional; 39 chars max.) 
  #             The client IP address.
  #
  # - tokens:   (optional; 255 chars max.)
  #             A comma-separated list of words (group names etc.) The contents of this field are available 
  #             to the environment in REMOTE_USER_TOKENS
  #
  # - udata:    (optional; 255 chars max.)
  #             User data, for use by scripts; made available to the environment in REMOTE_USER_DATA
  # 
  # - grace_period: (optional)
  #             A number of seconds grace period before ticket is refreshed
  #
  def create_ticket(uid, expires, key_path, key_type, cip = '', tokens = '', udata = '', grace_period = 0)
        
    key    = open_key_file(key_path, key_type)
    
    tkt    = "uid=#{uid};validuntil=#{expires.to_i};cip=#{cip};tokens=#{tokens};udata=#{udata};grace_period=17987";
    
    sig    = encrypt tkt, key
    
    tkt + ";sig=" + Base64.b64encode(sig).gsub("\n", '').strip
    
  end
  
  # Verify a ticket is good / not been tampered with. 
  # NB: This should be done by the apache module but is useful for testing here too
  def verify(tkt, key)
    
    if tkt =~ /(.*);sig=(.*)/
      str = $1
      sig = Base64.decode64($2)
    else
      raise "Invalid ticket format"
    end

    if key.class == OpenSSL::PKey::DSA
      key.verify(OpenSSL::Digest::DSS1.new, sig, str)
    elsif key.class == OpenSSL::PKey::RSA
      key.verify(OpenSSL::Digest::SHA1.new, sig, str)      
    end   
     
  end
  
  # Encrypt the string using key
  def encrypt(string, key)
    
    if key.class == OpenSSL::PKey::DSA
      key.sign(OpenSSL::Digest::DSS1.new, string)
    elsif key.class == OpenSSL::PKey::RSA
      key.sign(OpenSSL::Digest::SHA1.new, string)
    end
    
  end
      
  # Get the SSL key
  def open_key_file(path, type)
    if type == 'DSA'
      OpenSSL::PKey::DSA.new File.read(path)
    elsif type == 'RSA'
      OpenSSL::PKey::RSA.new File.read(path)
    end
  end

  module_function :create_ticket, :encrypt, :verify, :open_key_file
      
end
