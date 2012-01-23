#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   HTTP(s) URL check with BASIC AUTH support
#
########################################################################
require 'io/handler'
require 'open-uri'

def check_http_url(url)	
	begin
		basic_auth = url.split('@').first.split('//').last.split(':') if url =~ /@/
		url =~ /@/ ? match = open(url, :http_basic_authentication=>[basic_auth[0], basic_auth[1]]).read : match = open(url).read
		if match.empty?
			puts $ret_line + "LINK check '#{url}' - FAILED".col_red
		else
			puts $ret_line + "LINK check" + " - OK".col_status
		end
	rescue => e
		err(e, url)
	end
end
