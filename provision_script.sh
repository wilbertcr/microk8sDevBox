#!/bin/bash
# Proper header for a Bash script.

sudo apt-get update
snap install microk8s --classic
microk8s.status --wait-ready
snap install docker
sudo usermod -a -G microk8s vagrant #Add vagrant user to microk8s group
sudo chown -f -R vagrant ~/.kube #make vagrant the owner of the ~/.kube folder.
touch ~/.bash_aliases #Create ~/.bash_aliases file
echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases #populate ~/.bash_aliases file with the kubectl alias.
chown root:root ~/.bash_aliases #update so the owner of ~/.bash_aliases is root.
shopt -s expand_aliases #Interactive shells don't use aliases unless we expand them.
source ~/.bash_aliases #Load new alias.

microk8s enable dns host-access registry dashboard ingress helm 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa