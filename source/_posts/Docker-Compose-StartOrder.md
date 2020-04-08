---
title: Docker-Compose 中多容器启动顺序问题
date: 2018-12-19 10:40:54
description: 我们在 docker-compose 一条命令就启动我们的多个容器时,需要考虑到容器之间的启动顺序问题.....
categories: [Docker篇]
tags: [Docker,Docker-Compose]
---

<!-- more -->
### 背景
我们在 docker-compose 一条命令就启动我们的多个容器时,需要考虑到容器之间的启动顺序问题.....

比如有的服务依赖数据库的启动, service 依赖 eureka 的启动完成

docker compose 里有 depends_on 配置,但是他不能等上一个容器里的服务完全启动完成,才启动下一个容器,这仅仅定义了启动的顺序, 那么这就会导致很多问题的发生

比如应用正在等待数据库就绪,而此时数据库正在初始化数据, 导致无法连接退出等等

### 官方的做法
地址 : https://docs.docker.com/compose/startup-order/
官方的思路是使用一个脚本,轮询给定的主机和端口，直到它接受 TCP 连接
个人感觉这种方式不是很好

还有几个开源的工具解决方法, 这些是一些小型脚本,和上面的原理类似:

1. wait-for-it : https://github.com/vishnubob/wait-for-it
2. dockerize : https://github.com/jwilder/dockerize
3. wait-for : https://github.com/Eficode/wait-for


这些工具也能解决问题,但有很大的局限性: 需要重新定义 command , 在执行完自己的脚本后在执行容器里的启动脚本

如果不知道容器的启动脚本或者容器的启动脚本很长,并且带有参数,那将非常头疼

查看容器的启动脚本:

```bash
    docker ps --no-trunc --format="table {{.ID}}\t{{.Command}}:"
```

```bash
    docker inspect container
```

### health 健康检查方法

比如下面的配置

``` yaml
      server:
        image: 34.0.7.183:5000/joylau/traffic-service-server:1.2.0
        container_name: traffic-service-server
        ports:
          - 9368:9368
        restart: always
        volumes:
          - /Users/joylau/log/server:/home/liufa/app/server/logs
        environment:
          activeProfile: prod
        hostname: traffic-service-eureka
        healthcheck:
          test: "/bin/netstat -anp | grep 9367"
          interval: 10s
          timeout: 3s
          retries: 1
      admin:
        image: 34.0.7.183:5000/joylau/traffic-service-admin:1.2.0
        container_name: traffic-service-admin
        ports:
          - 9335:9335
        restart: always
        volumes:
          - /Users/joylau/log/admin:/home/liufa/app/admin/logs
        environment:
          activeProfile: prod
        depends_on:
          server:
            condition: service_healthy
        hostname: traffic-service-admin
        links:
          - server:traffic-service-eureka
```

server 使用了健康检查 healthcheck
- `test` : 命令,必须是字符串或列表，如果它是一个列表，第一项必须是 NONE，CMD 或 CMD-SHELL ；如果它是一个字符串，则相当于指定CMD-SHELL 后跟该字符串, 例如: `test: ["CMD", "curl", "-f", "http://localhost"]` 或者 `test: ["CMD-SHELL", "curl -f http://localhost || exit 1"]`  或者 `test: curl -f https://localhost || exit 1`
- `interval`: 每次执行的时间间隔
- `timeout`: 每次执行时的超时时间,超过这个时间,则认为不健康
- `retries`: 重试次数,如果 retries 次后都是失败,则认为容器不健康
- `start_period`: 启动后等待多次时间再做检查, version 2.3 版本才有

interval, timeout, start_period 格式如下:

```text
    2.5s
    10s
    1m30s
    2h32m
    5h34m56s
```

健康状态返回 0 (health) 1 (unhealth) 2(reserved)

test 命令的通用是 `'xxxx && exit 0 || exit 1'` , 2 一般不使用

admin depends_on server ,且条件是 service_healthy ,即容器为健康状态,即 9368 端口开启


### 最后
1. depends_on 在 2.0 版本就有, healthcheck 在 2.1 版本上才添加,因此上述的写法至少在 docker-compose  version: '2.1' 版本中才生效
2. docker-compose version 3 将不再支持 depends_on 中的 condition 条件
3. depends_on 在 version 3 中以 docker swarm 模式部署时,将被忽略