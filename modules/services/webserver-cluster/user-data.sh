#!/bin/bash
cat > /var/www/html/index.html <<EOF
<h1>Hello, World!</h1>
<p>DB Address: ${db_address}</p>
<p>DB Port: ${db_port}</p>
EOF

yum update -y
yum install -y httpd
sed -i "s/Listen 80/Listen ${server_port}/" /etc/httpd/conf/httpd.conf
systemctl enable httpd
systemctl start httpd
echo "<h1>Hello, World!</h1><p>DB Address: ${db_address}</p><p>DB Port: ${db_port}</p>" > /var/www/html/index.html