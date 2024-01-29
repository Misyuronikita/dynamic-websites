#!/bin/bash
/usr/bin/yum -y install httpd
/sbin/chkconfig httpd on
/sbin/service httpd start
/bin/echo “Welcome to my web server. My private IP is” > /var/www/html/index.html
 /opt/aws/bin/ec2-metadata -o | /bin/cut -d: -f2 | /bin/cut -d" " -f2 >> /var/www/html/index.html