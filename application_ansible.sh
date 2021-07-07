#configuration of ansible and hosts:
#/etc/ansible/ansible.cfg
#/etc/ansible/hosts OR ${HOME}/hosts
ansible [-i] <host_file> [-m] <module> [-a] <command> <host> [--become] [--become-method=sudo] [--become-user=root]

#Modules:
#查看具體用法: ansible-doc module_name
    #遠程執行命令.
    command
    shell
    script
    raw #不要求主機安裝python.

    #安裝軟件.
    yum
    apt

    #文件傳輸.
    copy
    get_url
    file
