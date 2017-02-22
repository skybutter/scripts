#!/bin/sh
# start logger server
email=skybutter@gmail.com
node logger-server.js >> server.log 2>&1 &
echo $! > server.pid
echo "process $! started, log file is server.log" 
mailx -s "logger-server started (pid=$!)" $email </dev/null
