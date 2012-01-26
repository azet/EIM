#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   Monitoring check dispatcher
#
########################################################################
require 'io/handler'
begin
    require 'yaml'
    list = YAML.load_file 'config.yaml'
rescue => e
    err("can't load configuration file!", e)
end

threads = []
Thread.abort_on_exception = true
i = 0
begin
    i += 1
    list['checks'].each do |name, object|
        case object[0]
            when 'check_http_url'
                puts $ret_line + '>> - checking http(s) URL:'.col_status
                puts $ret_line + name + ' -- ' + object[1]
                threads << Thread.new {
                    require 'check_http_url'
                    check_http_url(object[1])
                }
            when 'check_connectivity'
                puts $ret_line + '>> - checking connectivity of:'.col_status
                puts $ret_line + name + ' -- ' + object[1] + ':' + object[2]
                threads << Thread.new {
                    require 'check_connectivity'
                      check_connectivity(object[1], object[2])
                }
            else
                puts $ret_line + 'error: '.col_red + object[0].col_red_bg + ' <-- sorry, i dont know what to do with this..'.col_red
        end
    end
    puts $ret_line + "<<--------------------[[[[ FINISHED ROUND ".col_status + i.to_s.col_blue + " ]]]]-------------------->>\n".col_status
rescue => e
    err('dispatcher - ' + e, false)
end until i == list['iterations']

begin
    threads.each { |th| th.join }
rescue => e
    err('thread exception - ' + e, false)
end
