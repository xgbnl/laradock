
## Laradock

> Laravel 开发环境

#### 目录结构
```
├── README.md
├── app
├── config
│   ├── nginx
│   │   ├── cert
│   │   ├── default.conf
│   │   └── laravel.conf
│   ├── php
│   │   ├── docker-upload.ini
│   │   └── www.conf
│   └── redis
│       └── redis.conf
├── database
│   ├── mysql
│   └── redis
├── docker-compose.yml
└── storage
    └── logs
        └── redis
            └── redis.log
``` 

#### 构建容器

```shell
$ git clone https://github.com/xgbnl/laradock.git 

$ cd laradock

$ sudo docker-compose up -d --build
```

#### 更新容器
```shell
$ sudo docker-compose up -d --build php
```

#### 项目配置SQL与Redis

```dotenv
# MYSQL
DB_CONNECTION=mysql
DB_HOST=mysql #指定Mysql容器名称
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=password

# Redis
REDIS_HOST=redis #指定Redis容器名称
REDIS_USERNAME=default
REDIS_PASSWORD=123456
REDIS_PORT=6379
```

#### 单机式布署
> 该布署方式适用于 `Laravel` 项目与前端项目使用同一域名时

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

#### 配置SSH证书
在阿里云或其它服务器厂商购买到的SSL证书请存放至 `cert` 目录
```shell
config/nginx/cert
```
最后替换`laravel.conf`配置文件中的`ssl`文件名

#### Thinkphp
新增Thinkphp和Fastadmin老项目支持，如使用将`docker-compose-dev.yml`替换为`docker-compose.yml`文件、`.env.dev`替换为`.env`即可.
