README
======

this script is intended to run offsite (vserver/dedicated/..) as a replacement for alerting services like internetvista.com
it is a threaded ruby script. so far i've tested ~200 url/ping checks in under two seconds on a single core VM with 512mb ram.


requirements:
-------------
- ruby 1.8
- sendmail (or equivalent)
- sms gateway (if needed)


setup:
------
- git clone
- mv config.yaml.default config.yaml ; vi config.yaml
- chmod +x dispatch.rb
- install 'crontab' file


misc.:
------
`ruby dispatch.rb | grep OK` will, of course, output all OK messages.
`ruby dispatch.rb | egrep '(error|FAILURE)'` will output all errors.


todo:
-----
- error type in mail subjects
- notification groups
- anti spam functionality (in case of massive failure)
- useful readme file
- jruby support


author:
-------
Aaron <azet> Zauner - azet@azet.org


licensing:
----------
see LICENSE