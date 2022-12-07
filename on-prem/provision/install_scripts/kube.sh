#!/usr/bin/env bash

lsb_release -a
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

if [ "$1" = 'master' ]; then
  sudo apt-mark hold kubelet kubeadm kubectl
  sudo systemctl enable --now kubelet
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=/run/containerd/containerd.sock > kube_details.txt 
    
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  vim ~/.kube/config 
  sudo chown -R $(id -u):$(id -g) $HOME/.kube/config
  kubectl taint nodes --all node-role.kubernetes.io/master-
  kubectl get nodes
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  kubectl get nodes

elif  [ "$1" = 'worker' ]; then
  sudo systemctl enable --now kubelet
  # joining command have to get from the master node

fi