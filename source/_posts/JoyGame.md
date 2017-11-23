---
title: JoyGame --- 一个情怀游戏平台
date: 2017-9-11 14:26:53
description: '<center><img src="//image.joylau.cn/blog/JoyGame-login.png" alt="JoyGame"></center>  <br>最近和哥们玩起了以前的很多经典单机游戏，比如红警2，魔兽...<br>像这些游戏都支持局域网对战<br>于是有了这样一个平台的诞生 ---- JoyGame'
categories: [程序员篇]
tags: [程序员,技能]
---
<!-- more -->

## 制作背景
- 有时候宅在家里实在不知道玩什么游戏
- 英雄联盟都玩烂了
- 哥们提议玩红警
- 红警是单机啊，一个人玩另一个人怎么办，一个人打电脑有啥意思 =_=|
- 找对战平台啊，首先下载安装了红警玩家自制的战网对战平台
- 我个人电脑从来不安装杀毒软件，Windows Defender 一直报毒搞个不停
- 战网的平台体验也很不好，消息弹个不停，感觉像广告软件
- 后来换了腾讯对战平台，进入红警起个名字老说含有敏感信息，结果起了半个小时，MDZZ
- 决定自己了解下对战平台的原理，打算自己写个简单好用的玩


## 原理
通过socket hook + udp，针对war3来说，支持tcp，先在本地通过hook模拟建立tcp连接，然后将tcp的数据转成外网udp数据发给外网服务器转发给其他客户端，客户端接收到后通过本地tcp模拟连接转发到游戏进程。这个过程中通过中转服务器协助进行p2p。
<center>![JoyGame-zhihu](//image.joylau.cn/blog/JoyGame-zhihu.jpg)</center>

上面是知乎上的回答
用我自己的话说就是
>> 使用JoyGameClient客户端，在本地创建了一个虚拟的IP地址，每一个客户端通过连接远程服务器形成了一个虚拟局域网，这样在游戏的【局域网】选择项中就能找到彼此，这样自然一方创建一个游戏，其他人都可以加入进来了就能愉快的玩耍了。底层通信使用的就是TCP和UDP连接，在同一个房间的玩家都会向服务器发送和下载游戏的实时数据。服务器会向房间里的玩家的客户端上转发数据包，这样就间接形成了一个局域网，就能在一起玩游戏啦。

## 使用
- 解压，打开JoyGameClient.exe
- 选择中间的网络服务器,因为你本地肯定是没有服务端的，只能连接远程部署好的服务器
<center>![JoyGame-Login](//image.joylau.cn/blog/JoyGame-login.png)</center>
- 没有账号，就注册一个账号，注册成功后登录平台
<center>![JoyGame-Login](//image.joylau.cn/blog/JoyGame-main.png)</center>
- 这是主界面
- 接下来进入一个你想玩的游戏的房间
- 设置你的游戏启动主程序
<center>![JoyGame-Login](//image.joylau.cn/blog/JoyGame-setGamePath.png)</center>
- 下面可以设置启动时游戏的参数，比如玩红警时，加入参数 -win，可以窗口启动
- 之后点启动，进入游戏就可找到在一个房间的小伙伴了
- 使用都很简单，看一遍就会

## 特色
- 可以聊天，发表情，可以加好友。。。额，这些好像没有什么特色
- **`可以作弊`**！！！ 该平台只实现了虚拟局域网的互通，并没有考虑游戏的平衡性，因此你可以在网上下载相应的修改器进行作弊，哥们跟我玩红警，到现在他都不知道为什么盘盘都输给我，
<center>![JoyGame-Login](//image.joylau.cn/aodamiao/02.jpg)</center>

## 我想说
如果你想玩玩以前的一些怀旧游戏，或者你想看看该平台是如何操作实现联机的，还等什么，跟着Joy一起来玩吧
私聊我可以给你开个 VIP 、等级直接升到将军哦！虽然没什么用，纯粹装*

## 下载
- JoyGame平台下载： [JoyGameClient.rar](http://image.joylau.cn/blog/JoyGameClient.rar)
- 魔兽争霸3冰封王座v1.26绿色版： [百度网盘](https://pan.baidu.com/share/link?shareid=3779529435&uk=1077172855)
- 红警2共和国之辉：[百度网盘](https://pan.baidu.com/s/1pKQ0aaJ)