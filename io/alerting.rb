#!/usr/bin/env ruby
########################################################################
#
#  developer:    aaron.zauner@emarsys.com
#  descr_self:   Alerting..
#                * SMS/HLR Gateway 
#                 (http://en.wikipedia.org/wiki/Mobile_Application_Part)
#                * SMTP Alerting via Gateway / Server
#
########################################################################

# SMS/HLR Gateway:
def send_sms(txt, param)
    require 'cgi'
    require 'open-uri'
    require 'yaml'
    config = YAML.load_file 'config.yaml'
    
    puts $ret_line + "trying to send alert short message to ".col_blue + config['ss7-gw']['msin'].to_s.col_blue
    auth_string_part = "?id=" + config['ss7-gw']['id'].to_s + "&pass=" + config['ss7-gw']['pass'].to_s + "&nummer=" + config['ss7-gw']['msin'].to_s        
    hlr = open(config['ss7-gw']['hlr-api'].to_s + auth_string_part + "&plus=1").read
    if hlr =~ /err:0/
        puts $ret_line + "hlr-lookup ok. phone is subscribed in telco network..".col_blue
        sms = open(config['ss7-gw']['sms-api'].to_s + auth_string_part + "&absender=" + config['ss7-gw']['sender'].to_s + "&text=" + CGI.escape(txt + ' -- err.: ' + param)).read
        if sms =~ /err:0/
            puts $ret_line + "alert sms sent to " + config['ss7-gw']['msin'].to_s + " - OK".col_status
        else
            puts $ret_line + "alert sms - FAILED! - ".col_red + sms
        end
    else
        puts $ret_line + "hlr-lookup - FAILED! - ".col_red + hlr
    end
end
    

# SMTP Gateway:
def send_mail(txt, param, name)
    require 'net/smtp'
    require 'yaml'
    config = YAML.load_file 'config.yaml'
    
    puts $ret_line + "trying to send alert e-mail to ".col_blue + config['mail-gw']['recipient'].to_s.col_blue
    begin
        Net::SMTP.start(config['mail-gw']['host'], 25, config['mail-gw']['sender_domain'], config['mail-gw']['user'], config['mail-gw']['pass']) do |smtp|
            body = config['mail-gw']['message_body'].gsub('%{alertname}', name), txt, ' -- err.: ', param
            if smtp.send_message body, config['mail-gw']['sender'].to_s, config['mail-gw']['recipient'].to_s
              puts $ret_line + "sent alert mail to " + config['mail-gw']['recipient'] + " - OK".col_status
            else
              raise "can't send mail."
            end
        end
    rescue => mail_err
        puts $ret_line + "mail - FAILED! - ".col_red + mail_err
        puts "!emergency exit!"
        exit
    end
end
