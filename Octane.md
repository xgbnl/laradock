## 关于运行Laravel Octane
#### nginx `octane.conf`
```
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

upstream app {
    server php:8000;
}

server {
    listen 80;
    listen [::]:80;
    server_name laravel.test;
    server_tokens off;
    root /var/www/html/laravel/public;

    index index.php;

    charset utf-8;

    location /index.php {
        try_files /not_exists @octane;
    }

    location / {
        try_files $uri $uri/ @octane;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;

    error_page 404 /index.php;

    location @octane {
        set $suffix "";

        if ($uri = /index.php) {
            set $suffix ?$query_string;
        }

        proxy_http_version 1.1;
        proxy_set_header Host $http_host;
        proxy_set_header Scheme $scheme;
        proxy_set_header SERVER_PORT $server_port;
        proxy_set_header REMOTE_ADDR $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        proxy_pass http://app$suffix;
    }
}
```
#### 运行Octane

必须指定`host=0.0.0.0`,否则`nginx`容器无法访问

```shell
php artisan octane:start --host=0.0.0.0 --port=8000
```
