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
    #echo ${x}

    new_method=1
    new_password=2
    ip=3
    port=4

    #echo ${new_method}:${new_password}@${ip}:${port}|base64

    y=c3NyOi8vMTI3LjAuMC4xOjI4NTkzOmF1dGhfYWVzMTI4X21kNTphZXMtMTI4LWN0cjpwbGFpbjpZV0pqWkRFeU16UUsvP29iZnNwYXJhbT0mcHJvdG9wYXJhbT0mcmVtYXJrcz1URUUmZ3JvdXA9YVdab1pXRnlkQQo=
    echo ${y} | base64 -d
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

file(){
    if [ ! -f "oh.txt" ]; then
        echo "dd"
    fi
    a="sjfldkfsjfdk"
    echo $a
    #一个让函数返回字符串的方法
    #不用return，在函数里写echo，调用的时候写 echo $(function)
}
#echo $(file)
