Vagrant.configure("2") do |config|
  config.vm.define "microk8s" do |microk8s|
    microk8s.vm.box = "ubuntu/xenial64"
    microk8s.vm.hostname = "microk8s"
    microk8s.vm.network "forwarded_port", guest: 10443, host: 10443, protocol: "tcp"
    microk8s.vm.network "forwarded_port", guest: 10443, host: 10443, protocol: "udp"
    microk8s.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp"
    microk8s.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "udp"
    microk8s.vm.network "public_network", 
      use_dhcp_assigned_default_route: true
    microk8s.vm.boot_timeout = 6000
    microk8s.vm.disk :disk, size: "10GB", primary: true

    microk8s.vm.provider "virtualbox" do |vb|
      vb.name = "microk8s"
      vb.memory = 4096
      vb.cpus = 2     
    end
    
    microk8s.vm.provision "shell", inline: <<-EOF
      snap install microk8s --classic
      snap install docker
      snap install kubectl --classic
      kubectl version --client      
      microk8s.status --wait-ready
      microk8s.enable dns dashboard registry host-access
      microk8s.kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
      microk8s.kubectl create serviceaccount dashboard-admin-sa
      microk8s.kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa      
      usermod -a -G microk8s vagrant      
      echo "alias kubectl='microk8s.kubectl'" > /root/.bash_aliases
      ls
      chown root:root /root/.bash_aliases
    EOF
  end
end