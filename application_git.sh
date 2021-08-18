#配置文件：
    /etc/gitconfig
    ~/.gitconfig
#基本设置：
    git config --list [--show-origin] #查看设置及配置所在文件。
    git config --global user.name "John Doe"
    git config --global user.email johndoe@example.com
    git config --global core.editor "vim" #Set default editor.

#Create repository:
    git init
    #Create a repository on github.
    git remote add origin git@github.com:user_name/repository_name
    #Clone a repository from local.
    git clone /path/repository
    git clone user_name@local_host:/path/repository_name
    #Clone a repository from github.
    git clone git@github.com:user_name/repository_name

#Create a branch.
    git checkout -b branch_name #Equit: git branch branch_name; git checkout branch_name.
    git checkout branch_name
    #Create relationship between local_branch and remote_branch
    git branch --set-upstream-to user_name@local_host:/path/repository_name local_branch_name
    #Delete a branch.
    git branch -d branch_name
    #Get update from other branch.
    git merge branch_name
    #Get update from github.
    git fetch
    #Push upate to github branch.
    git push origin branch_name

#Update repository.
    git add changed_file
    git commit -m "messages"

    git status
    git log
