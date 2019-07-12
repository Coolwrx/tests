# 傻瓜式ssr使用教程

- [Android 客户端](#Android-客户端)
- [PC 客户端](#PC-客户端)

## Android 客户端
### 下载安装

[直接下载](https://github.com/Coolwrx/tests/raw/master/ss_how/ssr_3.4.0.6.apk)  
[备份 release](https://github.com/shadowsocksr-backup/shadowsocksr-android/releases)

安装没什么好说的，权限要啥给啥，装就完事了

### 手动导入配置

复制以 `ssr://` 开头的节点信息代码

启动客户端，点击左上角 ShadowsocksR 标志，打开配置文件界面，点击右下角 加号 “+”，选择“从剪贴板导入”
![Android-ssr-input](https://github.com/Coolwrx/tests/raw/master/ss_how/SSR-Android-1.png)

选取节点后，退回主界面，在 功能设置 / 路由 中选择**绕过局域网及中国大陆地址**，再点击右上角的 纸飞机 图标启动服务

### 添加订阅

启动客户端，点击左上角 ShadowsocksR 标志，打开配置文件界面，点击右下角 加号 “+”，选择“添加/升级 SSR 订阅”

点击“添加订阅地址”，输入订阅服务器地址，一般是一个网址（要带协议）  
如 `http://baidu.com`

选择刚才添加的订阅，点击“确定并升级”，然后祈祷奇迹发生  
[错误及排查方法](#Windows-添加订阅) 可以参考 Windows 端

## PC 客户端
### 下载

PC 版不需要安装

[直接下载](https://github.com/Coolwrx/tests/raw/master/ss_how/ShadowsocksR-4.7.0-win.7z)  
[备份 release](https://github.com/shadowsocksr-backup/shadowsocksr-csharp/releases)

下载完成后，**解压**至任意路径  
记得要解压，不要直接压缩包里，双击 exe 就用，会出问题的

### 手动导入配置

将客户端解压至任意路径，双击 `ShadowsocksR-dotnet4.0`

复制以 "ssr://" 开头的节点配置代码  
在任务栏中找到 ShadowsocksR 的小飞机图标，右键 / "剪贴板批量导入ssr://链接…" 完成导入

![Windows-ssr-input](https://github.com/Coolwrx/tests/raw/master/ss_how/SSR-input.PNG)

### Windows 添加订阅

右键 / "服务器订阅" / "ssr 服务器订阅设置…"

在网址栏**覆盖**填入订阅服务器地址，如`http://baidu.com`  
单击 "Add", 添加订阅地址  
选中原有的默认配置，单击 "Delete", 删除默认配置（头铁的话应该也可以不删，有没有影响我不知道

右键 / "服务器订阅" / "更新SSR服务器订阅（不通过代理）"，然后祈祷奇迹发生
> 如果提示更新失败的话，那就换个网络再试一次（WiFi、流量、whatever）  
> 如果一直失败，那就一直尝试  
> 如果死活不成功，那就打电话骂你的ISP吧。虽然这样肯定不能解决问题，但是会让你好受一点  

### 关于参数设置

#### 系统代理模式

- 直连：不使用代理服务器，直接连接（无法访问被封禁的网站）
- PAC 模式：使用 PAC 过滤规则决定是否通过代理服务器连接
- 全局模式：所有流量都通过代理服务器连接

#### PAC

因为 SS 原版作者被请喝茶，在线 PAC 过滤规则已不再更新，此复选菜单中 仅“编辑本地 PAC 文件”，“编辑 GFWList 规则”这两个功能可用

自带的 FreeSSR-public 同样不可用，原因同上。可直接删除此节点。

#### 代理规则

此处规则仅针对可能需要走代理服务器的流量，与“系统代理模式”中的设置有关但不冲突。

例如，开启全局代理模式，则所有 HTTP / HTTPS 流量均可能通过代理服务器访问，此时 SSR 将会检查代理规则中的设置，确定流量的最终访问方式。

若系统代理选择了 PAC 模式，对已由 PAC 规则确定的，需要通过代理服务器访问的流量，SSR 仍会再次检测代理规则。
简单地说：系统代理选择了 PAC 模式，代理规则就可以选择全局；系统代理选择全局，代理规则可根据需要选择 绕过局域网 / 绕过局域网和大陆 / 用户自定义 中的一个（用户自定义规则为根目录的 user.rule 文件，可直接用记事本打开编辑）

---
手造代码，基本原创；如有雷同，你抄我的

