Vagrant.configure("2") do |config|
  # Load Balancer
  config.vm.define "loadbalancer" do |lb|
    lb.vm.box = "ubuntu/jammy64"
    lb.vm.network "private_network", ip: "192.168.70.100"
    lb.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
    lb.vm.provision "shell", inline: <<-SHELL
      apt update
      apt install -y nginx
    SHELL
  end

  # Web Servers
  (1..4).each do |i|
    config.vm.define "web#{i}" do |web|
      web.vm.box = "ubuntu/jammy64"
      web.vm.network "private_network", ip: "192.168.70.10#{i}"
      web.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      web.vm.synced_folder "./frontend/build", "/var/www/tour-app"
      web.vm.provision "shell", inline: <<-SHELL
        apt update
        apt install -y nginx
        rm -rf /var/www/html
        ln -s /var/www/tour-app /var/www/html
      SHELL
    end
  end
end