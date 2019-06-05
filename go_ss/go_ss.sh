#!/bin/bash
#安装ss
#从设置好的文件中读取配置信息，生成“ssr://”的代码
#进行base64加密后，保存为“oh.txt”，存至ifheart.tk的home目录

#记得把 ssr_install 里，git clone 命令前的井号删掉

version='0.1'
ssr_folder="/root/shadowsocksr"


say_hi(){
    a="hello"   #等号前后不能有空格
    b="world!"
    echo "${a}$b"
}

get_ip(){
    ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
    echo 本机IP地址为: $ip
}

Environment_install(){
    apt-get update
    apt-get install python-pip
    apt-get install git
}

ssr_install(){
    cd "/root/shadowsocksr"
    if [ ! -d "/shadowsocksr" ]; then
        echo "shadowsocksr folder not found, begin clone from github"
        git clone -b manyuser https://github.com/coolwrx/shadowsocksr.git
    else
        echo "shadowsocksr folder found"
    fi

    bash initcfg.sh
    sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" "userapiconfig.py"
    sed "s/SERVER_PUB_ADDR = '127.0.0.1'/SERVER_PUB_ADDR = '${ip}'/" "userapiconfig.py"
    #sed的i参数可以用来修改文件内容，好像不写这个参数是不会改的，引号里的格式是 "s/原文/更改后/"，文件名写最后
    echo "配置完成，是否开始添加用户？y/n: "
    read addnow
    case ${addnow} in
        y) 
        echo "添加用户"
        add_user
        ;;
        *) 
        echo "退出"
        exit
        ;;
    esac
}

add_user(){
    echo "正在自动添加用户..."
    python mujson_mgr.py -a -u auto_add -p 28593 -k abcd1234 -m aes-128-ctr -O auth_aes128_md5 -o plain
    echo "自动添加用户完成"
    while true
    do
        echo "设置用户名："
        read new_name
        name_same
        if [ ${name_check} == "ok" ]; then
            break
        else
            echo "重复了"
        fi
    done
        echo "端口"
        read new_port
        echo "密码"
        read new_password
        echo "加密协议
        ${Green_font_prefix}1.${Font_color_suffix} origin
        ${Green_font_prefix}2.${Font_color_suffix} auth_sha1_v4
        ${Green_font_prefix}3.${Font_color_suffix} auth_aes128_md5
        ${Green_font_prefix}4.${Font_color_suffix} auth_aes128_sha1
        ${Green_font_prefix}5.${Font_color_suffix} auth_chain_a
        ${Green_font_prefix}6.${Font_color_suffix} auth_chain_b"
        read new_method_num
        case ${new_method_num} in
            1)
            new_method="origin"
            ;;
            2)
            new_method="auth_sha1_v4"
            ;;
            3)
            new_method="auth_aes128_md5"
            ;;

            *)
            new_method="auth_aes128_md5"
            ;;
        esac
    
        echo "$new_method"

}


#用户名查重模块
name_same(){
    echo "name_same"
    if [ ${new_name} == "flag" ]; then
        name_check="ok"
    else
        name_check="no"
    fi
}

#begin main
echo "go_ss v.${version} Shadowsocksr manyuser (debain only)
------options------

1.say_hi
2.get_ip
3.Environment install
4.ssr_install
"

echo "choose a option: "
read command
case $command in
    1) say_hi
    ;;
    2) get_ip
    ;;
    3) Environment_install
    ;;
    4) ssr_install
    ;;
    *) echo 'fuck you'
    ;;
esac