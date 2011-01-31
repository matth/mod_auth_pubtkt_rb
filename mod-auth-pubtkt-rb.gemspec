Gem::Specification.new do |s|
  s.name = "mod-auth-pubtkt-rb"
  s.version = "0.0.4"
  s.author = "Matt Haynes"
  s.email = "matt@matthaynes.net"
  s.homepage = "http://github.com/matth/mod_auth_pubtkt_rb"
  s.summary  = "A ruby library for creating tickets for the Apache mod_auth_pubtkt module"
  s.description = "Here is a simple module for generating correctly signed tickets for use with the mod_auth_pubtkt Apache module, pretty basic stuff but usefully abstracts the OpenSSL complications."
  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = "lib"
  s.has_rdoc = false
end