#!/bin/bash
#安装ss
#从设置好的文件中读取配置信息，生成“ssr://”的代码
#进行base64加密后，保存为“oh.txt”，存至ss.ifheart.tk的home目录

#记得把 ssr_install 里，git clone 命令前的井号删掉
#天下文章一大抄，这个脚本的部分代码参考了ssrmu.sh

version='0.5.8.2'
#定义程序文件夹位置，仅本地测试用
#ssr_root=~/OneDrive/Codes/github/tests/go_ss   #windows
#web_root=~/OneDrive/Codes/github/tests/go_ss/home  #windows

ssr_root=~
web_root="/home/ss"
nginx_root="/etc/nginx"
doname="ss.ifheart.tk"
sslink_group="ifheart"

ssr_folder="${ssr_root}/shadowsocksr"

RED_COLOR='\E[1;31m'  
YELOW_COLOR='\E[1;33m' 
BLUE_COLOR='\E[1;34m'  
GREEN_COLOR="\033[32m"
RESET='\E[0m'

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

#显示函数，参数1为要显示的文本内容，参数2是颜色（默认r）
#颜色：r, g, b, y
display_color(){
    display_text=${1}
    display_text_color=${2}
    
    if [ "${#}" != 0 ]; then
        #if [ "${#}" = 1]; then
        #    display_text_color="${RED_COLOR}"
        #fi

        case "${display_text_color}" in
        'r')
        display_text_color="${RED_COLOR}"
        ;;
        'g')
        display_text_color="${GREEN_COLOR}"
        ;;
        'y')
        display_text_color="${YELOW_COLOR}"
        ;;
        'b')
        display_text_color="${BLUE_COLOR}"
        ;;
        *)
        display_text_color="${RED_COLOR}"
        esac
    fi

    echo -e "${display_text_color}${display_text}${RESET}"

}

say_hi(){
    get_ip
    get_city
    a="hello"   #等号前后不能有空格
    b="world!"
    echo "${a}$b"
    echo "${ip} from ${city}"
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

get_city(){
        city=$(wget -qO- -t1 -T2 ipinfo.io/city)
        region=$(wget -qO- -t1 -T2 ipinfo.io/region)
    if [ -z "${city}" ]; then
        city='找不到'
    fi
    if [ ${#} != 0 ]; then
        if [ ${1} == 'show' ]; then
            echo ip地址对应的地点为: ${city} / ${region}
        fi
    fi
}

#通用询问函数，要求用户输入y/n，返回1为y
#默认为否，返回0
#参数1，要显示的交互文字；参数2，文字颜色
ask(){
    ask_words=${1}
    ask_color='g'
    if [ ${#} == '2' ]; then
    ask_color=${2}
    fi
    display_color "${ask_words} (y/n)" ${ask_color}
    read ask_input
    if [ "${ask_input}" == 'y' ]; then
        return 1
    else
        return 0
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
        python mujson_mgr.py -a -u auto_add -p 30138 -k cptbtptp -m aes-256-ctr -O auth_chain_a -o tls1.2_ticket_auth
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
        1 origin
        2 auth_sha1_v4
        3 auth_aes128_md5
        4 auth_aes128_sha1
        5 auth_chain_a
        6 auth_chain_b"
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
    get_city

    if [ ${#} == 0 ]; then
        display_color "No input, use 'auto_add'"
        sslink_user="auto_add"
    else
        sslink_user="${1}"
        #这里应该加一个名称确认
        display_color "Show_sslink ${sslink_user}"
    fi

####所有base64加密的单个参数，都要去掉末尾的=号####

    cd "${ssr_folder}"
    sslink_user_info=$(python mujson_mgr.py -l -u ${sslink_user})
    #echo "${sslink_user_info}"
    sslink_port=$(echo "${sslink_user_info}"|sed -n "3p"|awk '{print $3}')
    sslink_method=$(echo "${sslink_user_info}"|sed -n "4p"|awk '{print $3}')
    sslink_passwd=$(echo "${sslink_user_info}"|sed -n "5p"|awk '{print $3}')
    sslink_passwd_64=$(echo "${sslink_passwd}"|base64)
    sslink_passwd_64=${sslink_passwd_64%%=*}
    sslink_protocol=$(echo "${sslink_user_info}"|sed -n "6p"|awk '{print $3}')
    sslink_obfs=$(echo "${sslink_user_info}"|sed -n "7p"|awk '{print $3}')

    sslink_group_64=$(echo -n ${sslink_group}|base64)
    sslink_group_64=${sslink_group_64%%=*}   #删除末尾的等于号
    sslink_remarks_64=$(echo -n ${region} ${sslink_port}|base64)
    sslink_remarks_64=${sslink_remarks_64%%=*}

    sslink_raw=$(echo "${ip}:${sslink_port}:${sslink_protocol}:${sslink_method}:${sslink_obfs}:${sslink_passwd_64}/?remarks=${sslink_remarks_64}&group=${sslink_group_64}")
    sslink_raw_doname=$(echo "${doname}:${sslink_port}:${sslink_protocol}:${sslink_method}:${sslink_obfs}:${sslink_passwd_64}/?remarks=${sslink_remarks_64}&group=${sslink_group_64}")
        #群组名ifheart，节点名称LA，没加自定义功能
        #要改!
    #改好了！
    ask "Write subscribe with ip(y)/domain(n)?"
    if [ $? == 0 ]; then
        sslink_raw_64=$(echo -n ${sslink_raw_doname}|base64)  #echo -n 表示不换行输出
    elif [ $? == 1 ]; then
        sslink_raw_64=$(echo -n ${sslink_raw}|base64)
    fi
    sslink="ssr://${sslink_raw_64}"
    web_sslink=$(printf "%s" ${sslink}|base64)

    #不能用echo，会自动换行
    #双引号会影响输出结果
    #echo "${web_sslink}" > oh.txt 超过76个字符就会自动换行
    #echo ${web_sslink} > oh.txt 超过76个字符就会自动加空格
    #echo "${web_sslink}"

    #功能隔离，写文件的语句放到ssr_subscribe里，用全局变量传递信息
}

ssr_subscribe(){
    display_color "Install nginx?(y/n)"
    read install_nginx
    if [ "${install_nginx}" = 'y' ]; then
        apt-get install nginx
    fi

    cd "${nginx_root}/sites-enabled"
    if [ ! -f "ss_nginx" ]; then
        display_color "download ss_nginx"
        wget "https://raw.githubusercontent.com/coolwrx/tests/master/go_ss/ss_nginx"
    else
        display_color 'ss_nginx found, update...'
        rm "ss_nginx"
        wget "https://raw.githubusercontent.com/coolwrx/tests/master/go_ss/ss_nginx"
    fi

    /etc/init.d/nginx restart

    cd "${ssr_folder}"
    get_user_info
    if [ ${user_info_num} > 0 ]; then
        display_color "${user_info}"
        display_color "choose a user, no input for all: " g
        while true
        do
            read input


            #用户输入空，写入所有
            if [ "${input}" = '' ]; then
                display_color 'Write all users'

                cd "${ssr_root}"
                
                for ((i=1; i<="${user_info_num}"; i++))
                do
                    name=$(echo "${user_info}"|sed -n "${i}p"|awk '{print $2}')
                    name=${name#[}  #删除从左往右的第一个[号
                    name=${name%]}  #删除从右往左的第一个]号
                    #如果要以某个符号为标记删除某侧的所有字符，则加上*号

                    show_sslink "${name}"
                    #sslink=${sslink%%=}
                    printf "%s" ${sslink} >> sslink.all
                    #如果上一行sslink左右加了引号，就会自动换行，不知道为什么
                    printf "\n" >> sslink.all
                done

                web_sslink_all=$(cat sslink.all|base64)

                rm sslink.all

                if [ ! -d "${web_root}" ]; then
                    mkdir "${web_root}"
                fi
                cd "${web_root}"
                
                printf "%s" ${web_sslink_all} > oh.txt

                break
            fi

            name_check "${input}"   #检查用户名是否存在
            if [ $? == 0 ]; then
                echo -e "User not found, exit?(y/another name)"
            elif [ $? == 1 ]; then
                display_color "User ${input} found" g
                show_sslink "${input}"

                #写入到网站根目录
                if [ ! -d "${web_root}" ]; then
                    mkdir "${web_root}"
                fi
                cd "${web_root}"

                printf "%s" ${web_sslink} > oh.txt
                echo "" >> oh.txt   #加一个换行

                break
            fi



        done
    else
        #一个用户都没有找到，不是输入的用户没有匹配
        ask "No user found, set one?"
        if [ $? = 1 ]; then
            add_user
        fi
    fi

}

update(){
    rm go_ss.sh
    wget https://raw.githubusercontent.com/coolwrx/tests/master/go_ss/go_ss.sh && chmod +x go_ss.sh && bash go_ss.sh
}


help(){
    echo 'help menu
    没有帮助，暂时没有，嘻嘻'
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
a.update script
Enter "help" to get help
"
display_color "choose a option: " g

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
    a) update
    ;;
    "help") help
    ;;
    *) echo 'glz好好说话'
    ;;
esac
