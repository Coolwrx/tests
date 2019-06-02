# tests
天下文章一大抄
## Padavan 相关
padavan 除系统的关键目录以外其他的目录均为 tmpfs ，这和 RamDisk 很像，都是把数据暂存在内存上，所以在大多数目录里所做的修改在没有执行保存脚本之前并没有真正的写入 Rom 里，如果没有保存重启之后数据便会丢失了。  
执行 `mtd_storage.sh save` 来保存更改  
>https://blog.aofall.com/archives/13.html

## git push 测试
看到这行应该就是成了  
先放几个链接
>https://www.runoob.com/manual/git-guide/  
>https://www.runoob.com/w3cnote/git-guide.html

## vs code 连接到 GitHub
### 安装 git
>https://www.git-scm.com/download/
一路 yes，装就完事了

### vs code 配置
Ctrl + shift + `，调出终端  
cd 到想要部署的目录  
````
    git init
    
````