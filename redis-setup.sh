#!/usr/bin/env bash

## redis版本redis-4.0.1.tar.gz自动安装脚本,脚本redis安装文件需放置到同一路径下


##根据安装规划修改相关配置

shell_path=$(cd `dirname $0`;pwd)


#redis安装文件名称
redis_srcfile=redis-4.0.1.tar.gz
#redis安装路径
redis_path=/usr/local/redis4.0.1


##部署安装
yum install gcc
tar -zxvf $shell_path/$redis_srcfile && cd  $shell_path/redis-4.0.1
make  PREFIX=$redis_path  install

#拷贝配置好文件到redis目录
cp  $shell_path/redis.conf  $redis_path/bin/
