# tests
天下文章一大抄  
markdown 语法里，转义字符的标记是 '\\'，反斜杠  
## Padavan 相关
padavan 除系统的关键目录以外其他的目录均为 tmpfs ，这和 RamDisk 很像，都是把数据暂存在内存上，所以在大多数目录里所做的修改在没有执行保存脚本之前并没有真正的写入 Rom 里，如果没有保存重启之后数据便会丢失了。  
执行 `mtd_storage.sh save` 来保存更改  
>https://blog.aofall.com/archives/13.html

## git push 测试
看到这行应该就是成了  
先放几个链接
>https://www.runoob.com/manual/git-guide/  
>https://www.runoob.com/w3cnote/git-guide.html

## vs code 连接 GitHub
### 安装 git
>https://www.git-scm.com/download/

一路 yes，装就完事了

### GitHub配置
快捷键 “Ctrl + shift + \` ”，调出终端  
GitHub 与客户端之间以 ssh 通信，需要先在本地生成一对密钥  
在终端执行命令 `ssh-keygen -t rsa -C"example@example.com"`，最后的邮件地址好像可以随便写  
完成以后，会在用户目录下的 `.ssh` 文件夹中生成一对公私钥，用记事本打开 `rsa.pub`，复制公钥内容，添加到 GitHub 账号中  

### vs code 配置

cd 到想要部署本地仓库的目录

    git config --global user.name example   #设置用于提交更改的户名
    git config --global user.mail example   #设置用于提交更改的邮件地址
    #上面两个设置仅用于标识，不一定要是 GitHub 账号的名字和邮件地址

    git initd   #初始化当前目录，会新建一个 .git 的隐藏文件夹
    git remote add origin git@github.com:github用户名/项目名    #连接到 GitHub 的对应项目上
