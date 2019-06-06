call(){

    if [ ${#} != 0 ]; then
        if [ ${1} == "x" ]; then
        a='hello'
        echo ${a}
        fi
    fi

}

base64_test(){
    x=2
    echo ${x}

    new_method=1
    new_password=2
    ip=3
    port=4

    echo ${new_method}:${new_password}@${ip}:${port}|base64

    y=OTUuMTc5LjE0OC4xMDg6Mjg1OTM6YXV0aF9hZXMxMjhfbWQ1OmFlcy0xMjgtY3RyOnBsYWluOllXSmpaREV5TXpR

    echo ${y}|base64 -d
}

xcode(){
    cd "shadowsocksr"
    user_info=$(python mujson_mgr.py -l)
    #echo "${user_info}"
    i=2
    #display_test=$(echo "${user_info}"|sed -n "${i}p"|awk '{print $2}')
    display_test=$(echo "$user_info"|wc -l)
    echo "${display_test}"    
}

xxx(){
    return 0
}

xunhuan(){
    while true
    do
        echo "${one}"
        read one
        xxx
        if [ $? == 0 ]; then
            echo $?
            break
        fi
    done
}
cd "~"
ls