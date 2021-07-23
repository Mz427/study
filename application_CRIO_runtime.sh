#For Debian.
#Create the .conf file to load the modules at bootup:
printf 'overlay\nbr_netfilter\n' > /etc/modules-load.d/crio.conf
modprobe overlay
modprobe br_netfilter

#Set up required sysctl params, these persist across reboots:
printf 'net.bridge.bridge-nf-call-arptables = 1\nnet.bridge.bridge-nf-call-iptables  = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.ipv4.ip_forward = 1\n' > /etc/sysctl.d/99-kubernetes-cri.conf
sysctl --system

#Install tools required:
apt-get update
apt-get install curl gnupg apt-transport-https ca-certificates

#If installing cri-o-runc (recommended), you'll need to install libseccomp >= 2.4.1.
#This is not available in distros based on Debian buster or below, so buster backports will need to be enabled:
printf 'deb http://mirrors.aliyun.com/debian buster-backports main\n' > /etc/apt/sources.list.d/backports.list
#echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list
#Add cri-o source:
export OS=Debian_Unstable
export VERSION=1.21

printf "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/${VERSION}/${OS}/ /\n" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:${VERSION}.list
printf "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/${OS}/ /\n" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:${VERSION}/${OS}/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/${OS}/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

apt update
apt-cache madison libseccomp2
apt install libseccomp2=2.4.4-1~bpo10+1

#Install cri-o and cri-o-runc:
apt-get update
apt-get install cri-o cri-o-runc

#CRI-O uses the systemd cgroup driver per default. To switch to the cgroupfs cgroup driver:
printf '[crio.runtime]\nconmon_cgroup = "pod"\ncgroup_manager = "cgroupfs"\n' > /etc/crio/crio.conf.d/02-cgroup-manager.conf

#Start cri-o service:
systemctl daemon-reload
systemctl enable crio
systemctl start crio
