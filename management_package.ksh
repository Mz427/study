#Debian
#/etc/apt/sources.list
#/etc/apt/sources.list.d/
	apt-get update             #Update database of system package.
		upgrade [package_name] #Update version of package.
		dist-upgrade           #Update Debian system.
		install
		reinstall
		remove
		autoremove             #Remove both dependence package indeed.
		purge                  #Equit "apt-get remove package_name --purge", remove both package and config file.
		clean
		download
    apt-cache search 
              madison
    apt list [-installed][-upgradeable] [package_name]    #List installed package.
    dpkg -l                                               #List installed package.

#RPM linux
#/etc/yum.repos.d/
	dnf | yum list installed
		update
	    install
	    reinstall
	    localinstall
	    remove
	    erase #Rmove both config file.
	    info
	    search

#BSD pkg
#set environment variable "PKG_PATH" or /etc/installurl.
pkg_add [-u]     #updating packages
pkg_add(1)       #installing and upgrading packages
pkg_check(8)     #checking the consistency of installed packages
pkg_delete(1)    #removing installed packages
pkg_info(1) [-Q] #displaying information about packages
