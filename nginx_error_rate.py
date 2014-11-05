#!/usr/bin/env python
# coding: utf-8
#
# Usage
#
# [nginx_error_rate]
# env.access_log = /path/to/access.log
#


#%# family=auto
#%# capabilities=autoconf

import os
import datetime as dt
import re
from collections import defaultdict

error_code = re.compile(r'(50[0-5])')

def parse_line(string):
    line = string.decode('utf-8').rstrip()
    return dict([x.split(':', 1) for x in line.split('\t')])

def main():
    #/var/log/nginx/access.log
    access_log = os.path.abspath(os.path.expanduser(os.environ.get('access_log', '/var/log/nginx/access.log')))
    if not os.path.exists(access_log):
        return

    # minutes
    term_long = 15
    term_short = 5

    now = dt.datetime.now()
    term_long_ago = now - dt.timedelta(minutes=term_long)
    term_short_ago = now - dt.timedelta(minutes=term_short)
    by_second_term_long = defaultdict(lambda: 0)
    by_second_term_short = defaultdict(lambda: 0)

    with open(access_log) as fi:
        
        for line in fi:
           line_items = parse_line(line)

           # 15/Mar/2013:12:59:10 +0900
           access_time = dt.datetime.strptime(line_items['time'][:-6], '%d/%b/%Y:%H:%M:%S')

           if access_time < term_long_ago:
               continue

           match = error_code.match(line_items['status'])

           if match is None:
               continue

           by_second_term_long[access_time] += 1

           if access_time >= term_short_ago:
               by_second_term_short[access_time] += 1

    total_term_long = sum(by_second_term_long.itervalues())
    total_term_short = sum(by_second_term_short.itervalues())
    avg_term_long = total_term_long / (term_long * 60.0) if by_second_term_long else 0.0
    avg_term_short = total_term_short / (term_short * 60.0) if by_second_term_short else 0.0

    print 'errors_5m.value', avg_term_short
    print 'errors_15m.value', avg_term_long

def config():
    print 'graph_title Nginx error rate'
    print 'graph_category nginx'
    print 'graph_vlabel Errors per second'
    print 'errors_5m.label Errors per second over 5 minutes'
    print 'errors_15m.label Errors per second over 15 minutes'

if __name__ == '__main__':
    from optparse import OptionParser
    parser = OptionParser()
    (options, args) = parser.parse_args()
    if len(args) > 1:
        parser.error('Too many arguments.')
    elif len(args) < 1:
        main()
    elif args[0] == 'config':
        config()

