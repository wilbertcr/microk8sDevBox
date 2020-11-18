#!/bin/bash
# Proper header for a Bash script.

sudo apt-get update #update package manager.
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/ #install skaffold.
snap install docker #install docker.
snap install microk8s --classic --channel=1.19/stable #install microk8s.
microk8s.status --wait-ready #After installing microk8s, wait for it to be ready, otherwise there'll be trouble.
sudo microk8s kubectl config view --raw > $HOME/.kube/config #Get the kubectl config down to the host vm.
sudo usermod -a -G microk8s vagrant #Add vagrant user to microk8s group
sudo chown -f -R vagrant ~/.kube #make vagrant the owner of the ~/.kube folder.
touch ~/.bash_aliases #Create ~/.bash_aliases file
echo "alias kubectl='microk8s kubectl'" >> ~/.bash_aliases #populate ~/.bash_aliases file with the kubectl alias.
chown root:root ~/.bash_aliases #update so the owner of ~/.bash_aliases is root.
shopt -s expand_aliases #Interactive shells don't use aliases unless we expand them.
source ~/.bash_aliases #Load new alias.
sudo snap alias microk8s.kubectl kubectl #Create snap alias
microk8s enable dns ingress storage #enable kubernetes add-ons
echo "Waiting for 30 seconds after enabling plugins."
sleep 30s #Give microk8s a chance. Some stuff gets deployed in line 19 and it is best to wait for it to be ready.
sudo microk8s kubectl get -o yaml -n kube-system deploy hostpath-provisioner | \
  sed 's~/var/snap/microk8s/common/default-storage~/data/snap/microk8s/common/default-storage~g' | \
  sudo microk8s kubectl apply -f - #Deploy hostpath-provisioner.

# restart microk8s for good measure
sudo microk8s stop && sudo microk8s start
sudo microk8s enable registry helm dashboard #Enable other add-ons.

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
