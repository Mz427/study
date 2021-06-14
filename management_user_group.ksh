#Script when user login.
/etc/profile--->${HOME}/[.bash_profile][.bash_login][.profile]
/etc/passwd #information of users.
guest_ftp:*:1002:1002::/var/empty:/sbin/nologin
/etc/group  #information of groups.
guests:*:1001:guest_ftp
/etc/shadow #information of password.
dmtsai:$6$M4IphgNP2TmlXaSS$B418YFroYxxmm....:16559:5:60:7:5:16679:
  1   :                 2                   :  3  :4:5 :6:7:  8  :9

#add users.
useradd -D #Default config of user.
useradd -e "dec 13 2020" -f "aug 13 2020" -G guests -s /sbin/nologin -d /var/empty guest_ftp
#set password yourself.
passwd
#set password of other users.
passwd user1
#lock passwd.
passwd -l user1
#print information of shadow.
passwd -S user1
chage -l user1
#change information of shadow.
chage -dEImMW
#change information of passwd.
usermod
chpass #BSD system.
#delete user.
userdel -r user1
#print UID/GID.
id user1

#add groups.
groupadd group1
#change information of group.
groupmod
#delete group.
groupdel
