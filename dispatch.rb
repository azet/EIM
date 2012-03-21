#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   Monitoring check Dispatcher
#
########################################################################
begin
    # require local lib. && yaml
    require 'lib/handler'
    require 'yaml'
    list = YAML.load_file 'config.yaml'
rescue => e
    err(e, "can't load configuration file!", 'yaml loader')
end

threads = []
Thread.abort_on_exception = true
i = 0
begin
    i += 1
    list['checks'].each do |name, val|
        case val[0]
            when 'check_http', 'check_http_url', 'check_http_redirect'
                puts $ret_line + '>> - checking URL:'.col_status
                puts $ret_line + name + ' -- ' + val[1]
                threads << Thread.new {
                    require 'check_http'
                    check_http(name, val[1])
                }

            when 'check_connectivity'
                puts $ret_line + '>> - checking connectivity of:'.col_status
                puts $ret_line + name + ' -- ' + val[1] + ':' + val[2]
                threads << Thread.new {
                    require 'check_connectivity'
                    check_connectivity(name, val[1], val[2])
                }

            else
                puts $ret_line + 'error: '.col_red + val[0].col_red_bg,
                ' <-- sorry, i dont know what to do with this..'.col_red
        end
    end
    puts $ret_line + "<<------------[[[[ FINISHED ROUND ".col_status + i.to_s.col_blue + " ]]]]------------>>\n".col_status

rescue => e
    err(e, 'dispatcher exception', 'dispatcher')
ensure
    threads.each { |thread| thread.join }
end until i == list['iterations']