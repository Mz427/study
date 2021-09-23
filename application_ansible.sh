#configuration of ansible and hosts:
#/etc/ansible/ansible.cfg
#/etc/ansible/hosts OR ${HOME}/hosts
ansible-doc [-l] #List available plugins.
ansible-doc [-s] <module_name> #Show playbook sinppet for specified plugin.
ansible [-i] <host_file> [-m] <module> [-a] <command> <host>
ansible-playbook [-v] <playbook>
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
