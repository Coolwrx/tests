# READ ME FIRST

**工地英语，能懂就行**

Functions:
1. Show ip adress
2. Set up ss
3. Set up web server (nginx only)

## Start with

Use `wget https://raw.githubusercontent.com/coolwrx/tests/master/go_ss/go_ss.sh && chmod +x go_ss.sh && bash go_ss.sh`

`chmod +x` is a command to give an access to the shell script next it

You can also add the option `--no-check-certificate` when use HTTPS protocl, but it is not safe

## Update log

### v0.5.8

- add function "ask"
- add choose when write subscribe, domain/ip
- rebuild "ssr_subscribe"


## Function introduce
v0.3.9

### test_function
Use "read" to get function name, call it directly

### get_user_info
Use `mujson_mgr.py` to get users number and name, has one parameter(参数), incoming "show" to print(echo) user's name and port

`get_user_info show`

### display_color
Output function, has two parameter(参数). Parameter 1 is the infomation you want to print, parameter 2 can set color

r => red; g => green; b => blue; y => yellow

### say_hi
No what egg use, just say hi

### Environment_install
Install python-pip, git

### ssr_install
Clone ssr's files in ${ssr_root}.

Do some pre-work before add users

### add_user
**NOT FINISH**  
Call name_check to know whether user "auto_add" added or not, if not, will add it and run server immediately.  
检测服务到底启动成功没有的函数还没写，echo的那个启动成功就是安慰一下自己的  
`python mujson_mgr.py -a -u auto_add -p 28593 -k abcd1234 -m aes-128-ctr -O auth_aes128_md5 -o plain`

A series dead cycle to check inputs  
To set a new user, you should provide: 
+ user name
+ port
+ method
+ password
+ protocol
+ obfs (这个大概是混淆吧)

### name_check
To use this function, you should call 'get_user_info' first, cause name_check need some variables ssign(赋值？) values by 'get_user_info'

保险起见，应该把调用 get_user_info 写在 name_check 里，但是 get_user_info 要调用 python，每差一次重都要走一遍，挺慢的。目前想到的解决方案是传入一个参数，默认不调用 get_user_info，参数存在时调用一次 get_user_info

### show_sslink


