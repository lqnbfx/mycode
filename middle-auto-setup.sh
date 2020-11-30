#!/usr/bin/env bash
#author liqn

## 软件jdk1.8_121.tar.gz，redis-4.0.1.tar.gz，Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz和自动安装脚本middle-auto-setup.sh需放置到同一路径下

shell_path=$(cd `dirname $0`;pwd)
btime=$(date +%Y%m%d-%H%M%S)

#--jdk相关配置--

#jdk安装文件名称
jdk_srcfile=jdk1.8_121.tar.gz
#jdk安装路径
jdk_path=/usr/local/jdk1.8

#--redis相关配置--

#redis安装文件名称
redis_srcfile=redis-4.0.1.tar.gz
#jdk安装路径
redis_path=/usr/local/redis4.0.1
#redis绑定IP地址
redis_bindip=0.0.0.0
#redis端口
redis_port=6379
#redis密码
redis_pass=DongBaoSoft
#redis最大可用内存,默认0不限制，列如1GB可以写为1024M，1G
redis_memory=0

#--OpenOffice相关配置--
openoffice_srcfile=Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_zh-CN.tar.gz
openoffice_port=8100






cat << EOF
_____________________________________________
|******Please  Enter Your Choice:[0-4]******|
 
 (1) install  JDK  
 (2) install  Redis-Server
 (3) install  OpenOffice
 (0) Quit
____________________________________________
EOF

read -p "Please  enter your choice[0-3]:" input
case $input  in


1)

echo    "start  install  JDK"

##部署安装
if [ ! -f $shell_path/$jdk_srcfile ];then
 echo -e "\033[42;35m  $shell_path/$jdk_srcfile not exists,please check，setup exit!!! \033[0m"
 exit 0
fi

if [ ! -d $jdk_path ];then
 mkdir $jdk_path && tar  -zxvf  $shell_path/$jdk_srcfile  -C  $jdk_path  --strip-components 1
else
  echo -e  "\033[42;35m jdk folder $jdk_path already exists,please check，setup exit!!! \033[0m"
  exit 0
fi

#修改环境变量
echo  "export JAVA_HOME=${jdk_path}"  >>  /etc/profile
echo  "export PATH=\$JAVA_HOME/bin:\$PATH"  >>  /etc/profile
echo  "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar"  >>  /etc/profile

source  /etc/profile
echo `java -version`
echo -e "jdk installation complete,Execute the following command to confirm: \033[42;35m source /etc/profile;java -version\033[0m "

;;


2)

echo    "start  install  Redis-Server"

##部署安装
if [ ! -f $shell_path/$redis_srcfile ];then
 echo -e "\033[42;35m  $shell_path/$redis_srcfile not exists,please check，setup exit!!! \033[0m"
 exit 0
fi

if [ ! -d $redis_path ];then
 if [ -d $shell_path/redis-4.0.1 ];then
 rm -rf $shell_path/redis-4.0.1
 fi
tar -zxvf $shell_path/$redis_srcfile && cd  $shell_path/redis-4.0.1
make  PREFIX=$redis_path  install
else
  echo -e  "\033[42;35m redis folder $redis_path already exists,please check，setup exit!!! \033[0m"
  exit 0
fi

#拷贝配置好文件到redis目录
cp  $shell_path/redis-4.0.1/redis.conf  $redis_path/bin/

#修改redis相关配置
sed  -i  "s/^bind.*/bind $redis_bindip/"   $redis_path/bin/redis.conf
sed  -i  "s#^pidfile.*#pidfile $redis_path/redis.pid#"   $redis_path/bin/redis.conf
sed  -i  "501i  requirepass $redis_pass"   $redis_path/bin/redis.conf
sed  -i  "s/^daemonize.*/daemonize yes/"   $redis_path/bin/redis.conf


if [ $redis_port != 6379 ];then
 sed  -i  "s/^port.*/port $redis_port/"   $redis_path/bin/redis.conf
fi

if [ $redis_memory != 0 ];then
 sed  -i  "562i maxmemory $redis_memory"   $redis_path/bin/redis.conf
fi

#创建redis启动脚本
if [  -f /etc/init.d/redis ];then
 echo "Backup the /etc/init.d/redis configuration file"
 mv /etc/init.d/redis /etc/init.d/redis.${btime}
fi 
 
cat << EOF > /etc/init.d/redis
#!/bin/sh
# chkconfig:   2345 90 10
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

#redis服务器监听的端口，根据具体情况修改
REDISPORT=$redis_port
#服务端所处位置
EXEC=$redis_path/bin/redis-server
#客户端位置
CLIEXEC=$redis_path/bin/redis-cli
#redis的PID文件位置，根据具体情况修改
PIDFILE=$redis_path/redis.pid
#redis的配置文件位置，根据具体情况修改
CONF=$redis_path/bin/redis.conf
#redis的密码，根据具体情况修改
REDIS_PWD=$redis_pass
#redis接受请求地址，根据具体情况修改
REDIS_HOST=127.0.0.1
EOF

cat << 'EOF' >> /etc/init.d/redis

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
		sleep 1
		ps -ef|grep $REDISPORT |grep -v grep | grep -v PID | awk '{print $2}'
		if [ $? -eq 0 ]
		    then
		    echo "Redis Started"
		fi
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -h $REDIS_HOST -p $REDISPORT -a $REDIS_PWD shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
EOF

chmod +x /etc/init.d/redis

#启动redis
$redis_path/bin/redis-server  $redis_path/bin/redis.conf

;;

3)
echo  "start install  OpenOffice"

#部署安装
if [ ! -f $shell_path/$openoffice_srcfile ];then
 echo -e "\033[42;35m  $shell_path/$openoffice_srcfile not exists,please check，setup exit!!! \033[0m"
 exit 0
fi

tar  -zxvf $shell_path/$openoffice_srcfile && cd $shell_path/zh-CN/RPMS && rpm  -ivh  *.rpm && cd desktop-integration && rpm -ivh openoffice4.1.6-redhat-menus-4.1.6-9790.noarch.rpm

#插入开机自启动
if ! grep "/opt/openoffice4/program/soffice -headless -accept=\"socket,host=127.0.0.1,port=$openoffice_port;urp;\" -nofirststartwizard &" /etc/rc.d/rc.local;then
echo  "/opt/openoffice4/program/soffice -headless -accept=\"socket,host=127.0.0.1,port=$openoffice_port;urp;\" -nofirststartwizard &" >>  /etc/rc.d/rc.local
fi
echo  "/opt/openoffice4/program/soffice -headless -accept=\"socket,host=127.0.0.1,port=$openoffice_port;urp;\" -nofirststartwizard &" >  /opt/openoffice4/program/start.sh
chmod +x  /opt/openoffice4/program/start.sh

#启动服务

sh /opt/openoffice4/program/start.sh


;;

0)
exit 0

;;

*)

echo "please input {0|1|2|3}"

esac