#linux网络管理.
#查看所有网卡信息:
ip [-4][-6] a(ddr) #a=address.
ip a(ddr) show ens37 #显示特定网卡信息.
#设置网卡ip地址:
ip a(ddr) add 192.168.1.1/255.255.255.0 dev ens37
ip a(ddr) add 192.168.1.1/24 dev ens37
#删除网卡ip信息:
ip a(ddr) del 192.168.1.1/255.255.255.0 dev ens37

#查看数据链路层信息:
ip link
ip link ls up/down #查看启用/关闭的网卡.
#启用/禁用网卡:
ip link set dev ens37 up
ip link set dev ens37 down
ip link set mtu 1500 dev ens37 #设置mtu值.

#路由表信息:
ip route show #route -n
ip route [add][del] 192.168.1.123 via 192.168.1.1 dev ens37 #添加/删除路由信息.

#arp表:
ip neigh(bor) show
ip neigh(bor) flush dev ens37 #刷新arp表.

#传统网络管理服务:
#systemctl-NetworkManager.service
#配置文件位置:
/etc/sysconfig/network-scripts/ifcfg-ens32 #CentOS.
/etc/network/interfaces #Debian.

#NetworkManager tools
nmcli

#systemd-networkd.service:
    networkctl
#Set hostname.
    hostnamectl set-hostname hostname
