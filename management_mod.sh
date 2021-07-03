#depmod(depend module)命令用于分析可载入模块的相依性,生成modules.dep和映射文件,供modprobe在安装模块时使用:
depmod
#install module命令用于载入模块:
insmod
#显示已载入系统的模块:
lsmod
#显示kernel模块的信息:
modinfo
#载入指定的个别模块,或是载入一组相依的模块:
modprobe
#删除模块:
rmmod
