#!/usr/bin/python
# Filename: dumpdbstruct.py


import sys
import os

if len(sys.argv) < 2:
	print '''please input database name,
syntax:python dumpdbstruct.py dbname;
example: python dumpdbstruct.py ept_order'''
else:
	db = sys.argv[1]
	print 'database name is',db
	print 'start dump %s'%db
	dump_command = "mysqldump -uroot -h10.28.174.200 -p123456 -B %s --no-data |sed 's/AUTO_INCREMENT=[0-9]*\s//g' > %s.sql" % (db,db)
	os.system(dump_command)

print "Done!"
