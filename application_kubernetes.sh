#####################################################################################################################
#
#####################################################################################################################
#Kubernetes consists of blow module:
#Control-plane node(s):
Protocol	Direction	Port Range	Purpose	                Used By
TCP	        Inbound	    6443*	    Kubernetes API server	All
TCP	        Inbound	    2379-2380   etcd server client API	kube-apiserver, etcd
TCP	        Inbound	    10250	    kubelet API	            Self, Control plane
TCP	        Inbound	    10251	    kube-scheduler	        Self
TCP	        Inbound	    10252	    kube-controller-manager	Self
#Worker node(s):
Protocol	Direction	Port Range	Purpose	                Used By
TCP	        Inbound	    10250	    kubelet API	            Self, Control plane
TCP	        Inbound	    30000-32767	NodePort Services       All

#####################################################################################################################
#
#####################################################################################################################
#Install Kubernetes on debian10.
#System required:
2 CPU or more, disable SWAP, 2GB or more RAM.
#Install tools required.
apt-get update
apt-get install curl
apt-get install gnupg
apt-get install apt-transport-https
apt-get install ca-certificates

#Update apt source list.
#vi /etc/apt/source.list
deb http://mirrors.aliyun.com/debian/ buster main
deb-src http://mirrors.aliyun.com/debian/ buster main
deb http://mirrors.aliyun.com/debian-security buster/updates main
deb-src http://mirrors.aliyun.com/debian-security buster/updates main
deb http://mirrors.aliyun.com/debian/ buster-updates main
deb-src http://mirrors.aliyun.com/debian/ buster-updates main
#vi /etc/apt/sources.list.d/kubernetes.list
deb  https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

#Backup source configuration file:
cp /etc/apt/sources.list /etc/apt/source.list.bak
#Download the Google Cloud public signing key:
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list
#Add aliyun source:
#printf "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" >> /etc/apt/source.list

#Update apt package index with the new repository and install kubectl:
sudo apt-get update
sudo apt-get install -y kubectl
sudo apt-get install -y kubeadm [kubelet]
