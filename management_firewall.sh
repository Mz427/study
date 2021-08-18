########################################################################################################
#                                                iptables
########################################################################################################

########################################################################################################
#                                                firewall
########################################################################################################
#Firewalld是CentOS 7.0新推出的管理netfilter的用户空间软件工具,firewalld服务由firewalld包提供
#firewalld支持划分区域zone,每个zone可以设置独立的防火墙规则.
#firewalld中常用的区域名称及策略规则:
    区域（noze） 默认策略规则
    trusted	     允许所有的数据包进出
    home         拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、mdns、ipp-client、amba-client与dhcpv6-client服务相关，则允许进入
    Internal     等同于home区域
    work         拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、ipp-client与dhcpv6-client服务相关，则允许进入
    public       拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh、dhcpv6-client服务相关，则允许进入
    external     拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh服务相关，则允许进入
    dmz          拒绝进入的流量，除非与出去的流量相关；而如果流量与ssh服务相关，则允许进入
    block        拒绝进入的流量，除非与出去的流量相关
    drop         拒绝进入的流量，除非与出去的流量相关
#注意：firewalld默认出口是全放开的.

#Firewall 主要文件:
    /usr/lib/firewalld #系统配置文件，预定义配置
    /etc/firewalld/    #用户配置文件
        |--firewalld.conf
        |--helpers
        |--icmptypes
        |--ipsets
        |--lockdown-whitelist.xml
        |--services
        |--zones
            |--public.xml
            |--public.xml.old

#Firewalld有基于CLI（命令行界面）和基于GUI（图形用户界面)两种管理方式，即：firewall-cmd（终端管理工具）
#和firewall-config（图形管理工具）。如果要使用firewall-config需要安装：
yum -y install firewall-config

#firewall-cmd操作:
Status Options:
    --version              #查看版本
    --help                 #查看帮助信息
    --state                #返回并打印防火墙状态
    --reload               #重新加载防火墙并保留状态信息
    --check-config         #检查永久性配置是否有错误

Log Denied Options:
    --get-log-denied         #打印被拒绝的日志
    --set-log-denied=<value> #设置日志拒绝值

Permanent Options
    --permanent #永久设置一个选项（可用于标有[P]的选项）

Zone Options
    --get-default-zone                  #打印连接和接口的默认区域
    --set-default-zone=<zone>           #设置默认区域
    --get-active-zones                  #打印当前活动区域
    --get-zones                         #打印预定义区域[P]
    --get-services                      #打印预定义的服务[P]
    --get-icmptypes                     #打印预定义的icmptypes[P]
    --get-zone-of-interface=<interface> #打印接口绑定到的区域名称[P]
    --get-zone-of-source=<source>[/<mask>]|<MAC>|ipset:<ipset> #打印源绑定到的区域名称[P]
    --list-all-zones                                           #列出为所有区域添加或启用的所有内容[P]
    --new-zone=<zone>                                          #添加一个新区域[P only]
    --new-zone-from-file=<filename> [--name=<zone>]            #从文件中添加具有可选名称的新区域[P only]
    --delete-zone=<zone>        #删除现有区域[P only]
    --load-zone-defaults=<zone> #加载区域默认设置[P only][Z]
    --zone=<zone>               #使用此区域设置或查询选项，否则使用默认区域 (可用于标有[Z]的选项)

Options to Adapt and Query Zones
    --list-all                      #列出为区域添加或启用的所有内容[P][Z]
    --list-services                 #列出为区域添加的服务[P][Z]
    --list-ports                    #列出为区域添加的端口[P][Z]
    --add-port=<portid>[-<portid>]/<protocol>    #添加区域的端口[P][Z][T]
    --remove-port=<portid>[-<portid>]/<protocol> #从区域中删除端口[P][Z]
    --query-port=<portid>[-<portid>]/<protocol>  #返回是否已为区域添加端口[P][Z]
    --list-forward-ports                                #列出为区域添加的IPv4转发端口[P][Z]
    --add-forward-port=port=<portid>[-<portid>]:proto=<protocol>[:toport=<portid>[-<portid>]][:toaddr=<address>[/<mask>]]    #为区域添加IPv4转发端口[P][Z][T]
    --remove-forward-port=port=<portid>[-<portid>]:proto=<protocol>[:toport=<portid>[-<portid>]][:toaddr=<address>[/<mask>]] #从区域中删除IPv4转发端口[P][Z]
    --query-forward-port=port=<portid>[-<portid>]:proto=<protocol>[:toport=<portid>[-<portid>]][:toaddr=<address>[/<mask>]]  #返回是否为区域添加了IPv4转发端口[P][Z]

Options to Handle Bindings of Interfaces
    --list-interfaces              #列出绑定到区域的接口[P][Z]
    --add-interface=<interface>    #将<interface>绑定到区域[P][Z]
    --change-interface=<interface> #更改<interface>绑定到的区域[P][Z]
    --query-interface=<interface>  #查询<interface>是否绑定到区域[P][Z]
    --remove-interface=<interface> #从区域中删除<interface>的绑定[P][Z]

########################################################################################################
#                                                pf
########################################################################################################
#配置文件位置:
    /etc/pf.conf

#操作命令:
    rcctl {enable}{disable} pf
    pfctl [-e][-d]

    pfctl -f  /etc/pf.conf # Load the pf.conf file
    pfctl -nf /etc/pf.conf # Parse the file, but don't load it
    pfctl -sr              # Show the current ruleset
    pfctl -ss              # Show the current state table
    pfctl -si              # Show filter stats and counters
    pfctl -sa              # Show everything it can show

#Macros
    ext_if = "fxp0"
    host1 = "192.168.1.1"
    host2 = "192.168.1.2"
#List
    all_hosts = "{" $host1 $host2 "}"
    friends = "{ 192.168.1.1, 10.0.2.5, 192.168.43.53, 10.0.0.0/8, !10.1.2.3 }"
#Table
    table <goodguys> { 192.0.2.0/24 }
    table <rfc1918>  const { 192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8 }
    table <spammers> persist file "/etc/spammers"
    table <spammers> persist
    block in on fxp0 from { <rfc1918>, <spammers> } to any
    pass  in on fxp0 from <goodguys> to any

#Rule syntax
    action [direction] [log] [quick] [on interface] [af] [proto protocol]
           [from src_addr [port src_port]] [to dst_addr [port dst_port]]
           [flags tcp_flags] [state]
