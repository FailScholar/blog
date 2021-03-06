---
title: Ubuntu 自用配置记录
date: 2018-06-28 15:16:22
description: 安装完 Ubuntu 后自定义的一些配置记录
categories: [Ubuntu篇]
tags: [Ubuntu]
---
<!-- more -->

## 安装完系统后的一些配置

1. 关闭并禁用 swap 分区： sudo swapoff 并且 sudo vim /etc/fstab 注释掉 swap 那行

2. 开启点击图标最小化： gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true

3. 开机开启小键盘： sudo apt-get install numlockx 然后 sudo vim /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf 在最后添加：greeter-setup-script=/usr/bin/numlockx on

4. 用久显示隐藏文件夹： Edit -> Preferences -> Views 勾选 Show hidden and backup files

5. 禁用客人会话： https://blog.csdn.net/thuyx/article/details/78503870

6. jdk 10 的配置？？
    分别下载 jdk10 和 jre 10 解压缩到 /usr/java目录下
    配置如下环境变量

``` bash
    #set java environment
    JAVA_HOME=/usr/java/jdk-10
    JRE_HOME=/usr/java/jre-10
    CLASS_PATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
    
    MAVEN_HOME=/usr/maven/apache-maven-3.5.3
    NODE_HOME=/usr/nodejs/node-v8.11.2-linux-x64
    
    PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:${NODE_HOME}/bin:$PATH
    export JAVA_HOME JRE_HOME CLASS_PATH MAVEN_HOME NODE_HOME PATH

```

7. 安装中文字体文泉译：sudo apt-get install fonts-wqy-microhei

8. 防火墙配置
    sudo ufw enable
    
    sudo ufw default deny
    
    运行以上两条命令后，开启了防火墙，并在系统启动时自动开启。关闭所有外部对本机的访问，但本机访问外部正常
    
    sudo ufw disable 关闭防火墙

9. 鼠标移动速度调整
    xset m N
    其中，N是速度，估计取值为0-10
    恢复默认 xset m default



## apt-get 命令的记录
1. 卸载软件： sudo apt-get purge docker-ce
2. 查看软件版本： apt-cache madison docker-ce 

## 2018年07月19日09:10:55 更新
indicator-sysmonitor 显示网速时,在状态栏会左右移动,解决方法是:
修改源代码

``` bash
    sudo vi  /usr/lib/indicator-sysmonitor/sensors.py   
```

打开后，修改第29行的B_UNITS:

``` bash
    B_UNITS = ['MB', 'GB', 'TB']
```

接着修改下面的bytes_to_human函数：

``` python
    def bytes_to_human(bytes_):                 
    unit = 0    
    bytes_ = bytes_ / 1024 / 1024    
    while bytes_ > 1024:    
        unit += 1    
        bytes_ /= 1024    
    # 做成00.00MB/s的形式，避免变化     
    return '{:0>5.2f}{:0>2}'.format(bytes_, B_UNITS[unit]) 
```

然后保存退出，重启就可以了。