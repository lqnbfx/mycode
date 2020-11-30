#!/bin/bash
#author liqn

. /etc/profile
. ~/.bashrc

time=_`date +%Y%m%d_%H%M%S`

#需要备份的数据库名称
dbname=dhg
#备份文件放置的目录
backupdir=/usr/local/dbbak/mysql
#备份软件mysqldump的路径
mysqlcmd=/usr/local/mysql/bin/mysqldump
#备份文件保留的天数
days=7


#备份及压缩数据脚本
$mysqlcmd --default-character-set=utf8mb4  $dbname | gzip > $backupdir/$dbname$time.sql.gz


#备份到异机，异机需要对mysql服务器配置ssh信任，user需要在对应路径上有可写权限

#scp  $backupdir/$dbname$time.sql.gz  root@192.168.0.40:/usr/local/dbbak/mysql

#删除旧备份
find $backupdir -name "*.sql.gz" -type f -mtime +$days -exec rm -rf {} \; > /dev/null 2>&1