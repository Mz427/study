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
    apt list [-installed][-upgradeable] [package_name]    #List installed package.
    dpkg -l                                               #List installed package.

#RPM linux
#/etc/yum.repos.d/
	yum list installed
	         available
		updates
	    install
	    reinstall
	    localinstall
	    upate
	    remove
	    erase #Rmove both config file.
	    info
	    search

#BSD pkg
#set environment variable "PKG_PATH" or /etc/installurl.
pkg_add -u unzip - updating packages
pkg_add(1) - for installing and upgrading packages
pkg_check(8) - for checking the consistency of installed packages
pkg_delete(1) - for removing installed packages
pkg_info(1) -Q - for displaying information about packages
