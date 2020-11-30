#!/usr/bin/env bash
#author liqn

## mysql版本mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz自动安装脚本,脚本同mysql安装文件，配置文件my.cnf需放置到同一路径下

##根据安装规划修改相关配置

shell_path=$(cd `dirname $0`;pwd)
btime=$(date +%Y%m%d-%H%M%S)
#mysql安装文件名称
mysql_srcfile=mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz


#mysql安装路径
mysql_path=/usr/local/mysql
#mysql_root密码
mysql_root_password=DongBaoSoft
#mysql服务端口
mysql_port=3306
mysqlx_port=33060


##监测是否存在mysql，端口是否占用
#pass


##部署安装
if [ ! -f $shell_path/$mysql_srcfile ] || [ ! -f $shell_path/my.cnf ] ;then
 echo -e "\033[42;35m Please check if the $shell_path/$mysql_srcfile or $shell_path/my.cnf exists，setup exit!!! \033[0m"
 exit 0
fi


if [ ! -d $mysql_path ];then
mkdir $mysql_path && tar  -xvf  $shell_path/$mysql_srcfile  -C  $mysql_path  --strip-components 1
cd $mysql_path  && mkdir data  logs
else
  echo -e  "\033[42;35m MySQL folder ${mysql_path} already exists,please check，setup exit!!! \033[0m"
  exit 0
fi





#复制mysql的配置文件到/etc/下
if [ -f "/etc/my.cnf" ];then
  echo "Backup the mysql default configuration file"
  mv /etc/my.cnf /etc/mydhg.cnf.${btime}
fi

cp ${shell_path}/my.cnf  /etc/

#修改/etc/my.cnf相关配置
if [ $mysql_path != /usr/local/mysql ];then
 sed -i "s#/usr/local/mysql#$mysql_path#g"  /etc/my.cnf
fi

if [ $mysql_port != 3306 ];then
 sed -i "s#port=3306#port=$mysql_port#g"  /etc/my.cnf
fi

if [ $mysqlx_port != 33060 ];then
 sed -i "s#mysqlx_port=33060#mysqlx_port=t=$mysqlx_port#g"  /etc/my.cnf
fi


#创建用户初始化数据库
id mysql >& /dev/null
if [ $? -ne 0 ];then
useradd -s /sbin/nologin -M  mysql
fi
chown -R mysql:mysql $mysql_path

ln -sf  ${mysql_path}/bin/mysql    /usr/local/bin/mysql
$mysql_path/bin/mysqld  --initialize --user=mysql

if [  -f "/etc/inid.d/mysqld" ];then
  echo -e "\033[42;35m  mysqld file already exist,backup the old /etc/init.d/mysqld file \033[0m"
  mv  /etc/init.d/mysqld   /etc/init.d/mysqld_${btime}
fi
cp $mysql_path/support-files/mysql.server   /etc/init.d/mysqld
sed  -i   "s#^basedir=#basedir=${mysql_path}#"        /etc/init.d/mysqld
sed  -i   "s#^datadir=#datadir=${mysql_path}/data#"   /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld

/etc/init.d/mysqld start

#获取mysql临时密码
tmppasswd=`grep "A temporary password"  ${mysql_path}/logs/error.log  | awk  '{print $NF}'`
$mysql_path/bin/mysql --connect-expired-password -uroot   -p${tmppasswd}   -e  "set password='${mysql_root_password}'"

echo 'End of installation,Please check whether MySQL runs normally.'

