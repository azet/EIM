README
======

this script is intended to run offsite (vserver/dedicated/..) as a replacement for alerting services like internetvista.com.
it is a threaded ruby script. so far i've tested ~200 url/ping checks in under two seconds on a single core VM with 512mb ram.
this readme file will (probably) be extended soon.


requirements:
-------------
- ruby 1.8+
- sendmail (or equivalent)
- sms gateway (if needed)


setup:
------
- git clone
- mv config.yaml.default config.yaml ; vi config.yaml
- chmod +x dispatch.rb
- install 'crontab' file


todo:
-----
- error type in mail subjects
- notification groups
- anti spam functionality (in case of massive failure)
- jruby support


author:
-------
Aaron <azet> Zauner
azet@azet.org


licensing:
----------
see LICENSE