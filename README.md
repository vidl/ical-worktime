ical-worktime
=============

Create workreports from Apple iCal.

The basic idea is to use a dedicated, local calendar in Apples iCal to track the work.
Add an event for each task you're working on. Use copy/paste or dublicate to reuse events from the past. Modify easily the duration by resizing or the start bei dragging.

At the end of the day, run the here provided script on a terminal to get a
workreport.


Example Report
==============  

```
========== 06.11.2013 ==========
Project1:
    0.75 did something 
Project2:
    0.25 did nothing 
    2.00 stop manager doing something 
project3:
    0.50 test feature x 
    0.25 fix bug y
    1.25 deploy 
    0.25 documentation 
--------------------------------
Worked: 5.25
```

Versions
========
The script does not use an official API to access the calendards data:
it accesses directly the database, where iCal stores it's data. The schema of
the database is subject to change - so with there are several releases for the
different OS versions.


Configuration
=============
The configuration has to be made directly in the script. Just set the variable
"cal_name" to the name of your calendar.

Usage
=====

The script takes one parameter: the number of days to display from now.

So -1 displays the workreports starting yesterday. 

Requirements
============
Mac OS X 10.7, 10.8 , 10.9, 10.11
