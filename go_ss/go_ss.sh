#!/bin/bash
#安装ss
#从设置好的文件中读取配置信息，生成“ssr://”的代码
#进行base64加密后，保存为“oh.txt”，存至ifheart.tk的home目录

#记得把 ssr_install 里，git clone 命令前的井号删掉
#天下文章一大抄，这个脚本的部分代码参考了ssrmu.sh

version='0.3.4'
#定义程序文件夹位置
#ssr_root=~/OneDrive/Codes/github/tests/go_ss   #windows
ssr_root=~
#web_root=~/OneDrive/Codes/github/tests/go_ss/home  #windows
web_root="/home/ss"
nginx_root="/etc/nginx"
doname="ifheart.tk"

ssr_folder="${ssr_root}/shadowsocksr"


#直接从控制台调用某个函数
test_function(){
    echo "输入函数名："
    read test_function_command
    ${test_function_command}
}

#获取用户信息
get_user_info(){
    cd "${ssr_folder}"
    user_info=$(python mujson_mgr.py -l)
    user_info_num=$(echo "${user_info}"|wc -l)
    #wc：计算文件的字节数(-c)、行数(-l)、字数(-w)
    if [ "${#}" != 0 ]; then
        if [ ${1} == 'show' ]; then
            echo "${user_info}"
        fi
    fi
}



say_hi(){
    a="hello"   #等号前后不能有空格
    b="world!"
    echo "${a}$b"
}

get_ip(){
    ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
    if [ -z ${ip} ]; then
        ip='127.0.0.1'
    fi
    if [ ${#} != 0 ]; then
        if [ ${1} == 'show' ]; then
            echo 本机IP地址为: ${ip}
        fi
    fi
    
}

Environment_install(){
    apt-get update
    apt-get install python-pip
    apt-get install git
}

ssr_install(){
    cd ${ssr_root}
    if [ ! -d "shadowsocksr" ]; then
        echo "shadowsocksr folder not found, begin clone from github"
        git clone -b manyuser https://github.com/coolwrx/shadowsocksr.git
    else
        echo "shadowsocksr folder found"
    fi

    cd "${ssr_folder}"
    bash initcfg.sh
    sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" "userapiconfig.py"
    get_ip  #先有鸡还是先有蛋？
    sed -i "s/SERVER_PUB_ADDR = '127.0.0.1'/SERVER_PUB_ADDR = '${ip}'/" "userapiconfig.py"
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
    get_user_info
    echo "正在自动添加用户..."
    name_check "auto_add"
    if [ $? == 0 ]; then
        python mujson_mgr.py -a -u auto_add -p 28593 -k abcd1234 -m aes-128-ctr -O auth_aes128_md5 -o plain
    else
        echo "auto_add 已存在"
    fi
    echo "自动添加用户完成，启动服务..."
    ./logrun.sh
    echo "启动成功"

    #输入用户名后调用查重函数
    #应该把查重和配置写到一个函数里，add_user只做交互，否则add_user函数会很长
    while true
    do
        echo "设置用户名："
        read new_name
        name_check "${new_name}"
        if [ $? == 0 ]; then
            break
        else
            echo "用户名重复，请重试"
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

        #show_sslink "${new_name}"
}


#用户名查重函数
#用name_check   有重复返回1，无重复返回0
name_check(){
    #echo 'Flag name_check'
    for ((i=1; i<="${user_info_num}"; i++))
    do
        jiakuang=$(echo "[${1}]")   #字面意思，加个括号
        if [ "${jiakuang}" == "$(echo "${user_info}"|sed -n "${i}p"|awk '{print $2}')" ]; then
            return 1
            break
        fi
    done
    return 0
}
#not used
name_same(){
    echo "name_same"
    if [ ${new_name} == "flag" ]; then
        name_check="ok"
    else
        name_check="no"
    fi
}

show_sslink(){
    get_ip
    if [ ${#} == 0 ]; then
        echo "No input, use 'auto_add'"
        sslink_user="auto_add"
    else
        sslink_user="${1}"
        echo "Use ${sslink_name}"
    fi

    cd "${ssr_folder}"
    sslink_user_info=$(python mujson_mgr.py -l -u ${sslink_user})
    #echo "${sslink_user_info}"
    sslink_port=$(echo "${sslink_user_info}"|sed -n "3p"|awk '{print $3}')
    sslink_method=$(echo "${sslink_user_info}"|sed -n "4p"|awk '{print $3}')
    sslink_passwd=$(echo "${sslink_user_info}"|sed -n "5p"|awk '{print $3}')
    sslink_passwd_64=$(echo "${sslink_passwd}" | base64)
    sslink_protocol=$(echo "${sslink_user_info}"|sed -n "6p"|awk '{print $3}')
    sslink_obfs=$(echo "${sslink_user_info}"|sed -n "7p"|awk '{print $3}')
    sslink=$(echo "ssr://${ip}:${sslink_port}:${sslink_protocol}:${sslink_method}:${sslink_obfs}:${sslink_passwd_64}/?obfsparam=&protoparam=&remarks=TEE&group=aWZoZWFydA")
    #echo "${sslink}"
    web_sslink=$(echo ${sslink} | base64)

    if [ ! -d "${web_root}" ]; then
        mkdir "${web_root}"
    fi
    cd "${web_root}"
    #不能用echo，会自动换行
    #双引号会影响输出结果
    #echo "${web_sslink}" > oh.txt 超过76个字符就会自动换行
    #echo ${web_sslink} > oh.txt 超过76个字符就会自动加空格
    #echo "${web_sslink}"
    printf "%s" ${web_sslink} > oh.txt
    echo "" >> oh.txt
}

ssr_subscribe(){
    echo "Install nginx?(y/n)"
    read install_nginx
    if [ "${install_nginx}" = 'y' ]; then
        apt-get install nginx
    fi

    cd "${nginx_root}/sites-enabled"
    if [ ! -f "ss_nginx" ]; then
        wget "https://raw.githubusercontent.com/coolwrx/tests/master/go_ss/ss_nginx"
    else
        echo 'ss_nginx found, rm it...'
        rm "ss_nginx"
        wget "https://raw.githubusercontent.com/coolwrx/tests/master/go_ss/ss_nginx"
    fi


    cd "${ssr_folder}"
    get_user_info
    if [ ${user_info_num} > 0 ]; then
        echo "${user_info}"
        echo -n "choose a user: "
        while true
        do
            read input
            if [ "${input}" = 'y' ]; then
                echo 'exit'
                break
            fi
            name_check "${input}"
            if [ $? == 0 ]; then
                echo -e "User not found, exit?(y/another name)"
            elif [ $? == 1 ]; then
                echo "User ${input} found"
                show_sslink "${input}"  #写入到网站根目录
                break
            fi
        done
    else
        echo -n "No user found, set one?(y/n)"
        read input
        if [ "${input}" = 'y' ]; then
            add_user
        fi
    fi

}

help(){
    echo 'help manu'
}














#begin main
echo "go_ss v${version} Shadowsocksr manyuser (debain only)
------options------
0.test_function
1.say_hi
2.get_ip
3.Environment install
4.ssr_install
5.ssr_subscribe
-------other-------
Enter "help" to get help
"

echo "choose a option: "
read command
case $command in
    0) test_function
    ;;
    1) say_hi
    ;;
    2) get_ip "show"
    ;;
    3) Environment_install
    ;;
    4) ssr_install
    ;;
    5) ssr_subscribe
    ;;
    "help") help
    ;;
    *) echo 'fuck you'
    ;;
esac