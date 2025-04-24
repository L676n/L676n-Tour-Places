Here's a template for your `README.md` file for the TourPlaces Inc. assignment. You can adjust the content as needed and add any specific details relevant to your implementation.

```markdown
# TourPlaces Inc. - Infrastructure Scaling Challenge

## Overview

This project involves deploying a React-based travel recommendation platform (`Tour-Places-App`) using Vagrant clusters to ensure high availability and scalability. The application is expected to handle over 5,000 daily users and requires 99.9% uptime during peak seasons.

## Assignment Tasks

### Part 1: Cluster Setup

1. **Clone the Repository**:
   The application was cloned into a `frontend` folder.

   ```bash
   git clone https://github.com/cw-barry/Tour-Places-App.git frontend
   ```

2. **Vagrantfile Configuration**:
   A `Vagrantfile` was created to set up the infrastructure with the following specifications:
   - **Load Balancer**: Ubuntu 22.04, 2GB RAM, IP: 192.168.70.100
   - **Web Servers**: Three Ubuntu 22.04 servers, each with 1GB RAM, IPs: 192.168.70.101, 192.168.70.102, and 192.168.70.103.
   - Configured to sync the build folder of the React app.

   ```ruby
   Vagrant.configure("2") do |config|
     config.vm.box = "ubuntu/jammy64"

     config.vm.define "load_balancer" do |lb|
       lb.vm.hostname = "load_balancer"
       lb.vm.network "private_network", ip: "192.168.70.100"
       lb.vm.provider "virtualbox" do |vb|
         vb.memory = "2048"
       end
     end

     (1..3).each do |i|
       config.vm.define "web#{i}" do |web|
         web.vm.hostname = "web#{i}"
         web.vm.network "private_network", ip: "192.168.70.10#{i}"
         web.vm.provider "virtualbox" do |vb|
           vb.memory = "1024"
         end
       end
     end

     config.vm.synced_folder "./frontend/build", "/var/www/tour-app"
   end
   ```

3. **Automated React Build**:
   The provisioning script ensures the React app is built during the setup process.

### Part 2: Load Balancer and Web Server Configuration

1. **Load Balancer Configuration**:
   The `lb-setup.sh` script installs NGINX and configures it as follows:

   - Creates `/etc/nginx/conf.d/tour-places.conf` to define upstream React web servers.
   - Listens on the default network port for HTTP.
   - Forwards requests to the upstream group while preserving original request information.
   - Removes the default NGINX welcome page.

   ```bash
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
   ```

2. **Web Server Configuration**:
   On each web server:
   - NGINX is installed.
   - The default web root directory is removed, and a symbolic link to the React app is created.

### Part 3: Failure Testing

1. **Simulated Server Failure**:
   The command `vagrant halt web2` was executed to simulate a server failure.

2. **Testing Load Balancer**:
   Ten consecutive curl tests were performed to verify that the load balancer automatically excludes the failed node.

   ```bash
   for i in {1..10}; do curl -I http://192.168.70.100; done
   ```

### Part 4: Scaling Challenge

1. **Adding a Fourth Web Server**:
   A fourth web server (`web4` at IP 192.168.70.104) was added to the configuration.

2. **Modifying Load Balancer Configuration**:
   The load balancer configuration was updated without manual file editing using:

   ```bash
   sed -i '/upstream react_servers {/a     server 192.168.70.104;' /etc/nginx/conf.d/tour-places.conf
   ```

3. **Verification**:
   Verified the setup by running:

   ```bash
   for i in {1..5}; do curl http://192.168.70.100; done
   ```

## Deliverables

- **Vagrantfile**: Included in the repository.
- **lb-setup.sh**: Script for load balancer setup.
- **Screenshots**: 
  - Vagrant status showing all running VMs.
  - Curl tests showing only 2 servers responding after simulating failure.
  
## Conclusion

This project demonstrates the deployment and scaling of a React application using Vagrant and NGINX. The infrastructure is designed to ensure high availability and can be further scaled as needed.

## References

- [Tour-Places-App GitHub Repository](https://github.com/cw-barry/Tour-Places-App.git)
```