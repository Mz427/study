$OpenBSD: README-server,v 1.25 2018/09/22 00:51:49 danj Exp $

+-----------------------------------------------------------------------
| Running postgresql-server on OpenBSD
+-----------------------------------------------------------------------

At least two different accounts are involved when working with PostgreSQL:
One is an OpenBSD userid, '_postgresql', which is used as the userid of files
that are part of PostgreSQL.  The other, usually named 'postgres', is not an
OpenBSD userid, i.e. you will not find it in /etc/passwd, but an account
internal to the database system.  The 'postgres' account is called the dba
account (database administrator) and is created when a new database is
initialized using the initdb command.

If you are installing PostgreSQL for the first time, you have to create
a default database first.  In the following example we install a database
in /var/postgresql/data with a dba account 'postgres' and scram-sha-256
authentication. We will be prompted for a password to protect the dba account:

       # su - _postgresql
       $ mkdir /var/postgresql/data
       $ initdb -D /var/postgresql/data -U postgres -A scram-sha-256 -E UTF8 -W

It is strongly advised that you do not work with the postgres dba account
other than creating more users and/or databases or for administrative tasks.
Use the PostgreSQL permission system to make sure that a database is only
accessed by programs/users that have the right to do so.

Please consult the PostgreSQL website for more information, especially when
you are upgrading an existing database installation.


Network Connections
===================
To allow connections over TCP (and other options) edit the file:

	/var/postgresql/data/postgresql.conf

and also edit the pg_hba.conf (in the same directory) making the
appropriate changes to allow connection from your network.

To allow SSL connections, edit postgresql.conf and enable the
'ssl' keyword, and create keys and certificates:

       # su - _postgresql
       $ cd /var/postgresql/data
       $ umask 077
       $ openssl genrsa -out server.key 2048
       $ openssl req -new -key server.key -out server.csr

Either take the CSR to a Certifying Authority (CA) to sign your
certificate, or self-sign it:

       $ openssl x509 -req -days 365 -in server.csr \
         -signkey server.key -out server.crt

Restart PostgreSQL to allow these changes to take effect.

Tuning for busy servers
=======================
The default sizes in the GENERIC kernel for SysV semaphores are only
just large enough for a database with the default configuration
(max_connections 40) if no other running processes use semaphores.
In other cases you will need to increase the limits. Adding the
following in /etc/sysctl.conf will be reasonable for many systems:

	kern.seminfo.semmni=60
	kern.seminfo.semmns=1024

To serve a large number of connections (>250), you may need higher
values for the above.

You may also want to tune the max_connect value in the
postgresql.conf file to increase the number of connections to the
backend.

By default, the _postgresql user, and so the postmaster and backend
processes run in the login(1) class of "daemon". On a busy server,
it may be advisable to put the _postgresql user and processes in
their own login(1) class with tuned resources, such as more open
file descriptors (used for network connections as well as files),
possibly more memory, etc.

For example, add this to the login.conf(5) file:

	postgresql:\
		:openfiles=768:\
		:tc=daemon:

Rebuild the login.conf.db file if necessary:

	# [ -f /etc/login.conf.db ] && cap_mkdb /etc/login.conf

For more than about 250 connections, these numbers should be
increased. Please report any changes and experiences to the package
maintainers so that we can update this file for future versions.

Upgrade Howto (for a major upgrade)
===================================
#If you didn't install PostgreSQL by following this README,
#you must adapt these instructions to your setup.

Option 1: Dump and Restore
--------------------------

This will work for any upgrade from any major version of PostgreSQL
to the current version.

1) Backup all your data:
# su _postgresql -c "pg_dumpall -U postgres > /var/postgresql/full.sqldump"

2) Shutdown the server:
# rcctl stop postgresql

3) Upgrade your PostgreSQL package with pkg_add.
# pkg_add -ui postgresql-server

4) Backup your old data directory:
# mv /var/postgresql/data /var/postgresql/data-9.6

5) Create a new data directory:
# su _postgresql -c "mkdir /var/postgresql/data"
# su _postgresql -c \
    "initdb -D /var/postgresql/data -U postgres -A scram-sha-256 -E UTF8 -W"

6) Restore your old pg_hba.conf and (if used) SSL certificates
# su _postgresql -c \
    "cp /var/postgresql/data-9.6/pg_hba.conf /var/postgresql/data/"
# su _postgresql -c \
    "cp /var/postgresql/data-9.6/server.{crt,key} /var/postgresql/data/"

Some postgresql.conf settings changed or disappeared in this version.
Examine your old file for local changes and apply them to the new version.

7) Start PostgreSQL:
# rcctl start postgresql

8) Restore your data:
# su _postgresql -c "psql -U postgres < /var/postgresql/full.sqldump"

Option 2: pg_upgrade
--------------------

This will work for an upgrade from the previous major version of
PostgreSQL supported by OpenBSD to the current version, and should be
faster than a dump and reload, especially for large databases.

1) Shutdown the server:
# rcctl stop postgresql

2) Upgrade your PostgreSQL package with pkg_add.
# pkg_add postgresql-pg_upgrade

3) Backup your old data directory:
# mv /var/postgresql/data /var/postgresql/data-9.6

4) Create a new data directory:
# su _postgresql -c "mkdir /var/postgresql/data"
# su _postgresql -c \
    "initdb -D /var/postgresql/data -U postgres -A scram-sha-256 -E UTF8 -W"

5) Restore your old pg_hba.conf and (if used) SSL certificates
# su _postgresql -c \
    "cp /var/postgresql/data-9.6/pg_hba.conf /var/postgresql/data/"
# su _postgresql -c \
    "cp /var/postgresql/data-9.6/server.{crt,key} /var/postgresql/data/"

Some postgresql.conf settings changed or disappeared in this version.
Examine your old file for local changes and apply them to the new version.

6) Temporarily support connecting without a password for local users by
   editing pg_hba.conf to include "local all postgres trust"
# su _postgresql -c "vi /var/postgresql/data/pg_hba.conf"
# su _postgresql -c "vi /var/postgresql/data-9.6/pg_hba.conf"

7) Run pg_upgrade:
# su _postgresql -c "cd /var/postgresql && \
    pg_upgrade -b /usr/local/bin/postgresql-9.6/ -B /usr/local/bin \
    -U postgres -d /var/postgresql/data-9.6/ -D /var/postgresql/data"

8) Remove "local all postgres trust" line from pg_hba.conf"
# su _postgresql -c "vi /var/postgresql/data/pg_hba.conf"

9) Start PostgreSQL:
# rcctl start postgresql

Clients/Frontends
=================
Many applications can use the PostgreSQL database right away.  To facilitate
administration of a PostgreSQL database, two clients are notable:

www/phppgadmin		A web based user interface that uses PHP5
databases/pgadmin3	A graphical user interface that uses wxWidgets
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
hostssl mzdb            mz              samenet                 scram-sha-256

+-----------------------------------------------------------------------
| Running postgresql-server on OpenBSD
+-----------------------------------------------------------------------
Message from postgresql14-client-14.2:

--
The PostgreSQL port has a collection of "side orders":

postgresql-docs
  For all of the html documentation

p5-Pg
  A perl5 API for client access to PostgreSQL databases.

postgresql-tcltk
  If you want tcl/tk client support.

postgresql-jdbc
  For Java JDBC support.

postgresql-odbc
  For client access from unix applications using ODBC as access
  method. Not needed to access unix PostgreSQL servers from Win32
  using ODBC. See below.

ruby-postgres, py-psycopg2
  For client access to PostgreSQL databases using the ruby & python
  languages.

postgresql-plperl, postgresql-pltcl & postgresql-plruby
  For using perl5, tcl & ruby as procedural languages.

postgresql-contrib
  Lots of contributed utilities, postgresql functions and
  datatypes. There you find pg_standby, pgcrypto and many other cool
  things.

etc...
=====
Message from postgresql14-server-14.2:

--
For procedural languages and postgresql functions, please note that
you might have to update them when updating the server.

If you have many tables and many clients running, consider raising
kern.maxfiles using sysctl(8), or reconfigure your kernel
appropriately.

The port is set up to use autovacuum for new databases, but you might
also want to vacuum and perhaps backup your database regularly. There
is a periodic script, /usr/local/etc/periodic/daily/502.pgsql, that
you may find useful. You can use it to backup and perform vacuum on all
databases nightly. Per default, it performs `vacuum analyze'. See the
script for instructions. For autovacuum settings, please review
~postgres/data/postgresql.conf.

If you plan to access your PostgreSQL server using ODBC, please
consider running the SQL script /usr/local/share/postgresql/odbc.sql
to get the functions required for ODBC compliance.

Please note that if you use the rc script,
/usr/local/etc/rc.d/postgresql, to initialize the database, unicode
(UTF-8) will be used to store character data by default.  Set
postgresql_initdb_flags or use login.conf settings described below to
alter this behaviour. See the start rc script for more info.

To set limits, environment stuff like locale and collation and other
things, you can set up a class in /etc/login.conf before initializing
the database. Add something similar to this to /etc/login.conf:
---
postgres:\
        :lang=en_US.UTF-8:\
        :setenv=LC_COLLATE=C:\
        :tc=default:
---
and run `cap_mkdb /etc/login.conf'.
Then add 'postgresql_class="postgres"' to /etc/rc.conf.

======================================================================

To initialize the database, run

  /usr/local/etc/rc.d/postgresql initdb

You can then start PostgreSQL by running:

  /usr/local/etc/rc.d/postgresql start

For postmaster settings, see ~postgres/data/postgresql.conf

NB. FreeBSD's PostgreSQL port logs to syslog by default
    See ~postgres/data/postgresql.conf for more info

NB. If you're not using a checksumming filesystem like ZFS, you might
    wish to enable data checksumming. It can be enabled during
    the initdb phase, by adding the "--data-checksums" flag to
    the postgresql_initdb_flags rcvar. Otherwise you can enable it later by
    pg_checksums.  Check the initdb(1) manpage for more info
    and make sure you understand the performance implications.

======================================================================

To run PostgreSQL at startup, add
'postgresql_enable="YES"' to /etc/rc.conf
