#!/usr/bin/python

import sqlite3
import os
import datetime
import calendar
import sys

cal_name = 'Arbeitszeit'
cal_db =  os.path.expanduser('~/Library/Calendars/Calendar Cache')

days_to_show = 0
if len(sys.argv) > 1: days_to_show = int(sys.argv[1])

apple_epoche = calendar.timegm((2001, 1,1, 0,0,0))

startdate = datetime.datetime.today().replace(hour=0,minute=0,second=0,microsecond=0) + datetime.timedelta(days=days_to_show)
startdate = calendar.timegm(startdate.timetuple()) - apple_epoche

startdate_expr = "strftime('%s', item.zstartdate, 'unixepoch', '+%d seconds')" % ('%d.%m.%Y', apple_epoche)
startdate_sort = "strftime('%s', item.zstartdate, 'unixepoch', '+%d seconds')" % ('%Y-%m-%d', apple_epoche)

sql = "select %s, item.ztitle, sum((item.zenddate-item.zstartdate)/3600.0), item.zlocationtitle, item.znotes " % startdate_expr
sql += "from zicselement as item inner join znode as cal on item.zcalendar = cal.z_pk "
sql += "where cal.ztitle = '%s' " % cal_name
sql += "and  item.zstartdate >= %d " % startdate
sql += "group by item.ztitle, item.zlocationtitle, item.znotes, %s " % startdate_expr
sql += "order by %s, item.zlocationtitle, item.ztitle, item.znotes" % startdate_sort


conn = sqlite3.connect(cal_db)
cursor = conn.cursor()
cursor.execute(sql)

last_day = None
last_proj = None
worked = 0
for row in cursor:
    day = row[0]
    if last_day == None: 
        last_day = day
        last_proj = None
        print "========== %s ==========" % day
    if last_day != day:
        print '--------------------------------'
        print "Worked: %0.2f" % worked
        print
        print "========== %s ==========" % day
        last_day = day
        worked = 0
    comment = row[1]
    duration = row[2]
    project = row[3]
    activity = row[4]
    if activity == None: activity = ""
    worked += float(duration)
    if last_proj != project:
        last_proj = project
        print "%s:" % project        
    print "    %0.2f %s %s" % (duration, comment, activity)

print '--------------------------------'
print "Worked: %0.2f" % worked

