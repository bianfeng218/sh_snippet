#!/usr/bin/python
# Filename: dumpdbstructanddata.py

import sys
import os

if len(sys.argv) < 3:
	print '''please input database name
syntax:python dumpdbstructanddata.py dbname dbhost;
example: python dumpstructanddata.py ept_order 10.28.168.38'''
else:
	db = sys.argv[1]
        dbhost = sys.argv[2]
	print 'database name is',db
	print 'start dump %s'%db
	dump_command = "mysqldump -uroot -h%s -p123456 -B %s |sed 's/AUTO_INCREMENT=[0-9]*\s//g' > %s.sql" % (dbhost,db,db)
	os.system(dump_command)

print "Done!"
