##########################################################################
#                              UNIX System V
##########################################################################
#initd开机启动流程：
    BIOS-->groub(开机引导程序)-->/boot/vmlinuz-version.x86_64(加载核心)-->/boot/initrd(挂载虚拟根分区)--> \
        /sbin/init(pid 1)-->/etc/inittab(确定运行级别)-->/etc/rc.d/rc[0-6].d/daemon.script-->login
#Service Script is in:
	/etc/init.d/daemon.script
	/etc/rc.d/rc[0-6].d/S__daemon--->/etc/init.d/daemon.script
    /etc/rc.d/service_script           #FreeBSD or OpenBSD
    /usr/local/etc/rc.d/service_script #FreeBSD for package service_script
#Control server:
	/etc/init.d/daemon.scritp start/stop/restart/status
	service daemon            start/stop/restart/status
    rcctl start/stop/restart/status daemon_name #OpenBSD
#Set if start server when boot:
	chkconfig --add daemon 
	chkconfig [--level runlevel] daemon on/off
	chkconfig --list daemon 
    service enable/disable #FreeBSD
    rcctl   enable/disable #OpenBSD
    #Or edit config file.
    /etc/rc.conf                  #FreeBSD
    /etc/rc.conf or rc.conf.local #OpenBSD
    /etc/inittab                  #AIX

#Change init level:
	init [0-6]
#Type of daemon:
	stand alone
	super daemon # managed by inetd: /etc/inetd.conf.

##########################################################################
#                               Systemd
##########################################################################
#systemd开机启动流程：
    BIOS-->groub(开机引导程序)-->/boot/vmlinuz-version.x86_64(加载核心)-->/boot/initramfs(挂载虚拟根分区)--> \
        /usr/lib/systemd/systemd(pid 1)-->/usr/lib/systemd/system/sysinit.target-->basick.target--> \
        default.target(initrd.target)-->login
#Unit Script is in:
	/usr/lib/systemd/system/unit.service #Like /etc/init.d/daemon.script
	/run/systemd/system/
	/etc/systemd/system/unit.service--->/usr/lib/systemd/system/unit.service #Like /etc/rc.d/rc[0-6].d/S__daemon
#Type of unit:
	.service
	.socket
	.target
	.mount
	.path
	.timer
#Type of unit loaded:
	enabled #Start when boot.
	disabled #Don't start when boot.
	static #Disabled and depend other daemon.
	mask #Locked.
#Type of unit running status:
	active(running)
	active(exited)
	active(waiting)
	inactive
#Crontrol unit:
	systemctl start|stop|restart|status|kill|reload|enable|disable|mask unit_name
	systemctl #List all started units.
	systemctl list-unit-files #List all installed units.
    systemctl list-units [--type=service] [--state=inactive] [--failed] [--all] #List specific type of units(default: active).
    systemctl is-active|is-enabled|is-failed
	systemctl list-dependencies [unit_name] [--reverse]
	systemctl list-sockets
    systemctl daemon-reload
#Crontrol target:
	systemctl get-default
	systemctl set-default daemon.target
	systemctl isolate daemon.target #Switch target.
#查看服務启動耗時:
    systemctl-analyze
#重启/關機:
    systemctl [reboot] [poweroff] [rescue]

##########################################################################
#                            Systemd-units
##########################################################################
##########################################################################
#                            Journalctl
##########################################################################
#Log:
    journalctl #List all log.   
    journalctl -k #List kernel log.   
    journalctl [-n 200] [-f] [--unit=unit_name] [--since="2022-05-07 05:45:00"] [--until="2022-05-07 05:45:00"] #Like tail.
