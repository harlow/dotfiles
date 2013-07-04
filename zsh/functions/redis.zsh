redstart() {
  redstop

  for file in `ls /usr/local/etc/redis-server-*.conf`; do
    redis-server $file
  done
}

redstop() {
  for file in `ls /usr/local/etc/redis-server-*.conf`; do
    pidfile=`grep pidfile $file | awk '{print $2}'`
    if [ -f $pidfile ]; then
      kill `cat $pidfile`
    fi
  done
}
