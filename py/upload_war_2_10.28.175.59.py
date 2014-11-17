#!/usr/bin/python
# Filename: upload_war_2_10.28.175.59.py
# target_host:10.28.175.59 root/cdyanfa

import sys
import os

if len(sys.argv) < 3:
	print '''
example:python upload_war_2_10.28.175.59.py user.vsp.jd.com xxxxx.war'''
else:
        dest = "/export/data/tomcatRoot/"
	warFile = sys.argv[2]
        domain = sys.argv[1]
	print 'start trasfer %s to 10.28.175.59:/export/data/tomcatRoot/%s' % (warFile,domain)
	trasfer_command = "scp %s root@10.28.175.59:/export/data/tomcatRoot/%s" % (warFile,domain)
	os.system(trasfer_command)

print "Done!"
