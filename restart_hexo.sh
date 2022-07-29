#!bin/expect  
spawn ssh root@yujizhu.com 
send "pm2 restart run\r"
send "exit\r"
interact
# send "mget *\r"
 # expect {  
 # "*file"  { send_user "local $_dir No such file or directory";send "quit\r" }  
 # "*now*"  { send "get $dir/$file $dir/$file\r"}  
 # }  
 # expect {  
 # "*Failed" { send_user "remote $file No such file";send "quit\r" }  
 # "*OK"     { send_user "$file has been download\r";send "quit\r"}  
 # }  
 # expect eof 