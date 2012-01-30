#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:    IO & Error handling
#
########################################################################
class String
    def col_red; colorize(self, "\e[31m"); end
    def col_red_bg; colorize(self, "\e[30m\e[41m"); end
    def col_blue; colorize(self, "\e[1m\e[33m\e[44m"); end
    def col_status; colorize(self, "\e[32m"); end
    def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end
$ret_line = 'EIM'.col_status + ' => '

require 'open-uri'
def OpenURI.redirectable?(uri1, uri2) # :nodoc:
    # This test is intended to forbid a redirection from http://... to
    # file:///etc/passwd.
    # However this is ad hoc.  It should be extensible/configurable.
    uri1.scheme.downcase == uri2.scheme.downcase ||
    (/\A(?:http|ftp|https)\z/i =~ uri1.scheme && /\A(?:http|ftp|https)\z/i =~ 
uri2.scheme)
 end

def err(e, param)
    require 'io/alerting'
    return puts $ret_line + e, $0.col_status + ' -> ' + param + ' => ' + 'error: '.col_red + e.to_s.col_red_bg
ensure
    puts $ret_line + 'alerting'.col_red_bg
    #send_sms(e.to_s, param.to_s)
    #send_mail(e.to_s, param.to_s)
end
