#AIX开机启动服务init配置文件
/etc/inittab
    #各服务定义格式，条目顺序决定启动顺序。
    Identifier:RunLevel:Action:Command
    Identifier #标识唯一对象的一个 1-4 位字符的字段。
    RunLevel [0-9]
    Action: respawn wait once boot bootwait powerfail powerwait off ondemand initdefault sysinit
    Command: shell script
    #下列命令是唯一支持在 /etc/inittab 文件中修改记录的方法:
        mkitab #把记录添加到 /etc/inittab 文件。
        #eg: "-i fbcheck"旗標可確定該記錄會插入所有子系統記錄之前。
            mkitab -i fbcheck "srcmstr:2:respawn:/usr/sbin/srcmstr"
        lsitab #列出 /etc/inittab 文件中的记录。
        chitab #修改 /etc/inittab 文件中的记录。
        rmitab #从 /etc/inittab 文件中删除记录。
        telinit q #告知 init 指令重新處理 /etc/inittab 檔案，它會處理新輸入的 srcmstr 常駐程式記錄，並啟動 SRC。

srcmstr   daemon                     #Starts the System Resource Controller
startsrc  [-s SubsystemName]         #Starts a subsystem, subsystem group, or subserver
stopsrc   [-s SubsystemName]         #Stops a subsystem, subsystem group, or subserver
refresh   [-s SubsystemName]         #Refreshes a subsystem
traceson  [-l][-s SubsystemName]     #Turns on tracing of a subsystem, a group of subsystems, or a subserver
tracesoff [-s SubsystemName]         #Turns off tracing of a subsystem, a group of subsystems, or a subserver
lssrc     [-a][-l][-s SubsystemName] #Gets status on a subsystem.
