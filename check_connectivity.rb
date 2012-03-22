#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   ping & traceroute wrapper
#
########################################################################
require 'lib/handler' 
require 'ping'

def check_connectivity(name, host, service)
    ping = Ping.pingecho(host, 4, service)
    if ping
        puts $ret_line + "PING (#{service}) check" + ' - OK'.col_status
    else
        puts $ret_line + "PING (#{service}) check " + host + ' - FAILURE'.col_red
        puts $ret_line + '..tracerouting..'.col_red
        traceroute=`which traceroute`.chomp
        exec=`#{traceroute} -n #{host}`
        err('connectivity problem!', exec, name)
    end
end
