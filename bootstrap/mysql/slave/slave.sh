  #定义连接master进行同步的账号
  SLAVE_SYNC_USER="${SLAVE_SYNC_USER:-sync_guest}"
  #定义连接master进行同步的账号密码
  SLAVE_SYNC_PASSWORD="${SLAVE_SYNC_PASSWORD:-123456}"
  #定义slave数据库账号
  MYSQL_ROOT_USER="${MYSQL_ROOT_USER:-root}"
  #定义slave数据库密码
  MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-root_password}"
  #定义连接master数据库host地址
  MYSQL_MASTER_HOST="${MYSQL_MASTER_HOST:-%}"
  #等待10s，保证master数据库启动成功，不然会连接失败
  sleep 10
  #连接master数据库，查询二进制数据，并解析出logfile和pos，这里同步用户要开启 REPLICATION CLIENT权限，才能使用SHOW MASTER STATUS;
  # shellcheck disable=SC2006
  RESULT=`mysql -u"$SLAVE_SYNC_USER" -h"$MYSQL_MASTER_HOST" -p"$SLAVE_SYNC_PASSWORD" -e "SHOW MASTER STATUS;" | grep -v grep |tail -n +2| awk '{print $1,$2}'`
  #解析出logfile
  # shellcheck disable=SC2006
  LOG_FILE_NAME=`echo "$RESULT" | grep -v grep | awk '{print $1}'`
  #解析出pos
  # shellcheck disable=SC2006
  LOG_FILE_POS=`echo "$RESULT" | grep -v grep | awk '{print $2}'`
  #设置连接master的同步相关信息
  SYNC_SQL="change master to master_host='$MYSQL_MASTER_HOST',master_user='$SLAVE_SYNC_USER',master_password='$SLAVE_SYNC_PASSWORD',master_log_file='$LOG_FILE_NAME',master_log_pos=$LOG_FILE_POS;"
  #开启同步
  START_SYNC_SQL="start slave;"
  #查看同步状态
  STATUS_SQL="show slave status\G;"
  mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" -e "$SYNC_SQL $START_SYNC_SQL $STATUS_SQL"
