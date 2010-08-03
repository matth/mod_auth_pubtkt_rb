# mod\_auth_pubtkt.rb

Here is a simple module for generating correctly signed tickets for use with the mod\_auth_pubtkt Apache module, pretty basic stuff but usefully abstracts the OpenSSL complications.

For more info on mod\_auth\_pubtkt see: [https://neon1.net/mod\_auth_pubtkt](https://neon1.net/mod\_auth_pubtkt/)

## Usage

### Generate a public / private key pair

Taken from: [https://neon1.net/mod\_auth_pubtkt/install.html](https://neon1.net/mod\_auth_pubtkt/install.html)

#### DSA 

	# openssl dsaparam -out dsaparam.pem 1024
	# openssl gendsa -out privkey.pem dsaparam.pem
	# openssl dsa -in privkey.pem -out pubkey.pem -pubout

The dsaparam.pem file is not needed anymore after key generation and can safely be deleted.
	
#### RSA

	# openssl genrsa -out privkey.pem 1024
	# openssl rsa -in privkey.pem -out pubkey.pem -pubout

### Use it in your code

	require 'mod_auth_pubtkt'
	
	# This will generate the ticket, see ./lib/mod_auth_pubtkt for available options
	tkt = ModAuthPubTkt.create_ticket 12345, Time.now + 3600, "/my/privkey.pem", "DSA"
	
	# Now you can use the ticket as a cookie value in your web app!
	
## License

(GPLv3)

Copyright (C) 2010 Matt Haynes

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <www.gnu.org/licenses/>