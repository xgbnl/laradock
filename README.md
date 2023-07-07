
## About laraveldocker

> 基于 `Laravel` 的开发或布署环境

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
│   ├── queue
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

#### 下载&&构建

```shell
$ git clone https://github.com/xgbnl/laradocker.git 

$ cd laradocker

$ sudo docker-compose up -d --build
```

####  配置数据库

```dotenv
# MYSQL
DB_CONNECTION=mysql
DB_HOST=mysql 
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=guest
DB_PASSWORD=password

# Redis
REDIS_HOST=redis
REDIS_USERNAME=default
REDIS_PASSWORD=123456
REDIS_PORT=6379
```

#### 布署

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

 **修复了普通用户运行php-fpm时所带来的错误**
```
NOTICE: [pool www] 'user' directive is ignored when FPM is not running as root
NOTICE: [pool www] 'group' directive is ignored when FPM is not running as root
```
该问题解决方案：注释 `/usr/local/etc/php-fpm.d/www.conf`中的 `www` 与 `group` (本项目已经解决这些问题，你无需担心)
