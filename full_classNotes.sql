=============================INSTALLATION

1. RPM ====> POSTGRESQL.ORG
2. YUM ====> POSTGRESQL.ORG
3. Source Code ====> POSTGRESQL.ORG
4. Binary (GUI/ NON-GUI) =====> ENTERPRISEDB

==================STEPS 

[root@localhost ~]# whoami 
root
[root@localhost ~]# 

sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm


[root@localhost ~]# yum install postgresql12-server

[root@localhost ~]# chown postgres:postgres /usr/pgsql-12/ -R
[root@localhost ~]# 
[root@localhost ~]# mkdir /app01
[root@localhost ~]# 
[root@localhost ~]# mkdir /app01/postgres
[root@localhost ~]# 
[root@localhost ~]# cp /root/.bash_profile /app01/postgres/ 
[root@localhost ~]# 
[root@localhost ~]# chown postgres:postgres /app01/postgres -R

[root@localhost ~]# cd /app01/postgres/

[root@localhost postgres]# vi .bash_profile 

# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs


PATH=$PATH:$HOME/bin
export PATH=/usr/pgsql-12/bin:$PATH
export PATH
:wq

[root@localhost postgres]# vi /etc/passwd

postgres:x:1001:1001:PostgreSQL:/app01/postgres:/bin/bash

:wq


[root@localhost postgres]# su - postgres
Last login: Fri May  6 16:45:01 IST 2022 on pts/0
-bash-4.2$ 
-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ psql --version
psql (PostgreSQL) 12.10
-bash-4.2$ 
-bash-4.2$ initdb --version
initdb (PostgreSQL) 12.10

=====================CREATE NEW CLUSTER 

-bash-4.2$ whoami 
postgres
-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ mkdir data
-bash-4.2$ 
-bash-4.2$ initdb --version
initdb (PostgreSQL) 12.10
-bash-4.2$ 
-bash-4.2$ initdb -D data
-bash-4.2$ cd data/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 5432  

:wq


-bash-4.2$ pg_ctl -D /app01/postgres/data/ start

-bash-4.2$ netstat -pant | grep postgres
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 127.0.0.1:5432          0.0.0.0:*               LISTEN      14770/postgres      
tcp6       0      0 ::1:5432                :::*                    LISTEN      14770/postgres      
-bash-4.2$ 

-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
postgres=# 
postgres=# show data_directory;
    data_directory    
----------------------
 /app01/postgres/data
(1 row)

postgres=# select datname from pg_database;
  datname  
-----------
 postgres
 template1
 template0
(3 rows)

postgres=# select current_schemas(true);
   current_schemas   
---------------------
 {pg_catalog,public}
(1 row)


==========================================================
=======================================SYS ARCH

-bash-4.2$ psql -p 5432 -U postgres -d postgres
psql (12.10)
Type "help" for help.

postgres=# select pg_backend_pid();
 pg_backend_pid 
----------------
          28901
(1 row)

postgres=# select pid,datname,state,query from pg_stat_activity ;
  pid  | datname  | state  |                         query                          
-------+----------+--------+--------------------------------------------------------
 14776 |          |        | 
 14778 |          |        | 
 28901 | postgres | active | select pid,datname,state,query from pg_stat_activity ;
 14774 |          |        | 
 14773 |          |        | 
 14775 |          |        | 
(6 rows)

postgres=# select pid,datname,state,query from pg_stat_activity ;
  pid  | datname  | state  |                         query                          
-------+----------+--------+--------------------------------------------------------
 14776 |          |        | 
 14778 |          |        | 
 28901 | postgres | active | select pid,datname,state,query from pg_stat_activity ;
 29925 | postgres | idle   | select pg_backend_pid();
 14774 |          |        | 
 14773 |          |        | 
 14775 |          |        | 
(7 rows)

postgres=# select pg_backend_pid();
 pg_backend_pid 
----------------
          28901
(1 row)

postgres=# create table test as select * from pg_class,pg_Descrippostgres=# create table test as select * from pg_class,pg_Description;
SELECT 1812260
postgres=# 
postgres=# select pid,datname,state,query from pg_stat_activity ;
  pid  | datname  | state  |                         query                          
-------+----------+--------+--------------------------------------------------------
 14776 |          |        | 
 14778 |          |        | 
 28901 | postgres | active | select pid,datname,state,query from pg_stat_activity ;
 29925 | postgres | idle   | select pg_backend_pid();
 14774 |          |        | 
 14773 |          |        | 
 14775 |          |        | 
(7 rows)

postgres=# select pg_terminate_backend(29925);
 pg_terminate_backend 
----------------------
 t
(1 row)

postgres=# select pid,datname,state,query from pg_stat_activity ;
  pid  | datname  | state  |                         query                          
-------+----------+--------+--------------------------------------------------------
 14776 |          |        | 
 14778 |          |        | 
 28901 | postgres | active | select pid,datname,state,query from pg_stat_activity ;
 14774 |          |        | 
 14773 |          |        | 
 14775 |          |        | 
(6 rows)

postgres=# 

===========================SYS ARCH 2ND LAB 

postgres=# select oid,datname from pg_Database;
  oid  |  datname  
-------+-----------
 14187 | postgres
     1 | template1
 14186 | template0
(3 rows)

postgres=# show data_directory;
    data_directory    
----------------------
 /app01/postgres/data
(1 row)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ cd /app01/postgres/data/base/
-bash-4.2$ 
-bash-4.2$ ls
1  14186  14187
-bash-4.2$ 
-bash-4.2$ psql -p 5432 
psql (12.10)
Type "help" for help.

postgres=# create database edbstore;
CREATE DATABASE
postgres=# 
postgres=# select oid,datname from pg_Database;
  oid  |  datname  
-------+-----------
 14187 | postgres
 16391 | edbstore
     1 | template1
 14186 | template0
(4 rows)

postgres=# \! ls /app01/postgres/data/base/
1  14186  14187  16391
postgres=# 
postgres=# 
postgres=# \l+
                                                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description              
   
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+-----------------------------------------
---
 edbstore  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8193 kB | pg_default | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 429 MB  | pg_default | default administrative connection databa
se
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | default template for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            | 
(4 rows)

postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | test | table | postgres
(1 row)

postgres=# \dt+
                    List of relations
 Schema | Name | Type  |  Owner   |  Size  | Description 
--------+------+-------+----------+--------+-------------
 public | test | table | postgres | 421 MB | 
(1 row)

postgres=# create table sales_2022_q1(id int);
CREATE TABLE
postgres=# 
postgres=# create table sales_2022_q2(id int);
CREATE TABLE
postgres=# 
postgres=# select relfilenode,relname from pg_class where relname like 'sales%';
 relfilenode |    relname    
-------------+---------------
       16392 | sales_2022_q1
       16395 | sales_2022_q2
(2 rows)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ cd /app01/postgres/data/base/14187
-bash-4.2$ 
-bash-4.2$ ls 163*
16384  16387  16389  16392  16395
-bash-4.2$ 
-bash-4.2$ du -sh 16392
0   16392
-bash-4.2$ 
-bash-4.2$ psql -p 5432 -d postgres -U postgres -c "insert into sales_2022_q1 values(1);"
INSERT 0 1
-bash-4.2$ 
-bash-4.2$ du -sh 16392
8.0K    16392
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# select pg_size_pretty(pg_relation_size('sales_2022_q1'));
 pg_size_pretty 
----------------
 8192 bytes
(1 row)

postgres=# analyze sales_2022_q1;
ANALYZE
postgres=# 
postgres=# select relpages,reltuples from pg_class where relname='sales_2022_q1';
 relpages | reltuples 
----------+-----------
        1 |         1
(1 row)

postgres=# insert into sales_2022_q1 values(generate_series(2,200));
INSERT 0 199
postgres=# 
postgres=# analyze sales_2022_q1;
ANALYZE
postgres=# 
postgres=# select relpages,reltuples from pg_class where relname='sales_2022_q1';
 relpages | reltuples 
----------+-----------
        1 |       200
        
postgres=# select ctid,* from sales_2022_q1 limit 10;
  ctid  | id 
--------+----
 (0,1)  |  1
 (0,2)  |  2
 (0,3)  |  3
 (0,4)  |  4
 (0,5)  |  5
 (0,6)  |  6
 (0,7)  |  7
 (0,8)  |  8
 (0,9)  |  9
 (0,10) | 10
(10 rows)



=========================LAST LAB EXERCISE FOR DAY ONE

CASE STUDY :-

1. Create new cluster "delldata"

2. Set the Port "5433"

3. Start and Connect the Cluster

4. Create and Connect dell_db database

5. Create the sales table

6. Insert 1000 records in sales table find the relpages,reltuples of sales table 

7. Find the physical location of dell_db and sales table

===========ONCE COMPLETED YOU CAN LOGOUT
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

10th May 2022
-------------
+++++++++++++++


DAY ONE :-

Intro
Major Features
Limitations
Installation
Cluster
Filesystem Layout

=====================================================================
Day Two :-

System Architecture
Process List
Creating and Managing Database
Template Database

================================CHECKPOINT

-bash-4.2$ pg_waldump /app01/postgres/data/pg_wal/00000001000000000000002E | less
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# show shared_buffers ;
 shared_buffers 
----------------
 128MB
(1 row)

postgres=# show wal_buffers ;
 wal_buffers 
-------------
 4MB
(1 row)

postgres=# show bgwriter_delay ;
 bgwriter_delay 
----------------
 200ms
(1 row)

postgres=# show bgwriter_lru_maxpages ;
 bgwriter_lru_maxpages 
-----------------------
 100
(1 row)

postgres=# show bgwriter_flush_after ;
 bgwriter_flush_after 
----------------------
 512kB
(1 row)

postgres=# show wal_writer_delay ;
 wal_writer_delay 
------------------
 200ms
(1 row)

postgres=# show wal_writer_flush_after ;
 wal_writer_flush_after 
------------------------
 1MB
(1 row)

postgres=# show checkpoint_timeout ;
 checkpoint_timeout 
--------------------
 5min
(1 row)

postgres=# show max_wal_size ;
 max_wal_size 
--------------
 1GB
(1 row)

postgres=# show min_wal_size ;
 min_wal_size 
--------------
 80MB
(1 row)

postgres=# show wal_keep_segments ;
 wal_keep_segments 
-------------------
 0
(1 row)

postgres=# show checkpoint_completion_target ;
 checkpoint_completion_target 
------------------------------
 0.5
(1 row)

postgres=# 
postgres=# create extension pageinspect;
CREATE EXTENSION
postgres=# 
postgres=# create table testpage(id int);
CREATE TABLE
postgres=# 
postgres=# insert into testpage values(generate_Series(1,10));
INSERT 0 10
postgres=# 
postgres=# select ctid,* from testpage ;
  ctid  | id 
--------+----
 (0,1)  |  1
 (0,2)  |  2
 (0,3)  |  3
 (0,4)  |  4
 (0,5)  |  5
 (0,6)  |  6
 (0,7)  |  7
 (0,8)  |  8
 (0,9)  |  9
 (0,10) | 10
(10 rows)

postgres=# select ctid,xmin,* from testpage ;
  ctid  | xmin | id 
--------+------+----
 (0,1)  |  499 |  1
 (0,2)  |  499 |  2
 (0,3)  |  499 |  3
 (0,4)  |  499 |  4
 (0,5)  |  499 |  5
 (0,6)  |  499 |  6
 (0,7)  |  499 |  7
 (0,8)  |  499 |  8
 (0,9)  |  499 |  9
 (0,10) |  499 | 10
(10 rows)

postgres=# delete from testpage where id=5;
DELETE 1
postgres=# 
postgres=# select ctid,xmin,* from testpage ;
  ctid  | xmin | id 
--------+------+----
 (0,1)  |  499 |  1
 (0,2)  |  499 |  2
 (0,3)  |  499 |  3
 (0,4)  |  499 |  4
 (0,6)  |  499 |  6
 (0,7)  |  499 |  7
 (0,8)  |  499 |  8
 (0,9)  |  499 |  9
 (0,10) |  499 | 10
(9 rows)

postgres=# 
postgres=# select t_ctid,lp_len,t_xmin,t_xmax from heap_page_items(get_raw_page('testpage',0));
 t_ctid | lp_len | t_xmin | t_xmax 
--------+--------+--------+--------
 (0,1)  |     28 |    499 |      0
 (0,2)  |     28 |    499 |      0
 (0,3)  |     28 |    499 |      0
 (0,4)  |     28 |    499 |      0
 (0,5)  |     28 |    499 |    500
 (0,6)  |     28 |    499 |      0
 (0,7)  |     28 |    499 |      0
 (0,8)  |     28 |    499 |      0
 (0,9)  |     28 |    499 |      0
 (0,10) |     28 |    499 |      0
(10 rows)

postgres=# vacuum testpage ;
VACUUM
postgres=# 
postgres=# select t_ctid,lp_len,t_xmin,t_xmax from heap_page_items(get_raw_page('testpage',0));
 t_ctid | lp_len | t_xmin | t_xmax 
--------+--------+--------+--------
 (0,1)  |     28 |    499 |      0
 (0,2)  |     28 |    499 |      0
 (0,3)  |     28 |    499 |      0
 (0,4)  |     28 |    499 |      0
        |      0 |        |       
 (0,6)  |     28 |    499 |      0
 (0,7)  |     28 |    499 |      0
 (0,8)  |     28 |    499 |      0
 (0,9)  |     28 |    499 |      0
 (0,10) |     28 |    499 |      0
(10 rows)

postgres=# show bgwriter_flush_after ;
 bgwriter_flush_after 
----------------------
 512kB
(1 row)

postgres=# show checkpoint_flush_after ;
 checkpoint_flush_after 
------------------------
 256kB
(1 row)

postgres=# select pg_current_wal_insert_lsn();
 pg_current_wal_insert_lsn 
---------------------------
 0/2E656920
(1 row)

postgres=# 
postgres=# insert into testpage values(generate_Series(1,1000000));
INSERT 0 1000000
postgres=# 
postgres=# 
postgres=# select pg_current_wal_insert_lsn();
 pg_current_wal_insert_lsn 
---------------------------
 0/3238D848
(1 row)

postgres=# 
postgres=# select pg_size_pretty(pg_wal_lsn_diff('0/3238D848','0/2E656920'));
 pg_size_pretty 
----------------
 61 MB
(1 row)


postgres=# select pid,datname,usename,state,backend_xmin from pg_stat_activity where backend_xmin is not null order by age (backend_xmin) desc;
  pid  | datname  | usename  | state  | backend_xmin 
-------+----------+----------+--------+--------------
 16208 | postgres | postgres | active |          503
 26730 | postgres | postgres | active |          503
 26746 | postgres | postgres | active |          503
(3 rows)

postgres=# select pid,datname,usename,state,backend_xmin,query,wait_Event_type from pg_stat_activity where backend_xmin is not null order by age (backend_xmin) desc;
  pid  | datname  | usename  | state  | backend_xmin |                                                                           query                
                                                            | wait_event_type 
-------+----------+----------+--------+--------------+------------------------------------------------------------------------------------------------
------------------------------------------------------------+-----------------
 16208 | postgres | postgres | active |          507 | select pid,datname,usename,state,backend_xmin,query,wait_Event_type from pg_stat_activity where
 backend_xmin is not null order by age (backend_xmin) desc; | 
(1 row)



======================EXTENSIONS 

root@ yum install postgresql12-contrib


==========================================================

=============================================CREATING AND MANAGING DATABASE 

[root@localhost ~]# su - postgres
Last login: Tue May 10 10:04:57 IST 2022 on pts/3
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# create user app01 password '123456';
CREATE ROLE
postgres=# 
postgres=# alter user postgres password '123456';
ALTER ROLE
postgres=# 
postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |               passwd                | valuntil | useconfig 
----------+----------+-------------+----------+---------+--------------+-------------------------------------+----------+-----------
 app01    |    24622 | f           | f        | f       | f            | md5fd947e696f52322dc69ab44124f80c9d |          | 
 postgres |       10 | t           | t        | t       | t            | md5a3556571e93b0d20722ba62be61e8c2d |          | 
(2 rows)

postgres=# create table employee(id int);
CREATE TABLE
postgres=# 
postgres=# select current_user;
 current_user 
--------------
 postgres
(1 row)

postgres=# show search_path ;
   search_path   
-----------------
 "$user", public
(1 row)

postgres=# \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | employee      | table | postgres
 public | sales_2022_q1 | table | postgres
 public | sales_2022_q2 | table | postgres
 public | test          | table | postgres
 public | test1         | table | postgres
 public | test12        | table | postgres
 public | testpage      | table | postgres
(7 rows)

postgres=# drop table test, test1,test12,testpage;
DROP TABLE
postgres=# 
postgres=# \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | employee      | table | postgres
 public | sales_2022_q1 | table | postgres
 public | sales_2022_q2 | table | postgres
(3 rows)

postgres=# insert into employee values(100);
INSERT 0 1
postgres=# 
postgres=# \d employee 
              Table "public.employee"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           |          | 

postgres=# \c postgres app01
You are now connected to database "postgres" as user "app01".
postgres=> 
postgres=> \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | employee      | table | postgres
 public | sales_2022_q1 | table | postgres
 public | sales_2022_q2 | table | postgres
(3 rows)

postgres=> show search_path ;
   search_path   
-----------------
 "$user", public
(1 row)

postgres=> select * from employee ;
ERROR:  permission denied for table employee
postgres=> 
postgres=> \c postgres postgres 
You are now connected to database "postgres" as user "postgres".
postgres=# 
postgres=# grant select on public.employee to app01 ;
GRANT
postgres=# 
postgres=# \c postgres app01 
You are now connected to database "postgres" as user "app01".
postgres=> 
postgres=> \dt
             List of relations
 Schema |     Name      | Type  |  Owner   
--------+---------------+-------+----------
 public | employee      | table | postgres
 public | sales_2022_q1 | table | postgres
 public | sales_2022_q2 | table | postgres
(3 rows)

postgres=> select * from employee ;
 id  
-----
 100
(1 row)

postgres=> select * from sales_2022_q1;
ERROR:  permission denied for table sales_2022_q1
postgres=> 
postgres=> 

postgres=# \z 
                                     Access privileges
 Schema |     Name      | Type  |     Access privileges     | Column privileges 
| Policies 
--------+---------------+-------+---------------------------+-------------------
+----------
 public | employee      | table | postgres=arwdDxt/postgres+|                   
| 
        |               |       | app01=r/postgres          |                   
| 
 public | sales_2022_q1 | table |                           |                   
| 
 public | sales_2022_q2 | table |                           |                   
| 
(3 rows)



==========================CREATEDB DATABASE 

-bash-4.2$ createdb -p 5432 -U postgres edbstore
createdb: error: database creation failed: ERROR:  database "edbstore" already exists
-bash-4.2$ 
-bash-4.2$ createdb -p 5432 -U postgres delldb
-bash-4.2$ 
-bash-4.2$ psql -p 5432 -U postgres -d delldb
psql (12.10)
Type "help" for help.

delldb=# select oid,datname from pg_database;
  oid  |  datname  
-------+-----------
 14187 | postgres
 16391 | edbstore
     1 | template1
 14186 | template0
 24626 | delldb
(5 rows)

delldb=# \! ls -ltr /app01/postgres/data/base
total 60
drwx------. 2 postgres postgres 8192 May  9 10:58 1
drwx------. 2 postgres postgres 8192 May  9 10:58 14186
drwx------. 2 postgres postgres 8192 May 10 09:30 16391
drwx------. 2 postgres postgres 8192 May 10 11:36 14187
drwx------. 2 postgres postgres 8192 May 10 11:38 24626
delldb=# 
delldb=# 
delldb=# 

=============================TEMPLATE DATABASE 

bash-4.2$ createdb -p 5432 -U postgres delldb
-bash-4.2$ 
-bash-4.2$ psql -p 5432 -U postgres -d delldb
psql (12.10)
Type "help" for help.

delldb=# select oid,datname from pg_database;
  oid  |  datname  
-------+-----------
 14187 | postgres
 16391 | edbstore
     1 | template1
 14186 | template0
 24626 | delldb
(5 rows)

delldb=# \! ls -ltr /app01/postgres/data/base
total 60
drwx------. 2 postgres postgres 8192 May  9 10:58 1
drwx------. 2 postgres postgres 8192 May  9 10:58 14186
drwx------. 2 postgres postgres 8192 May 10 09:30 16391
drwx------. 2 postgres postgres 8192 May 10 11:36 14187
drwx------. 2 postgres postgres 8192 May 10 11:38 24626
delldb=# 
delldb=# 
delldb=# 
delldb=# select datname from pg_Database;
  datname  
-----------
 postgres
 edbstore
 template1
 template0
 delldb
(5 rows)

delldb=# select datname from pg_Database where datistemplate=true;
  datname  
-----------
 template1
 template0
(2 rows)



delldb=# select datname,datallowconn from pg_Database where datistemplate=true;
  datname  | datallowconn 
-----------+--------------
 template1 | t
 template0 | f
(2 rows)

delldb=# 
delldb=# drop database template1;
ERROR:  cannot drop a template database
delldb=# 
delldb=# \c template1 postgres
You are now connected to database "template1" as user "postgres".
template1=# 
template1=# select current_schemas(true);
   current_schemas   
---------------------
 {pg_catalog,public}
(1 row)

template1=# create database delltemp;
CREATE DATABASE
template1=# 
template1=# \c delltemp postgres
You are now connected to database "delltemp" as user "postgres".
delltemp=# 
delltemp=# create table tbl1 as select * from pg_class;
SELECT 395
delltemp=# 
delltemp=# create table tbl2 as select * from pg_stat_user_tables;
SELECT 1
delltemp=# 
delltemp=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
(2 rows)

delltemp=# \dt+
                      List of relations
 Schema | Name | Type  |  Owner   |    Size    | Description 
--------+------+-------+----------+------------+-------------
 public | tbl1 | table | postgres | 88 kB      | 
 public | tbl2 | table | postgres | 8192 bytes | 
(2 rows)

delltemp=# update pg_database set datistemplate=true where datname='delltemp';
UPDATE 1
delltemp=# 
delltemp=# select datname,datallowconn from pg_Database where datistemplate=true;
  datname  | datallowconn 
-----------+--------------
 template1 | t
 template0 | f
 delltemp  | t
(3 rows)

delltemp=# create database dbstore template delltemp ;
CREATE DATABASE
delltemp=# 
delltemp=# \c dbstore postgres 
You are now connected to database "dbstore" as user "postgres".
dbstore=# 
dbstore=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
(2 rows)

dbstore=# \dt+
                      List of relations
 Schema | Name | Type  |  Owner   |    Size    | Description 
--------+------+-------+----------+------------+-------------
 public | tbl1 | table | postgres | 88 kB      | 
 public | tbl2 | table | postgres | 8192 bytes | 
(2 rows)

dbstore=# 


==========================PRIVATE SCHEMA 

-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# \c edbstore postgres
You are now connected to database "edbstore" as user "postgres".
edbstore=# 
edbstore=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 dbstore   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 delldb    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 delltemp  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 edbstore  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(7 rows)

edbstore=# create user app02 password '123456';
CREATE ROLE
edbstore=# 
edbstore=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 app01     |                                                            | {}
 app02     |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

edbstore=# grant create on database edbstore to app01;
GRANT
edbstore=# 
edbstore=# grant create on database edbstore to app02;
GRANT
edbstore=# 
edbstore=# select current_user;
 current_user 
--------------
 postgres
(1 row)

edbstore=# \c edbstore app01 
You are now connected to database "edbstore" as user "app01".
edbstore=> 
edbstore=> show search_path ;
   search_path   
-----------------
 "$user", public
(1 row)

edbstore=> create schema hr;
CREATE SCHEMA
edbstore=> 
edbstore=> \dn
  List of schemas
  Name  |  Owner   
--------+----------
 hr     | app01
 public | postgres
(2 rows)

edbstore=> \c edbstore postgres 
You are now connected to database "edbstore" as user "postgres".
edbstore=# 
edbstore=# alter user app01 set search_path to hr;
ALTER ROLE
edbstore=# 
edbstore=# \c edbstore app01 
You are now connected to database "edbstore" as user "app01".
edbstore=> 
edbstore=> show search_path ;
 search_path 
-------------
 hr
(1 row)

edbstore=> create schema inventory;
CREATE SCHEMA
edbstore=> 
edbstore=> \dn
   List of schemas
   Name    |  Owner   
-----------+----------
 hr        | app01
 inventory | app01
 public    | postgres
(3 rows)

edbstore=> set search_path to hr,inventory;
SET
edbstore=> 
edbstore=> show search_path ;
  search_path  
---------------
 hr, inventory
(1 row)

edbstore=> create table hr.empinfo(empid int,empname varchar(10));
CREATE TABLE
edbstore=> 
edbstore=> insert into empinfo values(1001,'postgres');
INSERT 0 1
edbstore=> 
edbstore=> \dt
        List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 hr     | empinfo | table | app01
(1 row)

edbstore=> \dn
   List of schemas
   Name    |  Owner   
-----------+----------
 hr        | app01
 inventory | app01
 public    | postgres
(3 rows)

edbstore=> 



=============================

11th May 2022
===============

================================

Day Three :-

User and Schema Management
Log Management
============================================================
GRANT PERMISSION :-

-bash-4.2$ pg_ctl -D data/ start
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |               passwd                | valuntil |    useconfig     
----------+----------+-------------+----------+---------+--------------+-------------------------------------+----------+------------------
 app01    |    24622 | f           | f        | f       | f            | md5fd947e696f52322dc69ab44124f80c9d |          | {search_path=hr}
 postgres |       10 | t           | t        | t       | t            | md5a3556571e93b0d20722ba62be61e8c2d |          | 
 app02    |    24638 | f           | f        | f       | f            | md54fd777cb12e190d15116c22e216e829d |          | 
(3 rows)

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 dbstore   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 delldb    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 delltemp  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 edbstore  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres         +
           |          |          |             |             | postgres=CTc/postgres+
           |          |          |             |             | app01=C/postgres     +
           |          |          |             |             | app02=C/postgres
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(7 rows)

postgres=# \c edbstore app01
You are now connected to database "edbstore" as user "app01".
edbstore=> 
edbstore=> show search_path ;
 search_path 
-------------
 hr
(1 row)

edbstore=> \dt
        List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 hr     | empinfo | table | app01
(1 row)

edbstore=> create table inv (invoice int, prodname varchar(10), dept char(1));
CREATE TABLE
edbstore=> 
edbstore=> \dt
        List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 hr     | empinfo | table | app01
 hr     | inv     | table | app01
(2 rows)

edbstore=> \c - app02
You are now connected to database "edbstore" as user "app02".
edbstore=> 
edbstore=> \dn
   List of schemas
   Name    |  Owner   
-----------+----------
 hr        | app01
 inventory | app01
 public    | postgres
(3 rows)

edbstore=> set search_path to hr;
SET
edbstore=> 
edbstore=> \dt
Did not find any relations.
edbstore=> 
edbstore=> 
edbstore=> \c - app01
You are now connected to database "edbstore" as user "app01".
edbstore=> 
edbstore=> grant USAGE on SCHEMA hr to app02;
GRANT
edbstore=> 
edbstore=> grant select on hr.empinfo to app02;
GRANT
edbstore=> 
edbstore=> \c edbstore app02
You are now connected to database "edbstore" as user "app02".
edbstore=> 
edbstore=> set search_path to hr;
SET
edbstore=> \dt
        List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 hr     | empinfo | table | app01
 hr     | inv     | table | app01
(2 rows)

edbstore=> select * from empinfo ;
 empid | empname  
-------+----------
  1001 | postgres
(1 row)

edbstore=> select * from inv ;
ERROR:  permission denied for table inv
edbstore=> 
edbstore=> 
edbstore=> \c edbstore app01
You are now connected to database "edbstore" as user "app01".
edbstore=> 
edbstore=> \dn
   List of schemas
   Name    |  Owner   
-----------+----------
 hr        | app01
 inventory | app01
 public    | postgres
(3 rows)

edbstore=> create table inventory.prod(prodname varchar(10));
CREATE TABLE
edbstore=> 
edbstore=> grant USAGE on SCHEMA inventory to app02;
GRANT
edbstore=> 
edbstore=> grant select on all tables in schema inventory to app02;
GRANT
edbstore=> 
edbstore=> \c edbstore app02
You are now connected to database "edbstore" as user "app02".
edbstore=> 
edbstore=> \dn
   List of schemas
   Name    |  Owner   
-----------+----------
 hr        | app01
 inventory | app01
 public    | postgres
(3 rows)

edbstore=> set search_path to hr,inventory;
SET
edbstore=> 
edbstore=> \dt
          List of relations
  Schema   |  Name   | Type  | Owner 
-----------+---------+-------+-------
 hr        | empinfo | table | app01
 hr        | inv     | table | app01
 inventory | prod    | table | app01
(3 rows)

edbstore=> 

============================LIST THE USER PRIVILEGES

edbstore=> \c - app01
You are now connected to database "edbstore" as user "app01".
edbstore=> 
edbstore=> select * from information_schema.role_table_grants where grantee='app01';
 grantor | grantee | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
---------+---------+---------------+--------------+------------+----------------+--------------+----------------
 app01   | app01   | edbstore      | hr           | inv        | INSERT         | YES          | NO
 app01   | app01   | edbstore      | hr           | inv        | SELECT         | YES          | YES
 app01   | app01   | edbstore      | hr           | inv        | UPDATE         | YES          | NO
 app01   | app01   | edbstore      | hr           | inv        | DELETE         | YES          | NO
 app01   | app01   | edbstore      | hr           | inv        | TRUNCATE       | YES          | NO
 app01   | app01   | edbstore      | hr           | inv        | REFERENCES     | YES          | NO
 app01   | app01   | edbstore      | hr           | inv        | TRIGGER        | YES          | NO
 app01   | app01   | edbstore      | hr           | empinfo    | INSERT         | YES          | NO
 app01   | app01   | edbstore      | hr           | empinfo    | SELECT         | YES          | YES
 app01   | app01   | edbstore      | hr           | empinfo    | UPDATE         | YES          | NO
 app01   | app01   | edbstore      | hr           | empinfo    | DELETE         | YES          | NO
 app01   | app01   | edbstore      | hr           | empinfo    | TRUNCATE       | YES          | NO
 app01   | app01   | edbstore      | hr           | empinfo    | REFERENCES     | YES          | NO
 app01   | app01   | edbstore      | hr           | empinfo    | TRIGGER        | YES          | NO
 app01   | app01   | edbstore      | inventory    | prod       | INSERT         | YES          | NO
 app01   | app01   | edbstore      | inventory    | prod       | SELECT         | YES          | YES
 app01   | app01   | edbstore      | inventory    | prod       | UPDATE         | YES          | NO
 app01   | app01   | edbstore      | inventory    | prod       | DELETE         | YES          | NO
 app01   | app01   | edbstore      | inventory    | prod       | TRUNCATE       | YES          | NO
 app01   | app01   | edbstore      | inventory    | prod       | REFERENCES     | YES          | NO
 app01   | app01   | edbstore      | inventory    | prod       | TRIGGER        | YES          | NO
(21 rows)

edbstore=> select * from information_schema.role_table_grants where grantee='app02';
 grantor | grantee | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
---------+---------+---------------+--------------+------------+----------------+--------------+----------------
 app01   | app02   | edbstore      | hr           | empinfo    | SELECT         | NO           | YES
 app01   | app02   | edbstore      | inventory    | prod       | SELECT         | NO           | YES
(2 rows)

edbstore=> 

==================================================

==================================================================================
------------------------CASE STUDY ON SCHEMA -----------------------
==================================================================================


Lab Exercise - 1

1. A new website is to be developed for an online music store.
− Create a database user edbstore in your existing cluster
− Create an edbstore database with ownership of edbstore user
− Login to the edbstore database using the edbstore user and create the edbstore schema

Lab Exercise - 2

1. create database fdb
2. create three users f01,f02,f03
3. connect to fdb database with f01 user and create below objects

SCHEMAS: f01_hr, f01_accounts

TABLES :connect to f01_hr schema and create emp_hr(id int) table;

TABLES :connect to f01_hr schema and create emp_admin(id int) table;

TABLES : connect to f01_accounts schema and create emp_accounts(id int) table;

4. GRANT PERMISSION TO f02 user to access only emp_hr table

5. GRANT PERMISSION TO f03 user to access all tables in  f01_hr & f01_accounts 



=======================LOG MANAGEMENT ===========================

[root@localhost ~]# su - postgres
Last login: Wed May 11 08:20:11 IST 2022 on pts/0
-bash-4.2$ 
-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ initdb -D logdata

-bash-4.2$ cd logdata/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 5434

log_directory = 'dell_log'                      # directory where log files are written,
                                        # can be absolute or relative to PGDATA
log_filename = 'dell-postgresql-%a.log' # l

log_min_duration_statement = 2000

:wq

-bash-4.2$ pg_ctl -D /app01/postgres/logdata/ start


==============OPEN TWO TERMINAL

T1 :-

bash-4.2$ psql -p 5434
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# create table log(id int);
CREATE TABLE
postgres=# 
postgres=# insert into log values(generate_series(1,10000));
INSERT 0 10000
postgres=# 
postgres=# insert into log values(generate_series(1,1000000));
INSERT 0 1000000
postgres=# 
postgres=# insert into log values(generate_series(1,100));
INSERT 0 100
postgres=# 
postgres=# insert into log values(generate_series(2,2000000));
INSERT 0 1999999



T2 :-


[root@localhost ~]# tail -f /app01/postgres/logdata/dell_log/dell-postgresql-Wed.log 



=============================================

=================AUDIT LOGS

[root@localhost ~]# su - postgres
Last login: Wed May 11 11:22:53 IST 2022 on pts/1
-bash-4.2$ 
-bash-4.2$ cd logdata/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

log_connections = on

log_duration = on

log_line_prefix = '%t %a %d %u %r %p '          # special values:

log_statement = 'all' 

:wq

bash-4.2$ pg_ctl -D ../logdata/ reload
server signaled
-bash-4.2$ 
-bash-4.2$ psql -p 5434
psql (12.10)
Type "help" for help.

postgres=# show log_connections ;
 log_connections 
-----------------
 on
(1 row)

postgres=# show log_duration ;
 log_duration 
--------------
 on
(1 row)

postgres=# show log_line_prefix ;
  log_line_prefix   
--------------------
 %t %a %d %u %r %p 
(1 row)

postgres=# 
postgres=# show log_statement;
 log_statement 
---------------
 all
(1 row)

postgres=# 


postgres=# create user testuser ;
CREATE ROLE
postgres=# 
postgres=# \c postgres testuser
You are now connected to database "postgres" as user "testuser".
postgres=> 
postgres=> create table test as select * from pg_class;
SELECT 396
postgres=> drop table test;
DROP TABLE


==================NEW TERMINAL 

[root@localhost ~]# tail -f /app01/postgres/logdata/dell_log/dell-postgresql-Wed.log 


===============================PGBADGER

cd /app01/postgres

mkdir pgdata

initdb -D pgdata

cd pgdata

vi postgresql.conf

port=5436

log_destination = 'stderr'      
logging_collector = on      
log_rotation_age = 0            
log_min_messages = warning
log_min_error_statement = error
log_min_duration_statement = 0
log_checkpoints = on
log_connections = on
log_disconnections = on
log_duration = on
log_error_verbosity = verbose       
log_hostname = on
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '
log_lock_waits = on         
log_statement = 'all'       
log_temp_files = 0      

:wq

pg_ctl -D pgdata start

-bash-4.1$ psql -p 5436

create user u01 password '123456';

create user hr password '123456';

create user admin password '123456';

create database db1;

create database db2;

create database db3;

\c db1 u01

create table tbl1 as select * from pg_class;

select count(*) from tbl1;

\c db2 hr

create table tbl1 (id int);

insert into tbl1 select * from generate_Series(1,100000) order by random();

update tbl1 set id=1 where id between 1 and 100;

\c db3 admin

create table tbl1 (id int,name varchar);

insert into tbl1 values(generate_Series(1,100000), 'postgres');

delete from tbl1 where id between 1 and 6000;

select count(*) from tbl1;

\q


[root@postgres Desktop]# cp pgbadger-master.zip /app01/postgres 

[root@postgres]# cd /app01/postgres 

[root@postgres]# unzip pgbadger-master.zip 

[root@postgres]# cd pgbadger-master

[root@postgres pgbadger-master]# 
[root@postgres pgbadger-master]# ./pgbadger -f stderr -o report.html /app01/postgres/pgdata/log/postgres-Wed.log 

[root@postgres pgbadger-master]# ls
ChangeLog  CONTRIBUTING.md  doc  LICENSE  Makefile.PL  MANIFEST  META.yml  pgbadger  README  report.html  tools


open report.html in Linux->Firefox

=================DOWNLOAD LINK 

DOWNLOAD THE PGBADGER FROM BELOW LINK :-

https://github.com/darold/pgbadger



================DOWNLOAD FROM GOOGLE DRIVE

https://drive.google.com/file/d/10-u60S2ojqKQ0J30T7rn2xix3IMrhWh_/view?usp=sharing
===================================================================================================



12th May 2022
+++++++++++++

==========================================TABLESPACE 

[root@localhost ~]# su - postgres

-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.9)
Type "help" for help.

postgres=# show data_directory;
   data_directory   
--------------------
 /opt/postgres/data
(1 row)

postgres=# select spcname from pg_tablespace;
  spcname   
------------
 pg_default
 pg_global
(2 rows)

postgres=# 


postgres=# \q
-bash-4.2$ 
-bash-4.2$ whoami 
postgres
-bash-4.2$ 
-bash-4.2$ exit
logout
[root@localhost ~]# 
[root@localhost ~]# whoami 
root
[root@localhost ~]# mkdir /opt/sgn_postgres
[root@localhost ~]# 
[root@localhost ~]# mkdir /opt/sgn_postgres/sgn_tblspc
[root@localhost ~]# 
[root@localhost ~]# chown postgres:postgres /opt/sgn_postgres/ -R
[root@localhost ~]# 
[root@localhost ~]# su - postgres
Last login: Tue Nov 30 09:39:41 IST 2021 on pts/0
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.9)
Type "help" for help.

postgres=# 
postgres=# select spcname from pg_tablespace;
  spcname   
------------
 pg_default
 pg_global
(2 rows)

postgres=# create tablespace sgn_tblspc location '/opt/sgn_postgres/sgn_tblspc';
CREATE TABLESPACE
postgres=# 
postgres=# select spcname from pg_tablespace;
  spcname   
------------
 pg_default
 pg_global
 sgn_tblspc
(3 rows)

postgres=# \db
                  List of tablespaces
    Name    |  Owner   |            Location            
------------+----------+--------------------------------
 pg_default | postgres | 
 pg_global  | postgres | 
 sgn_tblspc | postgres | /opt/sgn_postgres/sgn_tblspc
(3 rows)

postgres=# select oid,spcname from pg_tablespace;
  oid  |  spcname   
-------+------------
  1663 | pg_default
  1664 | pg_global
 16397 | sgn_tblspc
(3 rows)

postgres=# 



========================================LAB TWO

-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# select oid,spcname,pg_Tablespace_location(oid) from pg_tablespace;
  oid  |  spcname   |    pg_tablespace_location    
-------+------------+------------------------------
  1663 | pg_default | 
  1664 | pg_global  | 
 16527 | sgn_tblspc | /opt/sgn_postgres/sgn_tblspc
(3 rows)

postgres=# \dt
            List of relations
 Schema |    Name     | Type  |  Owner   
--------+-------------+-------+----------
 public | analyzedemo | table | postgres
 public | demo        | table | postgres
 public | sales       | table | postgres
 public | sample      | table | postgres
 public | testdemo    | table | postgres
(5 rows)

postgres=# create table tbl1 (id int);
CREATE TABLE
postgres=# 
postgres=# create table tbl2 (id int) tablespace sgn_tblspc;
CREATE TABLE
postgres=# 
postgres=# create index idx_tbl1 on tbl1 (id) tablespace sgn_tblspc ;
CREATE INDEX
postgres=# 
postgres=# select relfilenode,reltablespace,relname from pg_class where relname like '%tbl%';
 relfilenode | reltablespace |              relname              
-------------+---------------+-----------------------------------
       16528 |             0 | tbl1
       16531 |         16527 | tbl2
       16534 |         16527 | idx_tbl1
           0 |             0 | pg_class_tblspc_relfilenode_index
(4 rows)

postgres=# select oid,spcname,pg_Tablespace_location(oid) from pg_tablespace;
  oid  |  spcname   |    pg_tablespace_location    
-------+------------+------------------------------
  1663 | pg_default | 
  1664 | pg_global  | 
 16527 | sgn_tblspc | /opt/sgn_postgres/sgn_tblspc
(3 rows)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ cd /opt/sgn_postgres/sgn_tblspc/PG_12_201909212/14187/
-bash-4.2$ 
-bash-4.2$ ls
16531  16534
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# \l+
                                                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description              
   
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+-----------------------------------------
---
 dbstore   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8217 kB | pg_default | 
 edbstore  | admin    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8193 kB | pg_default | 
 estore    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres         +| 8809 kB | pg_default | 
           |          |          |             |             | postgres=CTc/postgres+|         |            | 
           |          |          |             |             | app02=C/postgres      |         |            | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 466 MB  | pg_default | default administrative connection databa
se
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | default template for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            | 
(6 rows)

postgres=# 
postgres=# create database db1 tablespace sgn_tblspc ;
CREATE DATABASE
postgres=# 
postgres=# \l+
                                                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description              
   
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+-----------------------------------------
---
 db1       | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8049 kB | sgn_tblspc | 
 dbstore   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8217 kB | pg_default | 
 edbstore  | admin    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8193 kB | pg_default | 
 estore    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres         +| 8809 kB | pg_default | 
           |          |          |             |             | postgres=CTc/postgres+|         |            | 
           |          |          |             |             | app02=C/postgres      |         |            | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 466 MB  | pg_default | default administrative connection databa
se
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | default template for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            | 
(7 rows)

postgres=# select oid,dattablespace,datname from pg_database;
  oid  | dattablespace |  datname  
-------+---------------+-----------
 14187 |          1663 | postgres
     1 |          1663 | template1
 14186 |          1663 | template0
 16455 |          1663 | dbstore
 16480 |          1663 | edbstore
 16469 |          1663 | estore
 16535 |         16527 | db1
(7 rows)

postgres=# select oid,spcname,pg_Tablespace_location(oid) from pg_tablespace;
  oid  |  spcname   |    pg_tablespace_location    
-------+------------+------------------------------
  1663 | pg_default | 
  1664 | pg_global  | 
 16527 | sgn_tblspc | /opt/sgn_postgres/sgn_tblspc
(3 rows)

postgres=# 




=======================LAB THREE 

postgres=# select oid,spcname,pg_Tablespace_location(oid) from pg_tablespace;
  oid  |  spcname   |    pg_tablespace_location    
-------+------------+------------------------------
  1663 | pg_default | 
  1664 | pg_global  | 
 16527 | sgn_tblspc | /opt/sgn_postgres/sgn_tblspc
(3 rows)

postgres=# 
postgres=# select relfilenode,reltablespace,relname from pg_class where relname in ('tbl1','tbl2');
 relfilenode | reltablespace | relname 
-------------+---------------+---------
       16528 |             0 | tbl1
       16531 |         16527 | tbl2
(2 rows)

postgres=# alter table tbl1 set tablespace sgn_tblspc ;
ALTER TABLE
postgres=# 
postgres=# \l+
                                                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description              
   
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+-----------------------------------------
---
 db1       | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8193 kB | sgn_tblspc | 
 dbstore   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8217 kB | pg_default | 
 edbstore  | admin    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 8193 kB | pg_default | 
 estore    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres         +| 8809 kB | pg_default | 
           |          |          |             |             | postgres=CTc/postgres+|         |            | 
           |          |          |             |             | app02=C/postgres      |         |            | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 466 MB  | pg_default | default administrative connection databa
se
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 8049 kB | pg_default | default template for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            | 
(7 rows)

postgres=# 
postgres=# alter database edbstore tablespace sgn_tblspc ;
ALTER DATABASE
postgres=# 


==============MOVING TABLESPACE TO NEW LOCATION

[root@localhost ~]# su - postgres
Last login: Thu May 12 10:03:32 IST 2022 on pts/0
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# \db
                 List of tablespaces
    Name    |  Owner   |           Location           
------------+----------+------------------------------
 pg_default | postgres | 
 pg_global  | postgres | 
 sgn_tblspc | postgres | /opt/sgn_postgres/sgn_tblspc
(3 rows)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ exit
logout
[root@localhost ~]# 
[root@localhost ~]# mkdir /dell_tblspc
[root@localhost ~]# 
[root@localhost ~]# chown postgres:postgres /dell_tblspc/ -R
[root@localhost ~]# 
[root@localhost ~]# su - postgres
Last login: Thu May 12 10:47:06 IST 2022 on pts/1
-bash-4.2$ 
-bash-4.2$ pg_ctl -D /app01/postgres/data/ stop
waiting for server to shut down.... done
server stopped
-bash-4.2$ 
-bash-4.2$ cd /app01/postgres/data/pg_tblspc/
-bash-4.2$ 
-bash-4.2$ ls -ltr
total 0
lrwxrwxrwx. 1 postgres postgres 28 May 12 10:03 16527 -> /opt/sgn_postgres/sgn_tblspc
-bash-4.2$ 
-bash-4.2$ mv /opt/sgn_postgres/sgn_tblspc/ /dell_tblspc/
-bash-4.2$ 
-bash-4.2$ ls -l
total 0
lrwxrwxrwx. 1 postgres postgres 28 May 12 10:03 16527 -> /opt/sgn_postgres/sgn_tblspc
-bash-4.2$ 
-bash-4.2$ 
-bash-4.2$ ln -fs /dell_tblspc/sgn_tblspc/ 16527 
-bash-4.2$ 
-bash-4.2$ pg_ctl -D /app01/postgres/data/ start

-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# \db
               List of tablespaces
    Name    |  Owner   |         Location         
------------+----------+--------------------------
 pg_default | postgres | 
 pg_global  | postgres | 
 sgn_tblspc | postgres | /dell_tblspc/sgn_tblspc/
(3 rows)

postgres=# 


===========================CASE STUDY==========================================

CONNECT TO 5432 CLUSTER :-

==========================
create two tablespace in below location

/home/tbl1

/home/tbl2

connect to edbdata cluster

create database db1 in tbl1 tablespace

create database db2 in tbl2 tablespace

connect to db1

create employee table in tbl2 tablespace

create index for employee table in tbl1 tablespace

connect to db2

create hr table in tbl1 tablespace

create accounts table in tbl2 tablespace

create index for accounts table in tbl2 tablespace

FIND THE OID OF TABLES, TABLESPACE & DATABASE


=====================================
=====================================SECURITY 

-bash-4.2$ mkdir delldata
-bash-4.2$ 
-bash-4.2$ initdb -D delldata/

port = 5435

:wq

-bash-4.2$ pg_ctl -D /app01/postgres/delldata/ start


-bash-4.2$ psql -p 5435
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# show data_directory;
      data_directory      
--------------------------
 /app01/postgres/delldata
(1 row)



postgres=# show hba_file;
               hba_file               
--------------------------------------
 /app01/postgres/delldata/pg_hba.conf
(1 row)

postgres=# 


postgres=# show config_file ;
               config_file                
------------------------------------------
 /app01/postgres/delldata/postgresql.conf
(1 row)
==========================================================================


13th May 2022
+++++++++++++


================================================SECURITY 

[root@localhost ~]# su - postgres
Last login: Thu May 12 17:10:41 IST 2022 on pts/2
-bash-4.2$ 
-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ initdb -d security

-bash-4.2$ cd security/
-bash-4.2$ 
-bash-4.2$ vi pg_hba.conf 

local   edbstore        hr              md5
local   dbstore         accounts        trust
local   postgres        postgres        trust
local   all             postgres        reject
local   all             hr              trust

:wq


-bash-4.2$ vi postgresql.conf 


port = 5436

:WQ

-bash-4.2$ pg_ctl -D /app01/postgres/security/ start

=================================

-bash-4.2$ psql -p 5436
psql (12.10)
Type "help" for help.

postgres=# create database edbstore;
CREATE DATABASE
postgres=# 
postgres=# create database dbstore;
CREATE DATABASE
postgres=# 
postgres=# create user hr password '123456';
CREATE ROLE
postgres=# 
postgres=# create user accounts password '123456';
CREATE ROLE
postgres=# 
postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |               passwd                | valuntil | useconfig 
----------+----------+-------------+----------+---------+--------------+-------------------------------------+----------+-----------
 postgres |       10 | t           | t        | t       | t            |                                     |          | 
 hr       |    16386 | f           | f        | f       | f            | md5e873c0c5c7231d89498e4832f59076cd |          | 
 accounts |    16387 | f           | f        | f       | f            | md56de1d367e3ac32b8e5092d922f3c93ac |          | 
(3 rows)

postgres=# alter user postgres password '123456';
ALTER ROLE
postgres=# 
postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |               passwd                | valuntil | useconfig 
----------+----------+-------------+----------+---------+--------------+-------------------------------------+----------+-----------
 hr       |    16386 | f           | f        | f       | f            | md5e873c0c5c7231d89498e4832f59076cd |          | 
 accounts |    16387 | f           | f        | f       | f            | md56de1d367e3ac32b8e5092d922f3c93ac |          | 
 postgres |       10 | t           | t        | t       | t            | md5a3556571e93b0d20722ba62be61e8c2d |          | 
(3 rows)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ 


========================TEST THE CONNECTION

-bash-4.2$ psql -p 5436 -d edbstore -U hr
Password for user hr: 
psql (12.10)
Type "help" for help.

edbstore=> \q
-bash-4.2$ 
-bash-4.2$ psql -p 5436 -d dbstore -U hr
psql (12.10)
Type "help" for help.

dbstore=> \q
-bash-4.2$ 
-bash-4.2$ 
-bash-4.2$ psql -p 5436 -d dbstore -U accounts
psql (12.10)
Type "help" for help.

dbstore=> \q
-bash-4.2$ 
-bash-4.2$ psql -p 5436 -d postgres -U postgres
psql (12.10)
Type "help" for help.

postgres=# \q
-bash-4.2$ 
-bash-4.2$ psql -p 5436 -d edbstore -U postgres
psql: error: FATAL:  pg_hba.conf rejects connection for host "[local]", user "postgres", database "edbstore", SSL off
-bash-4.2$ 
-bash-4.2$ 

==========================WINDOWS / LINUX ==> PGADMIN =======================

-bash-4.2$ pwd
/app01/postgres/security
-bash-4.2$ 
-bash-4.2$ vi pg_hba.conf 

host    all             all             WINDOWS_IP_ADDR/32        md5


:wq

-bash-4.2$ vi postgresql.conf 

listen_addresses = '*'  

:wq


-bash-4.2$ pg_ctl -D /app01/postgres/security/ restart

==============CONNECT TO PGADMIN 

======AFTER CONNECTION RECONNECT TO LINUX SERVER

bash-4.2$ psql -p 5436 -U postgres -d postgres
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# select pid,client_addr,application_name from pg_stat_activity ;
  pid  |  client_addr  |    application_name     
-------+---------------+-------------------------
 11062 |               | 
 11060 |               | 
 11219 | 192.168.234.1 | pgAdmin 4 - DB:postgres
 11222 |               | psql
 11058 |               | 
 11057 |               | 
 11059 |               | 
(7 rows)

postgres=# 



================================CONFIGURATION====================================

bash-4.2$ psql -p 5436
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# show data_directory;
      data_directory      
--------------------------
 /app01/postgres/security
(1 row)

postgres=# show config_file ;
               config_file                
------------------------------------------
 /app01/postgres/security/postgresql.conf
(1 row)

postgres=# 
postgres=# show hba_file ;
               hba_file               
--------------------------------------
 /app01/postgres/security/pg_hba.conf
(1 row)

postgres=# show work_mem ;
 work_mem 
----------
 4MB
(1 row)

postgres=# select context from pg_Settings where name like 'work_mem%';
 context 
---------
 user
(1 row)

postgres=# set work_mem to '10MB';
SET
postgres=# 
postgres=# show work_mem ;
 work_mem 
----------
 10MB
(1 row)

postgres=# select pg_backend_pid();
 pg_backend_pid 
----------------
          12860
(1 row)

postgres=# \c
You are now connected to database "postgres" as user "postgres".
postgres=# 
postgres=# select pg_backend_pid();
 pg_backend_pid 
----------------
          12970
(1 row)

postgres=# show work_mem ;
 work_mem 
----------
 4MB
(1 row)

postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 accounts  |                                                            | {}
 hr        |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres=# 
postgres=# alter user accounts set maintenance_work_mem to '100MB';
ALTER ROLE
postgres=# 
postgres=# show maintenance_work_mem ;
 maintenance_work_mem 
----------------------
 64MB
(1 row)

postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |               passwd                | valuntil |          useconfig          
 
----------+----------+-------------+----------+---------+--------------+-------------------------------------+----------+-----------------------------
-
 hr       |    16386 | f           | f        | f       | f            | md5e873c0c5c7231d89498e4832f59076cd |          | 
 accounts |    16387 | f           | f        | f       | f            | md56de1d367e3ac32b8e5092d922f3c93ac |          | {maintenance_work_mem=100MB}
 postgres |       10 | t           | t        | t       | t            | md5a3556571e93b0d20722ba62be61e8c2d |          | 
(3 rows)

postgres=# 
postgres=# 
postgres=# \c dbstore accounts 
You are now connected to database "dbstore" as user "accounts".
dbstore=> 
dbstore=> show maintenance_work_mem ;
 maintenance_work_mem 
----------------------
 100MB
(1 row)

dbstore=> \du
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 accounts  |                                                            | {}
 hr        |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

dbstore=> show autovacuum;
 autovacuum 
------------
 on
(1 row)

dbstore=> create table largetbl (id int);
CREATE TABLE
dbstore=> 
dbstore=> alter table largetbl set (autovacuum_enabled=false);
ALTER TABLE
dbstore=> 
dbstore=> select reloptions from pg_class where relname='largetbl';
         reloptions         
----------------------------
 {autovacuum_enabled=false}
(1 row)

dbstore=> show shared_buffers ;
 shared_buffers 
----------------
 128MB
(1 row)

dbstore=> select context from pg_Settings where name like 'shared_buffers%';
  context   
------------
 postmaster
(1 row)

dbstore=> alter system set shared_buffers to '256MB';
ERROR:  must be superuser to execute ALTER SYSTEM command
dbstore=> 
dbstore=> select current_user;
 current_user 
--------------
 accounts
(1 row)

dbstore=> 
dbstore=> \du
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 accounts  |                                                            | {}
 hr        |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

dbstore=> 
dbstore=> \c postgres postgres
You are now connected to database "postgres" as user "postgres".
postgres=# 
postgres=# alter system set shared_buffers to '256MB';
ALTER SYSTEM
postgres=# 
postgres=# show shared_buffers ;
 shared_buffers 
----------------
 128MB
(1 row)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ pg_ctl -D /app01/postgres/security/ restart



-bash-4.2$ psql -p 5436
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
      data_directory      
--------------------------
 /app01/postgres/security
(1 row)

postgres=# 
postgres=# show shared_buffers ;
 shared_buffers 
----------------
 256MB
(1 row)

postgres=# select sourcefile from pg_settings where name ='shared_buffers';
                  sourcefile                   
-----------------------------------------------
 /app01/postgres/security/postgresql.auto.conf
(1 row)

postgres=# 
==========================================CASE STUDY

1. Open psql and write a statement to change work_mem to 10MB. This change must persist across server restarts
2. Open psql and write a statement to change work_mem to 20MB for the current session
3. Open psql and write a statement to change work_mem to 1 MB for the postgres user

4. Open the configuration file for your Postgres database cluster and make the following changes

    A. Maximum allowed connections to 50
    B. Authentication time to 10 mins
    C. Shared buffers to 256 MB
    D. work_mem to 10 MB
    E. wal_buffers to 8MB

================================================

================================================

CONTINOUS ARCHIVING


[root@localhost ~]# su - postgres
Last login: Fri May 13 10:39:52 IST 2022 on pts/0
-bash-4.2$ 
-bash-4.2$ mkdir prod
-bash-4.2$ 
-bash-4.2$ mkdir prodarchive
-bash-4.2$ 
-bash-4.2$ killall postgres
-bash-4.2$ 
-bash-4.2$ initdb -D prod

-bash-4.2$ cd prod
-bash-4.2$ 
-bash-4.2$ vi postgresql.auto.conf 

listen_addresses = '*'

archive_mode=on

archive_command = 'cp %p /app01/postgres/prodarchive/%f'

wal_keep_segments=100

wal_level=replica

:wq

-bash-4.2$ pg_ctl -D /app01/postgres/prod start

-bash-4.2$ ps -ef | grep postgres
root      16268  16225  0 12:25 pts/1    00:00:00 su - postgres
postgres  16269  16268  0 12:25 pts/1    00:00:00 -bash
postgres  16424      1  0 12:27 ?        00:00:00 /usr/pgsql-12/bin/postgres -D /app01/postgres/prod
postgres  16425  16424  0 12:27 ?        00:00:00 postgres: logger   
postgres  16427  16424  0 12:27 ?        00:00:00 postgres: checkpointer   
postgres  16428  16424  0 12:27 ?        00:00:00 postgres: background writer   
postgres  16429  16424  0 12:27 ?        00:00:00 postgres: walwriter   
postgres  16430  16424  0 12:27 ?        00:00:00 postgres: autovacuum launcher   
postgres  16431  16424  0 12:27 ?        00:00:00 postgres: archiver   
postgres  16432  16424  0 12:27 ?        00:00:00 postgres: stats collector   
postgres  16433  16424  0 12:27 ?        00:00:00 postgres: logical replication launcher   


-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
    data_directory    
----------------------
 /app01/postgres/prod
(1 row)

postgres=# show listen_addresses ;
 listen_addresses 
------------------
 *
(1 row)

postgres=# show wal_level ;
 wal_level 
-----------
 replica
(1 row)

postgres=# show archive_mode ;
 archive_mode 
--------------
 on
(1 row)

postgres=# show archive_command ;
           archive_command            
--------------------------------------
 cp %p /app01/postgres/prodarchive/%f
(1 row)

postgres=# show wal_keep_segments ;
 wal_keep_segments 
-------------------
 100
(1 row)

postgres=# 


postgres=# create table archive1 as select * from pg_class,pg_Description;
SELECT 1812260


=============CHECK ARCHIVES IN NEW TERMINAL 

[root@localhost ~]# ls -ltr /app01/postgres/prodarchive/

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
16th May 2022:
==============

Day Five :-

Security
Pgadmin
Configuration
Continous Archiving

Day Six

Backup and Restore
SSH Keygen
PITR
pg_basebackup
pg_receivewal

===============================BACKUP AND RESTORE


=============DATABASE LEVEL 


-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# select datname from pg_Database;
  datname  
-----------
 postgres
 template1
 template0
(3 rows)

postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
postgres=# 
postgres=# create table samples(id int);
CREATE TABLE
postgres=# 
postgres=# insert into samples values(generate_Series(1,10));
INSERT 0 10
postgres=# 
postgres=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | samples | table | postgres
(1 row)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ pg_dump -p 5432 -U postgres postgres -f /app01/postgres/postgres.sql
-bash-4.2$ 
-bash-4.2$ cat /app01/postgres/postgres.sql | less


===============TABLE LEVEL 

-bash-4.2$ 
-bash-4.2$ pg_dump -p 5432 -U postgres postgres --table=samples -f /app01/postgres/sample.sql

======================SCHEMA LEVEL 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# create schema accounts;
CREATE SCHEMA
postgres=# 
postgres=# create table accounts.emp(id int);
CREATE TABLE
postgres=# 
postgres=# insert into accounts.emp values(1);
INSERT 0 1
postgres=# 
postgres=# \q
-bash-4.2$ 
-bash-4.2$ pg_dump -p 5432 -U postgres postgres --schema=accounts -f /app01/postgres/accounts.sql

-bash-4.2$ cat /app01/postgres/accounts.sql 


==========DUMP WITH DATA ONLY NO SCHEMA/ TABLE 

-bash-4.2$ pg_dump -p 5432 -U postgres postgres -a --table=samples  -f /app01/postgres/accounts.sql

==================DUMP ONLY STRUCTURE WITHOUT DATA 

TABLE LEVEL :-

-bash-4.2$ pg_dump -p 5432 -U postgres postgres -s --table=samples  -f /app01/postgres/nodata.sql
-bash-4.2$ 
-bash-4.2$ cat /app01/postgres/nodata.sql 


SCHEMA LEVEL :-

-bash-4.2$ pg_dump -p 5432 -U postgres postgres -s --schema=accounts  -f /app01/postgres/nodata_schema.sql
-bash-4.2$ 
-bash-4.2$ cat /app01/postgres/nodata_schema.sql 


===================SPOOLING


-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# \o /app01/postgres/spool.txt
postgres=# 
postgres=# select * from samples;
postgres=# 
postgres=# \o
postgres=# 
postgres=# \! cat /app01/postgres/spool.txt
 id 
----
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
(10 rows)

postgres=# 

======================IMPORT THE SQL FILES 
-bash-4.2$ vi /app01/postgres/sqldump.sql

create table test (name varchar(10));

insert into test values('postgres');

select * from test;

create database delldatabase;

\c delldatabase postgres

show search_path;

:wq

-bash-4.2$ psql -p 5432 -U postgres -f /app01/postgres/sqldump.sql 

postgres=# \i /app01/postgres/sqldump.sql 


================================

postgres=# \i /app01/postgres/sqldump.sql
CREATE TABLE
INSERT 0 1
   name   
----------
 postgres
(1 row)

CREATE DATABASE
You are now connected to database "delldatabase" as user "postgres".
   search_path   
-----------------
 "$user", public
(1 row)

delldatabase=# \timing
Timing is on.
delldatabase=# 
delldatabase=# create table test as select * from pg_class limit 1;
SELECT 1
Time: 7.466 ms
delldatabase=# \timing
Timing is off.
delldatabase=# 


=========================


delldatabase=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | test | table | postgres
(1 row)

delldatabase=# \t
Tuples only is on.
delldatabase=# 
delldatabase=# \dt
 public | test | table | postgres

delldatabase=# \t
Tuples only is off.
delldatabase=# 
delldatabase=# \c postgres postgres 
You are now connected to database "postgres" as user "postgres".
postgres=# 
postgres=# select * from samples ;
 id 
----
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10
(10 rows)

postgres=# \t
Tuples only is on.
postgres=# 
postgres=# 
postgres=# select * from samples ;
  1
  2
  3
  4
  5
  6
  7
  8
  9
 10

postgres=# \t
Tuples only is off.
postgres=# 



====================================================================


=============================ONLINE BACKUP AND RESTORE 

[root@localhost ~]# su - postgres
Last login: Mon May 16 09:37:40 IST 2022 on pts/1
-bash-4.2$ 
-bash-4.2$ mkdir dell_prod
-bash-4.2$ 
-bash-4.2$ mkdir dell_bkp
-bash-4.2$ 
-bash-4.2$ mkdir dell_archive
-bash-4.2$ 
-bash-4.2$ initdb -D dell_prod/

-bash-4.2$ cd dell_prod/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

listen_addresses = '*'    
port = 5001  
archive_mode = on
archive_command = 'cp %p /app01/postgres/dell_archive/%f'      
wal_keep_segments = 100

:WQ

-bash-4.2$ pg_ctl -D ../dell_prod/ start


-bash-4.2$ ps -ef | grep postgres

postgres  32273      1  1 10:17 ?        00:00:00 /usr/pgsql-12/bin/postgres -D ../dell_prod
postgres  32274  32273  0 10:17 ?        00:00:00 postgres: logger   
postgres  32276  32273  0 10:17 ?        00:00:00 postgres: checkpointer   
postgres  32277  32273  0 10:17 ?        00:00:00 postgres: background writer   
postgres  32278  32273  0 10:17 ?        00:00:00 postgres: walwriter   
postgres  32279  32273  0 10:17 ?        00:00:00 postgres: autovacuum launcher   
postgres  32280  32273  0 10:17 ?        00:00:00 postgres: archiver   
postgres  32281  32273  0 10:17 ?        00:00:00 postgres: stats collector   
postgres  32282  32273  0 10:17 ?        00:00:00 postgres: logical replication launcher   

==================CONNECT TO SERVER

-bash-4.2$ psql -p 5001
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
            data_directory            
--------------------------------------
 /opt/postgres/dell_prod/../dell_prod
(1 row)

postgres=# show archive_mode ;
 archive_mode 
--------------
 on
(1 row)

postgres=# show archive_command ;
           archive_command           
-------------------------------------
 cp %p /opt/postgres/dell_archive/%f
(1 row)

postgres=# show wal_keep_segments ;
 wal_keep_segments 
-------------------
 100
(1 row)

postgres=# create table tbl1 as select * from pg_class,pg_description limit 100000;
SELECT 100000
postgres=# 
postgres=# create table tbl2 as select * from pg_class,pg_description limit 500000;
SELECT 500000
postgres=# 
postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
(2 rows)


postgres=# \q
-bash-4.2$ 
-bash-4.2$ pg_basebackup -p 5001 -D /app01/postgres/dell_bkp -P -v

================AFTER FULL BACKUP 

bash-4.2$ psql -p 5001
psql (12.10)
Type "help" for help.

postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
(2 rows)

postgres=# create table bkp1 as select * from pg_class,pg_description limit 100000;
SELECT 100000
postgres=# 
postgres=# create table bkp2 as select * from pg_class,pg_description limit 1000000;
SELECT 1000000
postgres=# 
postgres=# create table bkp3 as select * from pg_class,pg_description limit 1500000;
SELECT 1500000
postgres=# 
postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | bkp1 | table | postgres
 public | bkp2 | table | postgres
 public | bkp3 | table | postgres
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
(5 rows)

=======================PROD CRASHED 

postgres=# \q

-bash-4.2$ 
-bash-4.2$ pg_ctl -D /app01/postgres/dell_prod/ stop
waiting for server to shut down.... done
server stopped


========RESTORE THE ARCHIVES IN "dell_bkp"

-bash-4.2$ cd /app01/postgres/dell_bkp/


-bash-4.2$ touch recovery.signal
-bash-4.2$ 
-bash-4.2$ vi postgresql.auto.conf 

restore_command='cp /app01/postgres/dell_archive/%f %p'

:wq

-bash-4.2$ chmod 700 /app01/postgres/dell_bkp/


-bash-4.2$ pg_ctl -D /app01/postgres/dell_bkp/ start


-bash-4.2$ tail -f /app01/postgres/dell_bkp/log/postgresql-Mon.log 

=============AFTER RESTORE 

-bash-4.2$ psql -p 5001
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
     data_directory     
------------------------
 /opt/postgres/dell_bkp
(1 row)

postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | bkp1 | table | postgres
 public | bkp2 | table | postgres
 public | bkp3 | table | postgres
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
(5 rows)



===============================================PITR STEPS

-bash-4.2$ pwd
/app01/postgres 
-bash-4.2$ 
-bash-4.2$ mkdir pitrprod
-bash-4.2$ 
-bash-4.2$ mkdir bkppitr
-bash-4.2$ 
-bash-4.2$ mkdir archivepitr
-bash-4.2$ 
-bash-4.2$ initdb -D pitrprod/
-bash-4.2$ cd pitrprod/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 
port = 5005 
archive_mode = on
archive_command = 'cp %p /app01/postgres/archivepitr/%f'  
wal_keep_segments = 100 
:wq

-bash-4.2$ pg_ctl -D ../pitrprod/ start

-bash-4.2$ psql -p 5005

postgres=# 
postgres=# create table bkp1 as select * from pg_class;
SELECT 342
postgres=# create table bkp2 as select * from pg_description;
SELECT 4577
postgres=# create table bkp3 as select * from pg_description,pg_class
postgres=# \q
-bash-4.2$ 
-bash-4.2$ pg_basebackup -p 5005 --format=t -D /app01/postgres/bkppitr/ -P
waiting for checkpoint


-bash-4.2$ psql -p 5005

postgres=# create table pitr1 as select * from pg_class;
SELECT 351
postgres=# select * from current_timestamp;
        current_timestamp         
----------------------------------
 2020-10-28 20:21:36.374256+05:30
(1 row)

postgres=# create table pitr2 as select * from pg_description;
SELECT 4577
postgres=# 
postgres=# select * from current_timestamp;
        current_timestamp         
----------------------------------
 2020-10-28 20:21:47.104666+05:30
(1 row)

postgres=# create table pitr3 as select * from pg_description,pg_class;
SELECT 1633989
postgres=# 
postgres=# select * from current_timestamp;
        current_timestamp         
----------------------------------
 2020-10-28 20:22:21.367584+05:30
(1 row)

postgres=# drop table pitr2;
DROP TABLE
postgres=# 
postgres=# select * from current_timestamp;
        current_timestamp         
----------------------------------
 2020-10-28 20:22:29.700104+05:30
(1 row)

postgres=# create table pitr4 as select * from pg_description;
SELECT 4577
postgres=# 
postgres=# select * from current_timestamp;
        current_timestamp         
----------------------------------
 2020-10-28 20:22:42.023339+05:30
(1 row)

postgres=# \dt
         List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | bkp1  | table | postgres
 public | bkp2  | table | postgres
 public | bkp3  | table | postgres
 public | pitr1 | table | postgres
 public | pitr3 | table | postgres
 public | pitr4 | table | postgres
(6 rows)

postgres=# 


========================CONNECT TO BACKUP SERVER IN NEW TERMINAL 

-bash-4.2$ cd /app01/postgres/bkppitr/
-bash-4.2$ 
-bash-4.2$ ls
base.tar  pg_wal.tar
-bash-4.2$ 
-bash-4.2$ tar -xf base.tar 
-bash-4.2$ 
-bash-4.2$ tar -xf pg_wal.tar 
-bash-4.2$ 
-bash-4.2$ ls

-bash-4.2$ cp 00000001000000000000001B pg_wal

-bash-4.2$ vi postgresql.conf

port=5006

restore_command='cp /app01/postgres/archivepitr/%f %p'

recovery_target_time='2020-10-28 20:21:47'         "NOTE----------------ADD PITR2 CREATION TIMESTAMP"

:wq

-bash-4.2$ touch recovery.signal


-bash-4.2$ chmod 700 /app01/postgres/bkppitr/ 


-bash-4.2$ pg_ctl -D /app01/postgres/bkppitr/ start


-bash-4.2$ psql -p 5006

postgres=# \dt
         List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | bkp1  | table | postgres
 public | bkp2  | table | postgres
 public | bkp3  | table | postgres
 public | pitr1 | table | postgres
 public | pitr2 | table | postgres
(5 rows)

postgres=# \q
-bash-4.2$ 
-bash-4.2$ pg_dump -p 5006 --table=pitr2 -f /app01/postgres/pitr2.sql
-bash-4.2$ 
-bash-4.2$ psql -p 5005 -f /app01/postgres/pitr2.sql 


===========================CONNECT TO PRODUCTION SERVER

-bash-4.2$ psql -p 5005


postgres=# \dt
         List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | bkp1  | table | postgres
 public | bkp2  | table | postgres
 public | bkp3  | table | postgres
 public | pitr1 | table | postgres
 public | pitr2 | table | postgres
 public | pitr3 | table | postgres
 public | pitr4 | table | postgres
(7 rows)

============================================================
=================================================
STEPS FOR TWO VMS :-

1. Stop the current Centos ===> poweroff
2. Take the backup of Centos in the new directory "centos2"
3. Start the two vm's and follow the below steps for remote online backup 

=====================================

PRIMARY SERVER:-

cd dell_prod

vi pg_hba.conf

(LAST LINE)

host        replication         all         2nd_Server_ip/32        trust

:wq


bash$ exit

root@ systemctl stop firewalld


CONNECT TO REMOTE VM

mkdir dell_bkp

pg_basebackup -p 5432 -h 2nd_Server_ip -D dell_bkp  -P -v  

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

17th May 2022
++++++++++++++

===================================================STREAMING REPLICATION

-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ mkdir pdc
-bash-4.2$ 
-bash-4.2$ mkdir sdc
-bash-4.2$ 
-bash-4.2$ mkdir strarchive
-bash-4.2$ 
-bash-4.2$ initdb -D pdc/

-bash-4.2$ cd pdc/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

archive_mode = on
archive_command = 'cp %p /app01/postgres/strarchive/%f'  
listen_addresses = '*'
port = 5401 
wal_keep_segments = 100 (16MB * 100 FILES)
wal_log_hints=on (less data loss/ for failback/ for switchover)

:wq

-bash-4.2$ pg_ctl -D /app01/postgres/pdc/ start
-bash-4.2$ 
-bash-4.2$ pg_basebackup -p 5401 -D /app01/postgres/sdc/
-bash-4.2$ 
-bash-4.2$ cd /app01/postgres/sdc/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 5402
primary_conninfo = 'host=127.0.0.1 port=5401' 

:wq

-bash-4.2$ touch standby.signal
-bash-4.2$ 
-bash-4.2$ chmod 700 /app01/postgres/sdc/ 
-bash-4.2$ 
-bash-4.2$ pg_ctl -D /app01/postgres/sdc/ start


==============OPEN TWO TERMINAL 

TERMINAL ONE :-

-bash-4.2$ psql -p 5401
psql (12.9)
Type "help" for help.

postgres=# show data_directory;
  data_directory   
-------------------
 /app01/postgres/pdc
(1 row)

postgres=# create table sgn as select * from pg_Class;
SELECT 395
postgres=# 


TERMINAL TWO :-

-bash-4.2$ psql -p 5402
psql (12.9)
Type "help" for help.

postgres=# show data_directory;
  data_directory   
-------------------
 /app01/postgres/sdc
(1 row)

postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | sgn  | table | postgres
(1 row)

postgres=# select count(*) from sgn ;
 count 
-------
   395
(1 row)


================================================
================================FAILOVER

PDC = DOWN

SDC = PRIMARY

=============================================

-bash-4.2$ pg_ctl -D /app01/postgres/sdc/ promote
waiting for server to promote.... done
server promoted
-bash-4.2$ 
-bash-4.2$ psql -p 5002
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
  data_directory   
-------------------
 /app01/postgres/sdc
(1 row)

postgres=# select pg_is_in_recovery();
 pg_is_in_recovery 
-------------------
 f
(1 row)

postgres=# create table failover as select * from pg_class;
SELECT 398
postgres=# 
postgres=# 


==========================FAILBACK

SDC = PRIMARY 

PDC = STANDBY

===============

-bash-4.2$ pg_ctl -D /app01/postgres/pdc/ start

-bash-4.2$ pg_ctl -D /app01/postgres/pdc/ stop

-bash-4.2$ pg_rewind -D /app01/postgres/pdc/ --source-server='host=127.0.0.1 port=5002'

bash-4.2$ cd /app01/postgres/pdc/
-bash-4.2$ 
-bash-4.2$ touch standby.signal
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 5001  
primary_conninfo = 'host=127.0.0.1 port=5002'

:wq


-bash-4.2$ pg_ctl -D /app01/postgres/pdc/ start


=============================OPEN TWO TERMINAL 

TERMINAL ONE :-

-bash-4.2$ psql -p 5002
psql (12.10)

postgres=# \dt
            List of relations
 Schema |    Name     | Type  |  Owner   
--------+-------------+-------+----------
 public | failover    | table | postgres
 public | testreplica | table | postgres
(2 rows)

postgres=# show data_directory;
  data_directory   
-------------------
 /app01/postgres/sdc
(1 row)

postgres=# create table failback as select * from pg_class;
SELECT 401



===================================================


TERMINAL TWO :-

-bash-4.2$ psql -p 5001
psql (12.10)
Type "help" for help.

postgres=# \dt
            List of relations
 Schema |    Name     | Type  |  Owner   
--------+-------------+-------+----------
 public | failover    | table | postgres
 public | testreplica | table | postgres
(2 rows)

postgres=# show data_directory;
  data_directory   
-------------------
 /app01/postgres/pdc
(1 row)

postgres=# \dt
            List of relations
 Schema |    Name     | Type  |  Owner   
--------+-------------+-------+----------
 public | failback    | table | postgres
 public | failover    | table | postgres
 public | testreplica | table | postgres
(3 rows)

postgres=# 


==================================================


===SWITCHOVER STEPS

1. STOP SDC

2. PROMOTE PDC

3. copy sdc/postgresql.conf /app01/postgres

4. pg_rewind -D /app01/postgres/sdc --source-server='host=127.0.0.1 port=5001'

5. cp /app01/postgres/postgresql.conf /app01/sdc

6. cd /app01/sdc

7. touch standby.signal

8. pg_ctl -D /app01/postgres/sdc start

9. connect to primary and create switchover table and check in sdc

10 check with pg_is_in_recovery() in both primary and standby


===============================
======================================

=====================CASCADING REPLICATION 

[root@localhost ~]# systemctl stop firewalld



(first server)

-bash-4.2$ mkdir primary
-bash-4.2$ 
-bash-4.2$ initdb -D primary/


-bash-4.2$ cd primary/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

listen_addresses = '*'
port = 6001  
wal_keep_segments = 500    

:wq


-bash-4.2$ 
-bash-4.2$ vi pg_hba.conf 

host    replication     all             0.0.0.0/0               trust


:wq


-bash-4.2$ pg_ctl -D /app01/postgres/primary/ start



=====================STANDBY STANDBY  (remote host)

[root@localhost ~]# systemctl stop firewalld


-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ ls
-bash-4.2$ 
-bash-4.2$ mkdir standby


-bash-4.2$ pg_basebackup -p 6001 -h PRIMARY_IP -D /app01/postgres/standby/



==================CASCADE REPLICATION TWO (remote host)

-bash-4.2$ mkdir cascade2

-bash-4.2$ pg_basebackup -p 6001 -h PRIMARY_IP -D /app01/postgres/cascade2/



==================CASCADE REPLICATION ONE  (first server)

-bash-4.2$ pwd
/app01/postgres
-bash-4.2$ 
-bash-4.2$ ls
-bash-4.2$ 
-bash-4.2$ mkdir cascade1

-bash-4.2$ pg_basebackup -p 6001 -D /app01/postgres/cascade1/

====================SECOND VM : CONNECT TO STANDBY 

-bash-4.2$ cd /opt/postgres/standby/
-bash-4.2$ 
-bash-4.2$ touch standby.signal
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

primary_conninfo = 'host=PRIMARY_IP port=6001'

:wq

-bash-4.2$ chmod 700 ../standby/


====================SECOND VM : CONNECT TO CASCADE TWO

-bash-4.2$ cd cascade2/
-bash-4.2$ 
-bash-4.2$ touch standby.signal
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 6002
primary_conninfo = 'host=127.0.0.1 port=6001'

:wq

-bash-4.2$ chmod 700 ../cascade2

======================FIRST SERVER : CASCADE ONE

-bash-4.2$ cd cascade1/
-bash-4.2$ 
-bash-4.2$ touch standby.signal
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 6002

primary_conninfo = 'host=STANDBY_IP_ADDRESS port=6001'

:wq



================START ALL THREE STANDBY 

-bash-4.2$ pg_ctl -D /app01/postgres/standby/ start


-bash-4.2$ pg_ctl -D /app01/postgres/cascade2/ start


-bash-4.2$ pg_ctl -D /app01/postgres/cascade1/ start


========================CONNECT TO PRIMARY AND CHECK REPLICATION STATUS

FROM PRIMARY 

bash-4.2$ psql -p 6001
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
    data_directory     
-----------------------
 /opt/postgres/primary
(1 row)

postgres=# create table cascade as select * from pg_class;
SELECT 395
postgres=# 
postgres=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | cascade | table | postgres
(1 row)

postgres=# 


==================REMOTE STANDBY 

-bash-4.2$ psql -p 6001
psql (12.4)
Type "help" for help.

postgres=# show data_directory;
    data_directory     
-----------------------
 /opt/postgres/standby
(1 row)

postgres=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | cascade | table | postgres
(1 row)


============================REMOTE CASCADE TWO 

-bash-4.2$ psql -p 6002
psql (12.4)
Type "help" for help.

postgres=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner   
--------+---------+-------+----------
 public | cascade | table | postgres
(1 row)

=========================FIRST SERVER : CASCADE ONE 

-bash-4.2$ psql -p 6002
psql (12.10)
Type "help" for help.

postgres=# show data_directory;
     data_directory     
------------------------
 /opt/postgres/cascade1
(1 row)

postgres=# \dt
Did not find any relations.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
18th May 2022
==============
==============PGPool===================


[root@localhost ~]# chown postgres:postgres /opt/PostgreSQL/ -R
[root@localhost ~]# 
[root@localhost ~]# su - postgres
Last login: Wed May 18 10:00:20 IST 2022

-bash-4.2$ 
-bash-4.2$ cd /opt/PostgreSQL/10/
-bash-4.2$ 
-bash-4.2$ mkdir primary
-bash-4.2$ 
-bash-4.2$ mkdir standby
-bash-4.2$ 
-bash-4.2$ source /opt/PostgreSQL/10/pg_env.sh 
-bash-4.2$ 
-bash-4.2$ 
-bash-4.2$ initdb --version
initdb (PostgreSQL) 10.12
-bash-4.2$ 
-bash-4.2$ initdb -D primary/

-bash-4.2$ cd primary/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 


listen_addresses = '*'
port = 5001 
wal_keep_segments = 500

:wq

-bash-4.2$ pg_ctl -D ../primary/ start
-bash-4.2$ 
-bash-4.2$ pg_basebackup --version
pg_basebackup (PostgreSQL) 10.12
-bash-4.2$ 
-bash-4.2$ pg_basebackup -p 5001 -D /opt/PostgreSQL/10/standby/
-bash-4.2$ 
-bash-4.2$ cd /opt/PostgreSQL/10/standby/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

port = 5002 

:wq


-bash-4.2$ vi recovery.conf

standby_mode=on
primary_conninfo='host=127.0.0.1 port=5001'

:wq


-bash-4.2$ chmod 700 /opt/PostgreSQL/10/standby/
-bash-4.2$ 
-bash-4.2$ pg_ctl -D /opt/PostgreSQL/10/standby/ start

=======================PGPOOL SETUP

-bash-4.2$ exit
logout
[root@localhost ~]# 
[root@localhost ~]# cd Desktop/
[root@localhost Desktop]# 
[root@localhost Desktop]# tar -zxf pgpool-II-4.1.0.tar.gz 

[root@localhost Desktop]# cd pgpool-II-4.1.0/
[root@localhost pgpool-II-4.1.0]# 
[root@localhost pgpool-II-4.1.0]# export LD_LIBRARY_PATH=/opt/PostgreSQL/10/lib
[root@localhost pgpool-II-4.1.0]# 
[root@localhost pgpool-II-4.1.0]# source /opt/PostgreSQL/10/pg_env.sh 
[root@localhost pgpool-II-4.1.0]# 
[root@localhost pgpool-II-4.1.0]# ./configure --prefix=/opt/PostgreSQL/10/bin --libdir=/opt/PostgreSQL/10/lib


[root@localhost pgpool-II-4.1.0]# make 

[root@localhost pgpool-II-4.1.0]# make install

[root@localhost pgpool-II-4.1.0]# chown postgres:postgres /opt/PostgreSQL/ -R
[root@localhost pgpool-II-4.1.0]# 
[root@localhost pgpool-II-4.1.0]# su - postgres
Last login: Wed May 18 10:01:28 IST 2022 on pts/0
-bash-4.2$ 
-bash-4.2$ 
-bash-4.2$ cd /opt/PostgreSQL/10/
-bash-4.2$ 
-bash-4.2$ source pg_env.sh 
-bash-4.2$ 
-bash-4.2$ cd /opt/PostgreSQL/10/bin/etc/
-bash-4.2$ 
-bash-4.2$ cp pgpool.conf.sample-replication pgpool.conf


======================================PGPOOL LAB TWO


-bash-4.2$ vi pgpool.conf

listen_addresses = '*'

backend_hostname0 = '127.0.0.1'
backend_port0 = 5001
backend_data_directory0 = '/opt/PostgreSQL/10/primary'
                                  
backend_hostname1 = '127.0.0.1'
backend_port1 = 5002
backend_data_directory1 = '/opt/PostgreSQL/10/standby'

pid_file_name = '/opt/PostgreSQL/10/pgpool.pid'

health_check_user = 'postgres'


:wq


bash-4.2$ pwd
/opt/PostgreSQL/10/bin/etc
-bash-4.2$ 
-bash-4.2$ cd ../bin/
-bash-4.2$ 
-bash-4.2$ pwd
/opt/PostgreSQL/10/bin/bin
-bash-4.2$ 
-bash-4.2$ ./pgpool &
[1] 19246
-bash-4.2$ 
[1]+  Done                    ./pgpool
-bash-4.2$ 
-bash-4.2$ 
-bash-4.2$ psql -p 9999
psql.bin (10.12)
Type "help" for help.

postgres=# show pool_nodes;
 node_id | hostname  | port | status | lb_weight |  role  | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_state | last_status_change  
---------+-----------+------+--------+-----------+--------+------------+-------------------+-------------------+-------------------+------------------------+---------------------
 0       | 127.0.0.1 | 5001 | up     | 1.000000  | master | 0          | true              | 0                 |                   |                        | 2022-05-18 11:27:41
 1       | 127.0.0.1 | 5002 | up     | 0.000000  | slave  | 0          | false             | 0                 |                   |                        | 2022-05-18 11:27:41
(2 rows)

postgres=# 


===========================================
================================PGBOUNCER

[root@localhost ~]# yum install pgbouncer

-bash-4.2$ mkdir delldata
-bash-4.2$ 
-bash-4.2$ initdb --version
initdb (PostgreSQL) 12.10
-bash-4.2$ 
-bash-4.2$ initdb -D delldata/

-bash-4.2$ cd delldata/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

listen_addresses = '*'
port = 6001  

:wq


-bash-4.2$ pg_ctl -D ../delldata/ start



bash-4.2$ psql -p 6001
psql (12.10)
Type "help" for help.

postgres=# 
postgres=# select datname from pg_database;
  datname  
-----------
 postgres
 template1
 template0
(3 rows)

postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls | passwd | valuntil | useconfig 
----------+----------+-------------+----------+---------+--------------+--------+----------+-----------
 postgres |       10 | t           | t        | t       | t            |        |          | 
(1 row)

postgres=# alter user postgres password '123456';
ALTER ROLE
postgres=# 
postgres=# select * from pg_shadow ;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |               passwd                | valuntil | useconfig 
----------+----------+-------------+----------+---------+--------------+-------------------------------------+----------+-----------
 postgres |       10 | t           | t        | t       | t            | md5a3556571e93b0d20722ba62be61e8c2d |          | 
(1 row)


=================NEW TERMINAL

[root@localhost ~]# vi /etc/pgbouncer/pgbouncer.ini

postgres=host=localhost port=6001
listen_addr = 127.0.0.1
listen_port = 6432


:wq

[root@localhost ~]# vi /etc/pgbouncer/userlist.txt 
"postgres" "md5a3556571e93b0d20722ba62be61e8c2d"
:wq


[root@localhost ~]# systemctl start pgbouncer
[root@localhost ~]# 
[root@localhost ~]# systemctl status pgbouncer

[root@localhost ~]# su - postgres
Last login: Wed May 18 12:01:39 IST 2022 on pts/1


-bash-4.2$ psql -p 6432 -U postgres -d postgres -h 127.0.0.1
psql (12.10)
Type "help" for help.

postgres=# show port;
 port 
------
 6001
(1 row)

postgres=# select inet_server_port(),inet_server_addr();
 inet_server_port | inet_server_addr 
------------------+------------------
             6001 | 127.0.0.1
(1 row)


+++++++++++++++++++++++++++++++++++++++++++++++++++++
19thMay2022
============


===========================PERFORMANCE TUNING LAB TWO 

[root@localhost ~]# su - postgres
Last login: Thu May 19 07:53:16 IST 2022 on pts/1
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# select relpages,reltuples from pg_class where relname='sales_2021';
 relpages | reltuples 
----------+-----------
       55 |     10000
(1 row)

postgres=# explain analyze select * from sales_2021 ;
                                                  QUERY PLAN                                                   
---------------------------------------------------------------------------------------------------------------
 Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=13) (actual time=0.066..1.496 rows=10000 loops=1)
 Planning Time: 0.127 ms
 Execution Time: 2.339 ms
(3 rows)

postgres=# explain delete from sales_2021 ;
                              QUERY PLAN                              
----------------------------------------------------------------------
 Delete on sales_2021  (cost=0.00..155.00 rows=10000 width=6)
   ->  Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=6)
(2 rows)

postgres=# select count(*) from sales_2021 ;
 count 
-------
 10000
(1 row)

postgres=# explain analyze delete from sales_2021 ;
                                                     QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 Delete on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=45.839..45.842 rows=0 loops=1)
   ->  Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=0.023..3.511 rows=10000 loops=1)
 Planning Time: 0.053 ms
 Execution Time: 45.882 ms
(4 rows)

postgres=# 
postgres=# select count(*) from sales_2021 ;
 count 
-------
     0
(1 row)

postgres=# truncate sales_2021 ;
TRUNCATE TABLE
postgres=# 
postgres=# insert into sales_2021 values(generate_series(1,10000),'postgres');
INSERT 0 10000
postgres=# 
postgres=# analyze sales_2021 ;
ANALYZE
postgres=# BEGIN;
BEGIN
postgres=# 
postgres=# explain analyze delete from sales_2021 ;
                                                     QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 Delete on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=34.941..34.942 rows=0 loops=1)
   ->  Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=0.012..2.172 rows=10000 loops=1)
 Planning Time: 0.077 ms
 Execution Time: 34.983 ms
(4 rows)

postgres=# select count(*) from sales_2021 ;
 count 
-------
     0
(1 row)

postgres=# ROLLBACK;
ROLLBACK
postgres=# 
postgres=# select count(*) from sales_2021 ;
 count 
-------
 10000
(1 row)

postgres=# show work_mem ;
 work_mem 
----------
 4MB
(1 row)

postgres=# show maintenance_work_mem ;
 maintenance_work_mem 
----------------------
 64MB
(1 row)

postgres=# create table sales_2022(id int);
CREATE TABLE
postgres=# 
postgres=# insert into sales_2022 values(generate_Series(1,1000000));
INSERT 0 1000000
postgres=# 
postgres=# 
postgres=# analyze sales_2022 ;
ANALYZE
postgres=# 
postgres=# explain analyze select * from sales_2022 order by id limit 1000;^C
postgres=# 
postgres=# 
postgres=# set work_mem to '64kB';
SET
postgres=# 
postgres=# explain analyze select * from sales_2022 order by id limit 1000;
                                                                  QUERY PLAN                                                                  
----------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=32437.09..32553.77 rows=1000 width=4) (actual time=1156.928..1157.887 rows=1000 loops=1)
   ->  Gather Merge  (cost=32437.09..129666.18 rows=833334 width=4) (actual time=1156.927..1157.732 rows=1000 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Sort  (cost=31437.07..32478.74 rows=416667 width=4) (actual time=1038.266..1038.480 rows=1000 loops=3)
               Sort Key: id
               Sort Method: external merge  Disk: 5384kB
               Worker 0:  Sort Method: external merge  Disk: 4592kB
               Worker 1:  Sort Method: external merge  Disk: 3816kB
               ->  Parallel Seq Scan on sales_2022  (cost=0.00..8591.67 rows=416667 width=4) (actual time=0.045..168.573 rows=333333 loops=3)
 Planning Time: 0.709 ms
 Execution Time: 1159.730 ms
(12 rows)

postgres=# 
postgres=# set work_mem to '4MB';
SET
postgres=# 
postgres=# explain analyze select * from sales_2022 order by id limit 1000;
                                                                  QUERY PLAN                                                                  
----------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=32437.09..32553.77 rows=1000 width=4) (actual time=417.281..417.747 rows=1000 loops=1)
   ->  Gather Merge  (cost=32437.09..129666.18 rows=833334 width=4) (actual time=417.280..417.662 rows=1000 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Sort  (cost=31437.07..32478.74 rows=416667 width=4) (actual time=371.292..371.374 rows=1000 loops=3)
               Sort Key: id
               Sort Method: top-N heapsort  Memory: 95kB
               Worker 0:  Sort Method: top-N heapsort  Memory: 95kB
               Worker 1:  Sort Method: top-N heapsort  Memory: 95kB
               ->  Parallel Seq Scan on sales_2022  (cost=0.00..8591.67 rows=416667 width=4) (actual time=0.022..231.688 rows=333333 loops=3)
 Planning Time: 0.079 ms
 Execution Time: 417.822 ms
(12 rows)

postgres=# show maintenance_work_mem ;
 maintenance_work_mem 
----------------------
 64MB
(1 row)

postgres=# set maintenance_work_mem to '1MB';
SET
postgres=# 
postgres=# \timing
Timing is on.
postgres=# 
postgres=# create index idx1 on sales_2022 (id);
CREATE INDEX
Time: 1503.237 ms (00:01.503)
postgres=# 
postgres=# \timing
Timing is off.
postgres=# 
postgres=# set maintenance_work_mem to '100MB';
SET
postgres=# 
postgres=# \timing
Timing is on.
postgres=# 
postgres=# create index idx2 on sales_2022 (id);
CREATE INDEX
Time: 1194.847 ms (00:01.195)
postgres=# 
postgres=# \timing
Timing is off.
postgres=# 
postgres=# 
postgres=# 
postgres=# 
postgres=# create table t_test(id int);
CREATE TABLE
postgres=# 
postgres=# insert into t_test select * from generate_series(1,2500000) order by random();
INSERT 0 2500000
postgres=# 
postgres=# analyze t_test ;
ANALYZE
postgres=# 
postgres=# set effective_cache_size to '1MB';
SET
postgres=# 
postgres=# explain select * from t_test order by id limit 1000;
                                        QUERY PLAN                                         
-------------------------------------------------------------------------------------------
 Limit  (cost=79592.17..79708.84 rows=1000 width=4)
   ->  Gather Merge  (cost=79592.17..322664.77 rows=2083334 width=4)
         Workers Planned: 2
         ->  Sort  (cost=78592.14..81196.31 rows=1041667 width=4)
               Sort Key: id
               ->  Parallel Seq Scan on t_test  (cost=0.00..21478.67 rows=1041667 width=4)
(6 rows)

postgres=# 
postgres=# create index idx on t_test (id);
CREATE INDEX
postgres=# 
postgres=# analyze t_test ;
ANALYZE
postgres=# set effective_cache_size to '1MB';
SET
postgres=# 
postgres=# explain select * from t_test order by id limit 1000;
                                       QUERY PLAN                                        
-----------------------------------------------------------------------------------------
 Limit  (cost=0.43..3997.47 rows=1000 width=4)
   ->  Index Only Scan using idx on t_test  (cost=0.43..9992603.76 rows=2500000 width=4)
(2 rows)

postgres=# 
postgres=# set effective_cache_size to '512MB';
SET
postgres=# 
postgres=# explain select * from t_test order by id limit 1000;
                                       QUERY PLAN                                       
----------------------------------------------------------------------------------------
 Limit  (cost=0.43..44.10 rows=1000 width=4)
   ->  Index Only Scan using idx on t_test  (cost=0.43..109180.39 rows=2500000 width=4)
(2 rows)

postgres=# 


===================================SCAN METHODS ========================

[root@localhost ~]# su - postgres
Last login: Thu May 19 07:53:16 IST 2022 on pts/1
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.10)
Type "help" for help.

postgres=# select relpages,reltuples from pg_class where relname='sales_2021';
 relpages | reltuples 
----------+-----------
       55 |     10000
(1 row)

postgres=# explain analyze select * from sales_2021 ;
                                                  QUERY PLAN                                                   
---------------------------------------------------------------------------------------------------------------
 Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=13) (actual time=0.066..1.496 rows=10000 loops=1)
 Planning Time: 0.127 ms
 Execution Time: 2.339 ms
(3 rows)

postgres=# explain delete from sales_2021 ;
                              QUERY PLAN                              
----------------------------------------------------------------------
 Delete on sales_2021  (cost=0.00..155.00 rows=10000 width=6)
   ->  Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=6)
(2 rows)

postgres=# select count(*) from sales_2021 ;
 count 
-------
 10000
(1 row)

postgres=# explain analyze delete from sales_2021 ;
                                                     QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 Delete on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=45.839..45.842 rows=0 loops=1)
   ->  Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=0.023..3.511 rows=10000 loops=1)
 Planning Time: 0.053 ms
 Execution Time: 45.882 ms
(4 rows)

postgres=# 
postgres=# select count(*) from sales_2021 ;
 count 
-------
     0
(1 row)

postgres=# truncate sales_2021 ;
TRUNCATE TABLE
postgres=# 
postgres=# insert into sales_2021 values(generate_series(1,10000),'postgres');
INSERT 0 10000
postgres=# 
postgres=# analyze sales_2021 ;
ANALYZE
postgres=# BEGIN;
BEGIN
postgres=# 
postgres=# explain analyze delete from sales_2021 ;
                                                     QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 Delete on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=34.941..34.942 rows=0 loops=1)
   ->  Seq Scan on sales_2021  (cost=0.00..155.00 rows=10000 width=6) (actual time=0.012..2.172 rows=10000 loops=1)
 Planning Time: 0.077 ms
 Execution Time: 34.983 ms
(4 rows)

postgres=# select count(*) from sales_2021 ;
 count 
-------
     0
(1 row)

postgres=# ROLLBACK;
ROLLBACK
postgres=# 
postgres=# select count(*) from sales_2021 ;
 count 
-------
 10000
(1 row)

postgres=# show work_mem ;
 work_mem 
----------
 4MB
(1 row)

postgres=# show maintenance_work_mem ;
 maintenance_work_mem 
----------------------
 64MB
(1 row)

postgres=# create table sales_2022(id int);
CREATE TABLE
postgres=# 
postgres=# insert into sales_2022 values(generate_Series(1,1000000));
INSERT 0 1000000
postgres=# 
postgres=# 
postgres=# analyze sales_2022 ;
ANALYZE
postgres=# 
postgres=# explain analyze select * from sales_2022 order by id limit 1000;^C
postgres=# 
postgres=# 
postgres=# set work_mem to '64kB';
SET
postgres=# 
postgres=# explain analyze select * from sales_2022 order by id limit 1000;
                                                                  QUERY PLAN                                                                  
----------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=32437.09..32553.77 rows=1000 width=4) (actual time=1156.928..1157.887 rows=1000 loops=1)
   ->  Gather Merge  (cost=32437.09..129666.18 rows=833334 width=4) (actual time=1156.927..1157.732 rows=1000 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Sort  (cost=31437.07..32478.74 rows=416667 width=4) (actual time=1038.266..1038.480 rows=1000 loops=3)
               Sort Key: id
               Sort Method: external merge  Disk: 5384kB
               Worker 0:  Sort Method: external merge  Disk: 4592kB
               Worker 1:  Sort Method: external merge  Disk: 3816kB
               ->  Parallel Seq Scan on sales_2022  (cost=0.00..8591.67 rows=416667 width=4) (actual time=0.045..168.573 rows=333333 loops=3)
 Planning Time: 0.709 ms
 Execution Time: 1159.730 ms
(12 rows)

postgres=# 
postgres=# set work_mem to '4MB';
SET
postgres=# 
postgres=# explain analyze select * from sales_2022 order by id limit 1000;
                                                                  QUERY PLAN                                                                  
----------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=32437.09..32553.77 rows=1000 width=4) (actual time=417.281..417.747 rows=1000 loops=1)
   ->  Gather Merge  (cost=32437.09..129666.18 rows=833334 width=4) (actual time=417.280..417.662 rows=1000 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Sort  (cost=31437.07..32478.74 rows=416667 width=4) (actual time=371.292..371.374 rows=1000 loops=3)
               Sort Key: id
               Sort Method: top-N heapsort  Memory: 95kB
               Worker 0:  Sort Method: top-N heapsort  Memory: 95kB
               Worker 1:  Sort Method: top-N heapsort  Memory: 95kB
               ->  Parallel Seq Scan on sales_2022  (cost=0.00..8591.67 rows=416667 width=4) (actual time=0.022..231.688 rows=333333 loops=3)
 Planning Time: 0.079 ms
 Execution Time: 417.822 ms
(12 rows)

postgres=# show maintenance_work_mem ;
 maintenance_work_mem 
----------------------
 64MB
(1 row)

postgres=# set maintenance_work_mem to '1MB';
SET
postgres=# 
postgres=# \timing
Timing is on.
postgres=# 
postgres=# create index idx1 on sales_2022 (id);
CREATE INDEX
Time: 1503.237 ms (00:01.503)
postgres=# 
postgres=# \timing
Timing is off.
postgres=# 
postgres=# set maintenance_work_mem to '100MB';
SET
postgres=# 
postgres=# \timing
Timing is on.
postgres=# 
postgres=# create index idx2 on sales_2022 (id);
CREATE INDEX
Time: 1194.847 ms (00:01.195)
postgres=# 
postgres=# \timing
Timing is off.
postgres=# 
postgres=# 
postgres=# 
postgres=# 
postgres=# create table t_test(id int);
CREATE TABLE
postgres=# 
postgres=# insert into t_test select * from generate_series(1,2500000) order by random();
INSERT 0 2500000
postgres=# 
postgres=# analyze t_test ;
ANALYZE
postgres=# 
postgres=# set effective_cache_size to '1MB';
SET
postgres=# 
postgres=# explain select * from t_test order by id limit 1000;
                                        QUERY PLAN                                         
-------------------------------------------------------------------------------------------
 Limit  (cost=79592.17..79708.84 rows=1000 width=4)
   ->  Gather Merge  (cost=79592.17..322664.77 rows=2083334 width=4)
         Workers Planned: 2
         ->  Sort  (cost=78592.14..81196.31 rows=1041667 width=4)
               Sort Key: id
               ->  Parallel Seq Scan on t_test  (cost=0.00..21478.67 rows=1041667 width=4)
(6 rows)

postgres=# 
postgres=# create index idx on t_test (id);
CREATE INDEX
postgres=# 
postgres=# analyze t_test ;
ANALYZE
postgres=# set effective_cache_size to '1MB';
SET
postgres=# 
postgres=# explain select * from t_test order by id limit 1000;
                                       QUERY PLAN                                        
-----------------------------------------------------------------------------------------
 Limit  (cost=0.43..3997.47 rows=1000 width=4)
   ->  Index Only Scan using idx on t_test  (cost=0.43..9992603.76 rows=2500000 width=4)
(2 rows)

postgres=# 
postgres=# set effective_cache_size to '512MB';
SET
postgres=# 
postgres=# explain select * from t_test order by id limit 1000;
                                       QUERY PLAN                                       
----------------------------------------------------------------------------------------
 Limit  (cost=0.43..44.10 rows=1000 width=4)
   ->  Index Only Scan using idx on t_test  (cost=0.43..109180.39 rows=2500000 width=4)
(2 rows)

postgres=# 
postgres=# create table emp(id int,name varchar(10));
CREATE TABLE
postgres=# 
postgres=# insert into emp values(generate_Series(1,10000),'postgres');
INSERT 0 10000
postgres=# 
postgres=# analyze emp ;
ANALYZE
postgres=# 
postgres=# explain select * from emp where id=500;
                      QUERY PLAN                      
------------------------------------------------------
 Seq Scan on emp  (cost=0.00..180.00 rows=1 width=13)
   Filter: (id = 500)
(2 rows)

postgres=# create index idx_emp on emp (id);
CREATE INDEX
postgres=# 
postgres=# explain select * from emp where id=500;
                             QUERY PLAN                             
--------------------------------------------------------------------
 Index Scan using idx_emp on emp  (cost=0.29..8.30 rows=1 width=13)
   Index Cond: (id = 500)
(2 rows)

postgres=# \d emp 
                       Table "public.emp"
 Column |         Type          | Collation | Nullable | Default 
--------+-----------------------+-----------+----------+---------
 id     | integer               |           |          | 
 name   | character varying(10) |           |          | 
Indexes:
    "idx_emp" btree (id)

postgres=# 
postgres=# explain select * from emp where id=500;
                             QUERY PLAN                             
--------------------------------------------------------------------
 Index Scan using idx_emp on emp  (cost=0.29..8.30 rows=1 width=13)
   Index Cond: (id = 500)
(2 rows)

postgres=# explain select id from emp where id=500;
                               QUERY PLAN                               
------------------------------------------------------------------------
 Index Only Scan using idx_emp on emp  (cost=0.29..8.30 rows=1 width=4)
   Index Cond: (id = 500)
(2 rows)

postgres=# select ctid from emp where id=500;
  ctid   
---------
 (2,130)
(1 row)

postgres=# explain select * from emp where ctid='ctid(2,130)';
                     QUERY PLAN                     
----------------------------------------------------
 Tid Scan on emp  (cost=0.00..4.01 rows=1 width=13)
   TID Cond: (ctid = '(2,130)'::tid)
(2 rows)

postgres=# 
postgres=# \d demoanalyze 
            Table "public.demoanalyze"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           |          | 

postgres=# 
postgres=# truncate demoanalyze ;
TRUNCATE TABLE
postgres=# 
postgres=# insert into demoanalyze values(generate_Series(1,10));
INSERT 0 10
postgres=# 
postgres=# select ctid,* from demoanalyze ;
  ctid  | id 
--------+----
 (0,1)  |  1
 (0,2)  |  2
 (0,3)  |  3
 (0,4)  |  4
 (0,5)  |  5
 (0,6)  |  6
 (0,7)  |  7
 (0,8)  |  8
 (0,9)  |  9
 (0,10) | 10
(10 rows)

postgres=# delete from demoanalyze where id in (2,4,6);
DELETE 3
postgres=# 
postgres=# select ctid,* from demoanalyze ;
  ctid  | id 
--------+----
 (0,1)  |  1
 (0,3)  |  3
 (0,5)  |  5
 (0,7)  |  7
 (0,8)  |  8
 (0,9)  |  9
 (0,10) | 10
(7 rows)

postgres=# vacuum full demoanalyze ;
VACUUM
postgres=# 
postgres=# select ctid,* from demoanalyze ;
 ctid  | id 
-------+----
 (0,1) |  1
 (0,2) |  3
 (0,3) |  5
 (0,4) |  7
 (0,5) |  8
 (0,6) |  9
 (0,7) | 10
(7 rows)

postgres=# insert into demoanalyze values(11),(12),(13),(2),(4),(6)
postgres-# ;
INSERT 0 6
postgres=# 
postgres=# select ctid,* from demoanalyze ;
  ctid  | id 
--------+----
 (0,1)  |  1
 (0,2)  |  3
 (0,3)  |  5
 (0,4)  |  7
 (0,5)  |  8
 (0,6)  |  9
 (0,7)  | 10
 (0,8)  | 11
 (0,9)  | 12
 (0,10) | 13
 (0,11) |  2
 (0,12) |  4
 (0,13) |  6
(13 rows)

postgres=# create index idx_da on demoanalyze (id);
CREATE INDEX
postgres=# 
postgres=# cluster demoanalyze using idx_da ;
CLUSTER
postgres=# 
postgres=# select ctid,* from demoanalyze ;
  ctid  | id 
--------+----
 (0,1)  |  1
 (0,2)  |  2
 (0,3)  |  3
 (0,4)  |  4
 (0,5)  |  5
 (0,6)  |  6
 (0,7)  |  7
 (0,8)  |  8
 (0,9)  |  9
 (0,10) | 10
 (0,11) | 11
 (0,12) | 12
 (0,13) | 13
(13 rows)

postgres=# \d demoanalyze 
            Table "public.demoanalyze"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           |          | 
Indexes:
    "idx_da" btree (id) CLUSTER

postgres=# create table mltclm (id1 int, id2 int);
CREATE TABLE
postgres=# 
postgres=# insert into mltclm values(Generate_Series(1,1000),generate_Series(1,1000));
INSERT 0 1000
postgres=# 
postgres=# create index idx_mlt on mltclm (id1,id2);
CREATE INDEX
postgres=# 
postgres=# analyze mltclm ;
ANALYZE
postgres=# 
postgres=# explain select * from mltclm where id1=500;
                                QUERY PLAN                                 
---------------------------------------------------------------------------
 Index Only Scan using idx_mlt on mltclm  (cost=0.28..8.29 rows=1 width=8)
   Index Cond: (id1 = 500)
(2 rows)

postgres=# explain select * from mltclm where id2=500;
                      QUERY PLAN                       
-------------------------------------------------------
 Seq Scan on mltclm  (cost=0.00..17.50 rows=1 width=8)
   Filter: (id2 = 500)
(2 rows)

postgres=# explain select * from mltclm where id1=300 or id2=500;
                      QUERY PLAN                       
-------------------------------------------------------
 Seq Scan on mltclm  (cost=0.00..20.00 rows=2 width=8)
   Filter: ((id1 = 300) OR (id2 = 500))
(2 rows)

postgres=# explain select * from mltclm where id1=300 and id2=500;
                                QUERY PLAN                                 
---------------------------------------------------------------------------
 Index Only Scan using idx_mlt on mltclm  (cost=0.28..8.29 rows=1 width=8)
   Index Cond: ((id1 = 300) AND (id2 = 500))
(2 rows)

postgres=# 




++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
20th May 2022
================
Day Ten :-

EDB BART
EDB MTK (Migration : Oracle to PostgreSQL)
Major and Minor Version upgrade
PGBackRest
Table Partition
=============================================



[root@localhost Desktop]# su - postgres
Last login: Thu May 19 17:15:34 IST 2022 on pts/2
-bash-4.2$ 
-bash-4.2$ mkdir dellbart
-bash-4.2$ 
-bash-4.2$ mkdir dellarchive
-bash-4.2$ 
-bash-4.2$ initdb -D delldata


-bash-4.2$ cd delldata/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

listen_addresses = '*' 
archive_mode = on
archive_command = 'cp %p /opt/postgres/dellarchive/%f'  

:wq

-bash-4.2$ pg_ctl -D /opt/postgres/delldata/ start

=================BART CONFIG

[root@localhost Desktop]# vi /usr/edb-bart-1.1/etc/bart.cfg 

[BART]
bart-host= postgres@127.0.0.1
backup_path = /opt/postgres/dellbart
pg_basebackup_path = /usr/pgsql-12/bin/pg_basebackup
logfile = /tmp/bart.log

[dell_datacenter]
host = 127.0.0.1
port = 5432
user = postgres
description = "Postgres server"
retention_policy=1 BACKUPS

:wq


[root@localhost Desktop]# su - postgres
Last login: Fri May 20 09:27:43 IST 2022 on pts/1
-bash-4.2$ 
-bash-4.2$ cd /usr/edb-bart-1.1/bin/
-bash-4.2$ 
-bash-4.2$ ./bart BACKUP -s dell_datacenter 

-bash-4.2$ ./bart SHOW-BACKUPS -s dell_datacenter
 SERVER NAME       BACKUP ID       BACKUP TIME               BACKUP SIZE   WAL(s) SIZE   WAL FILES   STATUS  
                                                                                                             
 dell_datacenter   1653019668336   2022-05-20 09:37:49 IST   40.73 MB      0.00 bytes    0           active  

==================

-bash-4.2$ psql -p 5432
psql (12.11)
Type "help" for help.

postgres=# create table tbl1 as select * from pg_class,pg_Description;
SELECT 1812260
postgres=# 
postgres=# \q

-bash-4.2$ 
-bash-4.2$ ./bart SHOW-BACKUPS -s dell_datacenter
 SERVER NAME       BACKUP ID       BACKUP TIME               BACKUP SIZE   WAL(s) SIZE   WAL FILES   STATUS  
                                                                                                             
 dell_datacenter   1653019668336   2022-05-20 09:37:49 IST   40.73 MB      0.00 bytes    0           active  
                                                                                                             
-bash-4.2$ ./bart BACKUP -s dell_datacenter 

-bash-4.2$ ./bart SHOW-BACKUPS -s dell_datacenter
 SERVER NAME       BACKUP ID       BACKUP TIME               BACKUP SIZE   WAL(s) SIZE   WAL FILES   STATUS  
                                                                                                             
 dell_datacenter   1653019795177   2022-05-20 09:40:57 IST   461.60 MB     0.00 bytes    0           active  
 dell_datacenter   1653019668336   2022-05-20 09:37:49 IST   40.73 MB      0.00 bytes    0           active  

=======================================

-bash-4.2$ ./bart SHOW-BACKUPS -s dell_datacenter
 SERVER NAME       BACKUP ID       BACKUP TIME               BACKUP SIZE   WAL(s) SIZE   WAL FILES   STATUS  
                                                                                                             
 dell_datacenter   1653019795177   2022-05-20 09:40:57 IST   461.60 MB     0.00 bytes    0           active  
 dell_datacenter   1653019668336   2022-05-20 09:37:49 IST   40.73 MB      0.00 bytes    0           active  
                                                                                                             
-bash-4.2$ 
-bash-4.2$ ./bart MANAGE -s dell_datacenter
INFO:  processing server 'dell_datacenter', backup '1653019795177'
INFO:  processing server 'dell_datacenter', backup '1653019668336'
INFO:  marking backup '1653019668336' as obsolete
INFO:  0 WAL file(s) marked obsolete
-bash-4.2$ 
-bash-4.2$ ./bart SHOW-BACKUPS -s dell_datacenter
 SERVER NAME       BACKUP ID       BACKUP TIME               BACKUP SIZE   WAL(s) SIZE   WAL FILES   STATUS    
                                                                                                               
 dell_datacenter   1653019795177   2022-05-20 09:40:57 IST   461.60 MB     0.00 bytes    0           active    
 dell_datacenter   1653019668336   2022-05-20 09:37:49 IST   40.73 MB      0.00 bytes    0           obsolete  
                                                                                                               
-bash-4.2$ ./bart DELETE -s dell_datacenter -i 1653019668336
INFO:  deleting backup '1653019668336' of server 'dell_datacenter'
INFO:  deleting backup '1653019668336'
INFO:  0 WAL file(s) will be removed
INFO:  backup(s) deleted
-bash-4.2$ 
-bash-4.2$ ./bart SHOW-BACKUPS -s dell_datacenter
 SERVER NAME       BACKUP ID       BACKUP TIME               BACKUP SIZE   WAL(s) SIZE   WAL FILES   STATUS  
                                                                                                             
 dell_datacenter   1653019795177   2022-05-20 09:40:57 IST   461.60 MB     0.00 bytes    0           active  
                                                                                                             
-bash-4.2$ 


======================================INCREMENTAL BACKUP WITH PGBACKREST


[root@localhost ~]# yum install pgbackrest

[root@localhost ~]# mkdir /etc/pgbackrest/

[root@localhost ~]# chown postgres:postgres /etc/pgbackrest -R
[root@localhost ~]# 
[root@localhost ~]# chown postgres:postgres /usr/bin/pgbackrest -R
[root@localhost ~]# 
[root@localhost ~]# chown postgres:postgres /var/lib/pgbackrest/ -R
[root@localhost ~]# 
[root@localhost ~]# chown postgres:postgres /var/log/pgbackrest/ -R
[root@localhost ~]# 
[root@localhost ~]# vi /etc/pgbackrest/pgbackrest.conf 


[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2

[pg0app]
pg1-path=/opt/postgres/proddata
pg1-port=5001
pg1-user=postgres



:wq

[root@localhost ~]# su - postgres
Last login: Fri May 20 10:22:36 IST 2022 on pts/2

======================================================
-bash-4.2$ mkdir proddata
-bash-4.2$ 
-bash-4.2$ /usr/pgsql-12/bin/initdb -D proddata/

-bash-4.2$ cd proddata/
-bash-4.2$ 
-bash-4.2$ vi postgresql.conf 

listen_addresses = '*'
port = 5001 
archive_mode = on 
archive_command = 'pgbackrest --stanza=pg0app archive-push %p'

:WQ

-bash-4.2$ pg_ctl -D ../proddata/ start
-bash-4.2$ 
-bash-4.2$ psql -p 5001
psql (12.11)
Type "help" for help.

postgres=# show archive_mode ;
 archive_mode 
--------------
 on
(1 row)

postgres=# show archive_command ;
              archive_command               
--------------------------------------------
 pgbackrest --stanza=pg0app archive-push %p
(1 row)

postgres=# 

======================================================

-bash-4.2$ 
-bash-4.2$ pgbackrest stanza-create --stanza=pg0app --log-level-console=info


===========================

-bash-4.2$ psql -p 5001
psql (12.11)
Type "help" for help.

postgres=# \dt
Did not find any relations.
postgres=# 
postgres=# create table tbl1 as select * from pg_class;
SELECT 395
postgres=# 
postgres=# create table tbl2 as select * from pg_class,pg_description limit 100000;
SELECT 100000
postgres=# 
postgres=# create table tbl3 as select * from pg_class,pg_description limit 500000;
SELECT 500000
postgres=# 
postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | tbl1 | table | postgres
 public | tbl2 | table | postgres
 public | tbl3 | table | postgres
(3 rows)


=================================

-bash-4.2$ pgbackrest backup --stanza=pg0app --log-level-console=info
=============================

postgres=# create table tbl4 as select * from pg_class,pg_description limit 100000;
SELECT 100000
postgres=# 
========================
-bash-4.2$ pgbackrest backup --type=incr --stanza=pg0app --log-level-console=info




=====================DOWNLOAD

sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm 

sudo yum -y install postgresql12-server postgresql12-contrib pgbackrest


====================================================

==============================MAJOR VERSION UPGRADE

[root@localhost ~]# su - postgres
Last login: Thu Dec  2 14:44:40 IST 2021 on pts/2
-bash-4.2$ 
-bash-4.2$ pwd
/opt/postgres
-bash-4.2$ 
-bash-4.2$ mkdir data11
-bash-4.2$ 
-bash-4.2$ mkdir data12
-bash-4.2$ 
-bash-4.2$ /usr/pgsql-11/bin/initdb -D /opt/postgres/data11/

-bash-4.2$ /usr/pgsql-12/bin/initdb -D /opt/postgres/data12/

-bash-4.2$ /usr/pgsql-11/bin/pg_ctl -D /opt/postgres/data11/ start

-bash-4.2$ /usr/pgsql-11/bin/psql -p 5432
psql (11.14)
Type "help" for help.

postgres=# select version();
                                                 version                                                  
----------------------------------------------------------------------------------------------------------
 PostgreSQL 11.14 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44), 64-bit
(1 row)

postgres=# show data_directory;
    data_directory    
----------------------
 /opt/postgres/data11
(1 row)

postgres=# create table tbl11 as select * from pg_Class;
SELECT 342

postgres=# create database db11;
CREATE DATABASE
postgres=# 
postgres=# create database user11;
CREATE DATABASE
postgres=# 
postgres=# 


postgres=# \q
-bash-4.2$ 
-bash-4.2$ /usr/pgsql-11/bin/pg_ctl -D /opt/postgres/data11/ stop
waiting for server to shut down.... done
server stopped
-bash-4.2$ 
-bash-4.2$ /usr/pgsql-12/bin/pg_upgrade -d /opt/postgres/data11/ -D /opt/postgres/data12/ -b /usr/pgsql-11/bin/ -B /usr/pgsql-12/bin/


-bash-4.2$ /usr/pgsql-12/bin/pg_ctl -D /opt/postgres/data12/ start


-bash-4.2$ psql --version
psql (PostgreSQL) 12.9
-bash-4.2$ 
-bash-4.2$ psql -p 5432
psql (12.9)
Type "help" for help.

postgres=# select version();
                                                 version                                                 
---------------------------------------------------------------------------------------------------------
 PostgreSQL 12.9 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44), 64-bit
(1 row)

postgres=# \dt
         List of relations
 Schema | Name  | Type  |  Owner   
--------+-------+-------+----------
 public | tbl11 | table | postgres
(1 row)

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 db11      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | postgres=CTc/postgres+
           |          |          |             |             | =c/postgres
 user11    | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
(5 rows)

===================================


