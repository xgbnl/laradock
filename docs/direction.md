##### 目录说明

- `config` 容器配置
- `databases` mysql/redis 存储与备份
- `bootstrap` Dockerfile 核心文件
- `www` 项目目录
- `docker-compose.yml` 核心配置文件

#### 安装前请切换Docker镜像源

  网易163镜像源:

```shell
http://hub-mirror.c.163.com
```

#### 安装方法

在 `docker-compose.yml` 所在目录运行以下命令:

```shell
docker-compose up -d --build
```

#### 查看 `nginx`、`php` 是否安装成功

```shell
127.0.0.1
```

#### Mysql 说明

- `root` 密码: `root_password`

**内置用户与密码:**

- `guest`
- `bcrypt`

**关于 `mysql` 的连接**

- 使用laravel等框加连接mysql时，`DB_HOST` 的值请填写为: `mysql-master` 为该容器名
- 使用navicat管理程序连接mysql时，请连接宿主机ip

使用 `guest` 帐户创建更多的数据库？

- 使用 root 帐户登录mysql
- 创建数据
- 将数据库赋予guest帐户控制权限
```shell
mysql -u root -p root_password

create database test_db;

GRANT ALL PRIVILEGES ON test_db. * to 'guest'@'%';

FLUSH PRIVILEGES;
```