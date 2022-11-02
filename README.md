
## docker-dnmp

##### 容器

| 容器列表                     |
|--------------------------|
| nginx    `1.23.2-alpine` |  
| mysql     `8.0.31`       |        
| php      `8.1.12-fpm`    |     
| redis    `7.0.5-alpine`  |   

### **安装**

**提示:** MAC 系统要赋予目录 777 权限才能`build`成功

```shell
git clone https://github.com/xgbnl/laradocker.git 

cd laradocker

sudo docker-compose up -d --build
```

### 目录结构
```
├── README.md                             #说明文档
├── config                                #容器配置目录
│   ├── nginx                             #nginx预设配置项
│   │   ├── default.conf
│   │   └── laravel.conf
│   └── redis                             #redis配置目录
│       └── redis.conf
├── database                                #数据映射
│   ├── mysql
│   └── redis
│       └── redis.log
├── docker-compose.yml                      #容器编排核心文件
└── www                                     #项目目录
└── .env                                    #配置
└── .env.example                            #备份配置
```

### PHP容器

容器内部集成了常用扩展,以及composer、swoole

- `xdebug`端口:`9003`
- `swoole`端口：9501，和`udp`类型的 9502
- `nginx`监听端口:`fastcgi_pass php:9000;`

### mysql容器
- 默认root密码: `root_password`
- 访客帐户：  `guest`
- 访客密码:   `bcrypt`
- 默认数据库： `laravel`

在使用`Laravel`时，`env`需要如下配置:
```dotenv
DB_CONNECTION=mysql
DB_HOST=mysql #这里要使用容器名，不要使用ip或localhost
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=guest
DB_PASSWORD=bcrypt
```

### redis容器
- 默认密码：`123456`

```dotenv
REDIS_HOST=redis
REDIS_PASSWORD=123456
REDIS_PORT=6379
```
