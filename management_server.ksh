##########################################################################
#                              UNIX System V
##########################################################################
#Service Script is in:
	/etc/init.d/daemon.script
	/etc/rc.d/rc[0-6].d/S__daemon--->/etc/init.d/daemon.script
    /etc/rc.d/service_script           #FreeBSD or OpenBSD
    /usr/local/etc/rc.d/service_script #FreeBSD for package service_script
#Control server:
	/etc/init.d/daemon.scritp start/stop/restart/status
	service daemon            start/stop/restart/status
#Set if start server when boot:
	chkconfig --add daemon 
	chkconfig [--level runlevel] daemon on/off
	chkconfig --list daemon 
    service enable/disable #FreeBSD
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
	systemctl start/stop/restart/status/reload/enable/disable/mask/is-active/is-enabled unit
#Manage unit:
	systemctl #List all started units.
	systemctl list-unit-file [unit] #List all installed units.
    systemctl list-units [--type=service] [--all] #List specific type of units(active).
	systemctl list-dependencies [unit] [--reverse]
	systemctl list-sockets
	systemctl get-default
	systemctl set-default daemon.target
	systemctl isolate daemon.target #Switch target.
#重启/關機:
    systemctl [reboot] [poweroff]

##########################################################################
#                            Systemd-units
##########################################################################
#Log:
    journalctl #List all log.   
    journalctl [-n 200][-f] #Like tail.

#systemd-networkd.service:
    networkctl
#Set hostname.
    hostnamectl set-hostname hostname
