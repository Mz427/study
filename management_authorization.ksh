#set SUID.
#SUID 權限僅對二進位程式(binary program)有效；
#執行者對於該程式需要具有 x 的可執行權限；
#本權限僅在執行該程式的過程中有效 (run-time)；
#執行者將具有該程式擁有者 (owner) 的權限。

#set GUID.
#set on binary files.
#SGID 對二進位程式有用；
#程式執行者對於該程式來說，需具備 x 的權限；
#執行者在執行的過程中將會獲得該程式群組的支援！
##set on directory files.
#使用者若對於此目錄具有 r 與 x 的權限時，該使用者能夠進入此目錄；
#使用者在此目錄下的有效群組(effective group)將會變成該目錄的群組；
#用途：若使用者在此目錄下具有 w 的權限(可以新建檔案)，則使用者所建立的新檔案，該新檔案的群組與此目錄的群組相同。

#set SBIT
#當使用者對於此目錄具有 w, x 權限，亦即具有寫入的權限時；
#當使用者在該目錄下建立檔案或目錄時，僅有自己與 root 才有權力刪除該檔案

#examples.
#4 為 SUID
#2 為 SGID
#1 為 SBIT
[root@study ~]# cd /tmp
[root@study tmp]# touch test                  <==建立一個測試用空檔
[root@study tmp]# chmod 4755 test; ls -l test <==加入具有 SUID 的權限
-rwsr-xr-x 1 root root 0 Jun 16 02:53 test
[root@study tmp]# chmod 6755 test; ls -l test <==加入具有 SUID/SGID 的權限
-rwsr-sr-x 1 root root 0 Jun 16 02:53 test
[root@study tmp]# chmod 1755 test; ls -l test <==加入 SBIT 的功能！
-rwxr-xr-t 1 root root 0 Jun 16 02:53 test
[root@study tmp]# chmod 7666 test; ls -l test <==具有空的 SUID/SGID 權限
-rwSrwSrwT 1 root root 0 Jun 16 02:53 test

#set ACL.
setfacl -m u:user1:rwx filename
setfacl -m g:group1:rwx directoryname
#set default ACL.
setfacl -m d:u:user1:rwx filename
#print information of ACL.
getfacl filename
#delete ACL.
setfacl -b fielname
