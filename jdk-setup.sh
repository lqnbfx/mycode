#!/usr/bin/env bash

## jdk版本jdk1.8_121.tar.gz自动安装脚本,脚本jdk安装文件需放置到同一路径下


##根据安装规划修改相关配置

shell_path=$(cd `dirname $0`;pwd)


#jdk安装文件名称
jdk_srcfile=jdk1.8_121.tar.gz
#jdk安装路径
jdk_path=/usr/local/jkd1.8


##部署安装
if [ ! -d $jdk_path ];then
 mkdir $jdk_path && tar  -zxvf  $shell_path/$jdk_srcfile  -C  $jdk_path  --strip-components 1
else
  echo -e  "\033[42;35m jdk folder already exists,please check，setup exit!!! \033[0m"
  exit
fi

#修改环境变量
echo  "export JAVA_HOME=${jdk_path}"  >>  /etc/profile
echo  "export PATH=\$JAVA_HOME/bin:\$PATH"  >>  /etc/profile
echo  "export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar"  >>  /etc/profile

source  /etc/profile

echo -e "jdk installation complete,Execute the following command to confirm: \033[42;35m source /etc/profile;java -version\033[0m "

echo `java -version`