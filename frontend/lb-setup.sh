#!/bin/bash

# Install NGINX
apt update
apt install -y nginx

# Configure NGINX
cat <<EOL > /etc/nginx/conf.d/tour-places.conf
upstream react_servers {
    server 192.168.70.101;
    server 192.168.70.102;
    server 192.168.70.103;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://react_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOL

# Remove default config and test syntax
rm /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx