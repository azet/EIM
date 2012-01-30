#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   HTTP(s) REDIRECT check
#
########################################################################
require 'io/handler'
require 'open-uri'

# this is taken from the original ruby open-uri class,
# fixed this to support secure socket http redirects:
def OpenURI.redirectable?(uri1, uri2) # :nodoc:
    # This test is intended to forbid a redirection from http://... to
    # file:///etc/passwd.
    # However this is ad hoc.  It should be extensible/configurable.
    uri1.scheme.downcase == uri2.scheme.downcase ||
    (/\A(?:http|ftp|https)\z/i =~ uri1.scheme && /\A(?:http|ftp|https)\z/i =~ uri2.scheme)
end

def check_http_redirect(url)    
    begin
        basic_auth = url.split('@').first.split('//').last.split(':') if url =~ /@/
        url =~ /@/ ? match = open(url, :http_basic_authentication=>[basic_auth[0], basic_auth[1]]).read : match = open(url).read
        if match.empty? or match.nil?
            puts $ret_line + "REDIRECT check '#{url}' - FAILED".col_red
            raise 'redirect failed..'
        elsif match
            puts $ret_line + "REDIRECT check '#{url}'" + " - OK".col_status
        end
    rescue => e
        err(e, url)
    end
end