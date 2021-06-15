#Create virtual env.
python -m venv env_name

#Activate env on Linux.
source env_name/bin/activate

#Activate env on Win10.
run PowerShell as Administrator
set-executionpolicy remotesigned
Get-ExecutionPolicy -List
set-executionpolicy undefined

#Install django.
python -m pip install django

#Create program.
django-admin startprogram program_name

#Create sqllite database.
python manage.py migrate

#Start server.
python manage.py runserver

#Create new app.
python manage.py startapp app_name
