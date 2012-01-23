#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   ping & traceroute wrapper
#
########################################################################
require 'io/handler' 
require 'ping'

def check_connectivity(host, service)
	begin
		ping = Ping.pingecho(host, 4, service)
		if ping
			puts $ret_line + 'PING check' + ' - OK'.col_status
		else
			puts $ret_line + 'PING check ' + host + ' - FAILURE'.col_red
			puts $ret_line + '..tracerouting..'.col_red
			traceroute=`which traceroute`.chomp
			exec=`#{traceroute} -n #{host}`
			err('connectivity problem!', exec)
    		end
	end
end
