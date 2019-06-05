#!/bin/bash
#安装ss
#从设置好的文件中读取配置信息，生成“ssr://”的代码
#进行base64加密后，保存为“oh.txt”，存至ifheart.tk的home目录

a="hello"   #等号前后不能有空格
b="world!"
echo "${a}$b"

ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
echo 本机IP地址为: $ip

Environment_install(){
    apt-get update
    apt-get install python-pip
    apt-get install git
}


git clone -b manyuser https://github.com/coolwrx/shadowsocksr.git