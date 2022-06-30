
## docker-dnmp

##### 容器

| 容器     | 版本            |
|--------|---------------|
| nginx  | 1.21.6-alpine |
| mysql  | 8.0.28        |
| php    | 8.1.7-fpm     |
| redis  | 7.0.0-alpine  |

### 权限
docker默认为root运行，但是每次php运行artisan命令后，所有的文件权限归root所有，所以要把容器用户与宿主机用户改为一致，通过以下命令查看:

```shell
$ id -u
1000
$ id -g
1000
$ id
uid=1000(df) gid=1000(df) groups=1000(df),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),119(lxd)
```

这个1000就是uid和gid

修改`.env`

```env
UID=1000
GID=1000
```

### **安装**

**提示:** MAC 系统要赋予目录 777 权限才能`build`成功

```shell
git clone https://github.com/xgbnl/laradocker.git 

cd laradocker

sudo docker-compose up -d --build
```

### 目录介绍
- **config**
> 存放nginx和redis配置,根据你的喜好你也可以存放php配置

- **database**
> mysql 与 redis 文件存放目录，所有的数据都从容器映射到这个目录里了

- **www**
> 工作目录，所有的 php 项目都存在这个目录中

- **.env**
> 全局配置文件，你可以在里面指定每个容器的版本或增加或修改配置

### PHP
> 内置`composer`,集成常用扩展并且已开启,包括`swoole`,记得ide要安装`swoole-helper`才会有代码提示

- `xdebug`正常使用，端口为`9003`
- `swoole`监听端口为：9501，和`udp`类型的 9502
- 使用nginx配置文件时，监听端口记得设为(容器名:端口号) `php:9000`

### MYSQL
> 默认root密码:root_password

- 访客帐户：  `guest`
- 访客密码:   `bcrypt`
- 初始数据库： `laravel`

在Laravel中使用时，env要填写容器名，就像下面这样:
```dotenv
DB_CONNECTION=mysql
DB_HOST=mysql #这里要使用容器名，不要使用ip或localhost
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=guest
DB_PASSWORD=bcrypt
```

### REDIS
> 默认密码：123456

与`mysql`一样，`HOST`要填写容器名

```dotenv
REDIS_HOST=redis
REDIS_PASSWORD=123456
REDIS_PORT=6379
```
