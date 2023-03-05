
## docker-dnmp

##### 容器

| 容器列表                     |
|--------------------------|
| nginx    `1.23.3-alpine` |  
| mysql     `8.0.32`       |        
| php      `8.2.3-fpm`     |     
| redis    `7.0.9-alpine`  |   

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
├── app                                   # 项目存储区
├── config  #容器配置目录
│   ├── nginx                             #nginx预设配置项
│   │   ├── default.conf
│   │   └── laravel.conf
│   └── redis                             #redis配置目录
│       └── redis.conf
├── database                                #数据映射
│   ├── mysql
│   └── redis
│── storage                                 # 日志存储
├── docker-compose.yml                      #容器编排核心文件                                  #项目目录
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

### 布署问题
当我的`react`项目与`laravel`项目布署在同一域名下时，该如何配置`nginx`?

编辑如： `laravel-api.conf` 的 `nginx` 配置文件，在`server`区域块加入以下内容，以达到解析目的
```editorconfig

server {
    ...

    ...

     # 解析你的Laravel项目,让react项目能够正常访问
     location  /api {
        try_files $uri $uri/ /index.php?$query_string;
     }
    
     # 解析你的 React app
     location /react/app {
        alias /var/www/html/react-app/dist/;
        index index.html;
        try_file $uri $uri/ /react/app/index.html;
     }
    
     # 当部署为 Vue 项目 时
     location /vue/app/ {
        alias /var/www/html/web/dist/;
     }
     
     # 解析你上传至服务器的文件
     # 当访问: https://www.website.com/uploads/images/logo.png
     # 文件时，nginx会自动解析 uploads 开头的目录
     location ^~ /uploads/ {
        alias /var/www/html/laravel/storage/uploads/images/;
     }

}

```

### 关于SSL证书
在阿里云或其它服务器厂商购买到的SSL证书请存放至 `cert` 目录
```shell
config/nginx/cert
```
最后替换`laravel.conf`配置文件中的`ssl`文件名
