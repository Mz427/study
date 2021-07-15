#Ssh隧道相关参数:
-N #告诉SSH客户端, 这个连接不需要执行任何命令, 仅仅做端口转发.
-f #告诉SSH客户端在后台运行.
-L #本地转发.
-R #远程转发.
-D #动态转发.
-C #数据压缩.

#Ssh tunnel：
#A:本地主机; B:中转主机; C:目标主机.
#本地转发, 在A主机执行:
ssh -f -N -L [A_ip:]A_port:C_IP:C_port [root@B_IP] #中转服务器
#远程转发, 在C主机执行:
#ssh的配置要添加:GatewayPorts=yes, AllowTcpForwarding=yes; 重启ssh服务.
#如果不是用的root用户建立隧道, 那么在B机器上只能监听本地127.0.0.1端口.
ssh -f -N -R B_port:C_IP:C_port root@B_IP
#动态转发.
ssh -f -N -D root@B_IP
