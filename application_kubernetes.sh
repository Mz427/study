#####################################################################################################################
#                                         Kubernetes cluster
#####################################################################################################################
#Kubernetes consists of blow module:
#Control-plane node(s):
Name                    Protocol Direction Port Range	Purpose	                Used By
kube-apiserver          TCP      Inbound   6443*	    Kubernetes API server	All
etcd                    TCP      Inbound   2379-2380    etcd server client API	kube-apiserver, etcd
kubelet                 TCP      Inbound   10250	    kubelet API	            Self, Control plane
kube-scheduler          TCP      Inbound   10251	    kube-scheduler	        Self
kube-controller-manager TCP      Inbound   10252	    kube-controller-manager	Self
#Worker node(s):
Name                    Protocol Direction Port Range	 Purpose	            Used By
kubelet                 TCP      Inbound   10250	     kubelet API	        Self, Control plane
kube-proxy              TCP      Inbound   30000-32767   NodePort Services      All
CRI-O                   -        -         -             container runtime      Self, other runtime: docker, containerd

#####################################################################################################################
#                                          Install step(binary)
#####################################################################################################################
#Install Kubernetes master on Debian.
#Install Kubernetes node on CentOS.
#System required:
#2 CPU or more, 2GB or more RAM.

#--1 Preparation(All machines require.)
#Disable swap:
swapoff -a #Or edit /etc/fstab.
#Disable firewall:
systemctl stop firewall
systemctl disable firewall
#Disable selinux:
sed -i 's/^SELINUX=.\*/SELINUX=disabled/' /etc/selinux/config #Or edit /etc/selinux/config.
#Set system time:
timedatectl

#--2 Get required binary tar:
wget https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz
#https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.23.md#server-binaries
wget https://dl.k8s.io/v1.23.5/kubernetes-server-linux-amd64.tar.gz

#--3 Install etcd:
cd /opt
mkdir -p etcd/{bin,etc,ssl}
tar -xzv -f etcd-v3.5.2-linux-amd64.tar.gz
cp etcd-v3.5.2-linux-amd64/etcd* /usr/local/bin/
cat > etcd/etc/etcd.conf << EOF
#[Member]
ETCD_NAME="etcd-master1" #不同节点需要更改
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.9.7.199:2380" #不同节点需要更改
ETCD_LISTEN_CLIENT_URLS="https://10.9.7.199:2379" #不同节点需要更改
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.9.7.199:2380" #不同节点需要更改
ETCD_ADVERTISE_CLIENT_URLS="https://10.9.7.199:2379" #不同节点需要更改
ETCD_INITIAL_CLUSTER="etcd-master1=https://10.9.7.199:2380,etcd-master2=https://10.9.7.198:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

cat > /usr/lib/systemd/system/etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=/opt/etcd/etc/etcd.conf
ExecStart=/usr/local/bin/etcd \
    --cert-file=/opt/etcd/ssl/server.pem \
    --key-file=/opt/etcd/ssl/server-key.pem \
    --peer-cert-file=/opt/etcd/ssl/server.pem \
    --peer-key-file=/opt/etcd/ssl/server-key.pem \
    --trusted-ca-file=/opt/etcd/ssl/ca.pem \
    --peer-trusted-ca-file=/opt/etcd/ssl/ca.pem
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

#Create CA.
openssl

systemctl enable etcd
systemctl start etcd

#--4 Install kubernetes(master1,2):
tar -xzv -f kubernetes-server-linux-amd64.tar.gz

#####################################################################################################################
#                                          Install step(kubeadm)
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
