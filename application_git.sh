#Create a local repository.
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

#Set default editor.
git config --global core.editor "vim"
