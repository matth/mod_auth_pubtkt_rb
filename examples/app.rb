require "rubygems"
require "sinatra"

require File.dirname(__FILE__) + "/../lib/mod_auth_pubtkt.rb"

get "/" do
  <<-HTML
    <html><body>
    <form action='/signin/' method="post">
      User:
      <input type="text" name="user" />
      Pass:
      <input type="password" name="pass" />
      <input type="submit" value="Login" />
    </form>
    </body></html>    
  HTML
end

post "/" do
    
  details = request.env['rack.request.form_hash']
  
  if details["user"] == "test" && details["pass"] = "test"
    ticket = ModAuthPubTkt.create_ticket 12345, Time.now + 3600, File.dirname(__FILE__) + "/rsaprivkey.pem", "RSA"
    response.set_cookie("token", { :path => "/", :value => ticket })
    redirect "/signin/ok/"    
  else 
    "Wrong combo, try it again (it's test btw)"
  end
  
end

get "/ok/" do
  "You are signed in!"
end