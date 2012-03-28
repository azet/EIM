#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   Alerting..
#                * Notification Groups
#                * SMS/HLR Gateway 
#                (http://en.wikipedia.org/wiki/Mobile_Application_Part)
#                * SMTP Alerting via Gateway / Server
#
########################################################################

# get notfiy group and data for alert:
def notify_groups(checkname)
    result = []
    groups = $config['checks'][checkname].find { |hash| hash['notify'] }
    groups.each_value do
        $config['notification-groups'].map { |x| result += x }
    end
    return result
end


# SMS/HLR Gateway:
def send_sms(txt, param, name)    
    require 'cgi'
    require 'open-uri'

    puts $ret_line + "trying to send alert short message to ".col_blue + $config['ss7-gw']['msin'].to_s.col_blue
    begin
        msin = notify_groups(name).delete_if { |x| x.nil? or not x["msin"] }
        msin.each do |phoneno|
            msin = phoneno["msin"]
            auth_string_part = "?id=" + $config['ss7-gw']['id'].to_s + "&pass=" + $config['ss7-gw']['pass'].to_s + "&nummer=" + msin.to_s        
            hlr = open($config['ss7-gw']['hlr-api'].to_s + auth_string_part + "&plus=1").read
            if hlr =~ /err:0/
                puts $ret_line + "hlr-lookup ok. phone is subscribed in telco network..".col_blue
                sms = open($config['ss7-gw']['sms-api'].to_s + auth_string_part + "&absender=" + $config['ss7-gw']['sender'].to_s + "&text=" + CGI.escape(name + ' ' + txt + ' -- err.: ' + param)).read
                if sms =~ /err:0/
                    puts $ret_line + "alert sms sent to " + msin.to_s + " - OK".col_status
                else
                    puts $ret_line + "alert sms - FAILED! - ".col_red + sms
                end
            else
                puts $ret_line + "hlr-lookup - FAILED! - ".col_red + hlr
            end
        end
    rescue => sms_err
        puts $ret_line + "sms - FAILED! - ".col_red + sms_err
        exit
    end
end
    

# SMTP Gateway:
def send_mail(txt, param, name)
    require 'net/smtp'

    puts $ret_line + "trying to send alert e-mail to ".col_blue + $config['mail-gw']['recipient'].to_s.col_blue
    begin
        rcpt = notify_groups(name).delete_if { |x| x.nil? or not x["mail"] }
        rcpt.each do |mailaddress|
            rcpt = mailaddress["mail"]
            Net::SMTP.start($config['mail-gw']['host'], 25, $config['mail-gw']['sender_domain'], $config['mail-gw']['user'], $config['mail-gw']['pass']) do |smtp|
                body = $config['mail-gw']['message_body'].gsub('%{alertname}', name), txt, ' -- err.: ', param
                if smtp.send_message body, $config['mail-gw']['sender'].to_s, rcpt.to_s
                  puts $ret_line + "sent alert mail to " + $config['mail-gw']['recipient'] + " - OK".col_status
                else
                  raise "can't send mail."
                end
            end
        end
    rescue => mail_err
        puts $ret_line + "mail - FAILED! - ".col_red + mail_err
        exit
    end
end