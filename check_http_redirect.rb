#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   HTTP(s) REDIRECT check
#
########################################################################
require 'io/handler'
require 'open-uri'

def check_http_redirect(url)    
    begin
        basic_auth = url.split('@').first.split('//').last.split(':') if url =~ /@/
        url =~ /@/ ? match = open(url, :http_basic_authentication=>[basic_auth[0], basic_auth[1]]).read : match = open(url).read

        if match.empty? or !match =~ /http-equiv=\"refresh\"/
            puts $ret_line + "REDIRECT check '#{url}' - FAILED".col_red
        else
            puts $ret_line + "REDIRECT check" + " - OK".col_status
        end
    rescue => e
        err(e, url)
    end
end
