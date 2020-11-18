Vagrant.configure("2") do |config|
  config.vm.define "microk8sbox" do |microk8sbox|
    microk8sbox.vm.box = "ubuntu/xenial64"
    microk8sbox.vm.hostname = "microk8sbox"
    microk8sbox.vm.network "forwarded_port", guest: 10443, host: 10443, protocol: "tcp"
    microk8sbox.vm.network "forwarded_port", guest: 10443, host: 10443, protocol: "udp"
    microk8sbox.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp"
    microk8sbox.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "udp"
    microk8sbox.vm.network "public_network", 
      use_dhcp_assigned_default_route: true
    microk8sbox.vm.boot_timeout = 6000
    microk8sbox.vm.disk :disk, size: "10GB", primary: true

    microk8sbox.vm.provider "virtualbox" do |vb|
      vb.name = "microk8sbox"
      vb.memory = 8096
      vb.cpus = 6     
    end
        
    microk8sbox.vm.provision "shell", path: "provision_script.sh" 

  end
end
