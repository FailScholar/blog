---
title: 记录 -- Docker 三种方式部署 ownCloud
date: 2018-10-26 09:15:55
description: ownCloud 除了传统的部署方式,在如今 docker 大行其道的环境下,使用 docker 部署 ownCloud 才是最方便的
categories: [Docker篇]
tags: [Docker,ownCloud]
---

<!-- more -->

### 说明
ownCloud 除了传统的部署方式,在如今 docker 大行其道的环境下,使用 docker 部署 ownCloud 才是最方便的

### 第一种 owncloud 镜像直接安装
直接部署 owncloud 镜像,该镜像地址: https://hub.docker.com/r/_/owncloud/

``` sbtshell
    docker pull owncloud
    docker run -d -p 80:80 owncloud
```

这种方式的需要你提前装好 MariaDb 数据库,在启动完成后打开页面会按照流程填写数据库的链接信息,之后就可以使用 ownCloud 了


### 第二种 分别安装
分别先后使用 docker 按照 redis,mariadb,ownCloud
安装 redis 的 mariadb

``` shell
    docker volume create owncloud_redis
    
    docker run -d \
      --name redis \
      -e REDIS_DATABASES=1 \
      --volume owncloud_redis:/var/lib/redis \
      webhippie/redis:latest
    
    docker volume create owncloud_mysql
    docker volume create owncloud_backup
    
    docker run -d \
      --name mariadb \
      -e MARIADB_ROOT_PASSWORD=owncloud \
      -e MARIADB_USERNAME=owncloud \
      -e MARIADB_PASSWORD=owncloud \
      -e MARIADB_DATABASE=owncloud \
      --volume owncloud_mysql:/var/lib/mysql \
      --volume owncloud_backup:/var/lib/backup \
      webhippie/mariadb:latest
```

接着我们配置一些 ownCloud web 服务的环境变量,并在启动容器时使用这些变量

``` shell
    export OWNCLOUD_VERSION=10.0
    export OWNCLOUD_DOMAIN=localhost
    export ADMIN_USERNAME=admin
    export ADMIN_PASSWORD=admin
    export HTTP_PORT=80
    
    docker volume create owncloud_files
    
    docker run -d \
      --name owncloud \
      --link mariadb:db \
      --link redis:redis \
      -p ${HTTP_PORT}:8080 \
      -e OWNCLOUD_DOMAIN=${OWNCLOUD_DOMAIN} \
      -e OWNCLOUD_DB_TYPE=mysql \
      -e OWNCLOUD_DB_NAME=owncloud \
      -e OWNCLOUD_DB_USERNAME=owncloud \
      -e OWNCLOUD_DB_PASSWORD=owncloud \
      -e OWNCLOUD_DB_HOST=db \
      -e OWNCLOUD_ADMIN_USERNAME=${ADMIN_USERNAME} \
      -e OWNCLOUD_ADMIN_PASSWORD=${ADMIN_PASSWORD} \
      -e OWNCLOUD_REDIS_ENABLED=true \
      -e OWNCLOUD_REDIS_HOST=redis \
      --volume owncloud_files:/mnt/data \
      owncloud/server:${OWNCLOUD_VERSION}
```

之后稍等片刻,打开网页即可

### 第三种 docker-compose 部署
首先保证 docker-compose 的版本在 1.12.0+ 

``` sbtshell
    # 创建一个新的目录
    mkdir owncloud-docker-server
    
    cd owncloud-docker-server
    
    # 下载 docker-compose.yml 文件
    wget https://raw.githubusercontent.com/owncloud-docker/server/master/docker-compose.yml
    
    # 配置环境变量文件
    cat << EOF > .env
    OWNCLOUD_VERSION=10.0
    OWNCLOUD_DOMAIN=localhost
    ADMIN_USERNAME=admin
    ADMIN_PASSWORD=admin
    HTTP_PORT=80
    HTTPS_PORT=443
    EOF
    
    # 构建并启动容器
    docker-compose up -d
```

当上面的流程都完成时，通过运行 `docker-compose ps` 检查所有容器是否已成功启动
还可以使用 `docker-compose logs --follow owncloud` 来查看日志
`docker-compose stop` 停止容器
`docker-compose down` 停止和删除容器

#### 版本更新
1. 进入 .yaml 或 .env 目录
2. 将 ownCloud 设置维护模式,` docker-compose exec server occ maintenance:mode --on`
3. 停止容器, `docker-compose down`
4. 修改. env 文件的版本号,手动或者 `sed -i 's/^OWNCLOUD_VERSION=.*$/OWNCLOUD_VERSION=<newVersion>/' /compose/*/.env`
5. 重新构建并启动, `docker-compose up -d`

配置说明
OWNCLOUD_VERSION:  ownCloud 版本
OWNCLOUD_DOMAIN: ownCloud 可访问的域
ADMIN_USERNAME: 管理员用户名
ADMIN_PASSWORD: 管理员密码
HTTP_PORT: 使用的端口
HTTPS_PORT: SSL使用的端口



总结来说,推荐使用第三种方式来部署.

