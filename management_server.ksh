##########################################################################
#                              UNIX System V
##########################################################################
#Server Script is in:
	/etc/init.d/daemon.script
	/etc/rc.d/rc[0-6].d/S__daemon--->/etc/init.d/daemon.script
#Control server:
	/etc/init.d/daemon.scritp start/stop/restart/status
	server daemon             start/stop/restart/status
#Set if start server when boot:
	chkconfig [--level runlevel] daemon on/off
	chkconfig --list daemon 
    #Or edit config file.
    rc.conf               #FreeBSD
    rc.conf/rc.conf.local #OpenBSD
    inittab               #AIX

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
	systemctl list-units [--type=service] [--all] #List specific type of units.
	systemctl list-dependencies [unit] [--reverse]
	systemctl list-sockets
	systemctl get-default
	systemctl set-default daemon.target
	systemctl isolate daemon.target

##########################################################################
#                            Systemd-units
##########################################################################
#Set hostname.
    hostnamectl set-hostname hostname
#systemd-networkd.service:
    networkctl
