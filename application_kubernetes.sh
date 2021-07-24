#####################################################################################################################
#                                         Kubernetes cluster
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
#                                          Install step
#####################################################################################################################
#Install Kubernetes on debian10.
#System required:
2 CPU or more, disable SWAP, 2GB or more RAM.
#Disable swap:
swapoff -a #Or edit /etc/fstab.
#Edit kernel:
cat << EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-arptables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system

#Switch aliyun source:
cp /etc/apt/sources.list /etc/apt/sources.list.backup
cat << EOF | tee /etc/apt/sources.list
deb http://mirrors.aliyun.com/debian/ buster main
deb-src http://mirrors.aliyun.com/debian/ buster main
deb http://mirrors.aliyun.com/debian-security buster/updates main
deb-src http://mirrors.aliyun.com/debian-security buster/updates main
deb http://mirrors.aliyun.com/debian/ buster-updates main
deb-src http://mirrors.aliyun.com/debian/ buster-updates main
EOF
#Add kubernetes source:
cat << EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
#Google kubernetes source:
#deb http://apt.kubernetes.io/ kubernetes-xenial main

#Install tools required:
apt-get update curl gnupg apt-transport-https ca-certificates

#Download the signing key:
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
#Google source signing key:
#curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

#Update apt package index with the new repository and install kubectl:
apt-get update
apt-get install -y kubectl kubeadm [kubelet]

#####################################################################################################################
#                                          Setup cluster
#####################################################################################################################
#Create the actual cluster:
#k8s.gcr.io
crictl pull coredns/coredns:1.8.0

#Init kubernetes cluster:
kubeadm config print init-defaults > kubeadm.yaml
kubeadm config images list [--kubernetes-version <version>]
#podman pull registry.aliyuncs.com/google_containers/kube-apiserver:v1.21.3
#podman pull registry.aliyuncs.com/google_containers/kube-controller-manager:v1.21.3
#podman pull registry.aliyuncs.com/google_containers/kube-scheduler:v1.21.3
#podman pull registry.aliyuncs.com/google_containers/kube-proxy:v1.21.3
#podman pull registry.aliyuncs.com/google_containers/pause:3.4.1
#podman pull registry.aliyuncs.com/google_containers/etcd:3.4.13-0
#podman pull coredns/coredns:v1.8.0

kubeadm init --config=kubeadm.yaml
#kubeadm init --pod-network-cidr=10.9.7.0/24 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v1.21.2
mkdir -p ${HOME}/.kube
cp -i /etc/kubernetes/admin.conf ${HOME}/.kube/config
chown $(id -u):$(id -g) ${HOME}/.kube/config
kubeadm config print join-defaults > kubeadm.yaml
kubeadm join
#Install network plugin:
