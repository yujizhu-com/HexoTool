#!bin/expect  
set ip yujizhu.com  
# set timeout 100  
spawn ftp $ip  

expect "Name*"  
send "root\r"  

expect "Password:*"  
send "YJZ@centos21\r"

expect "ftp>*"
send "prompt off\r"

expect "ftp>*"
send "passive\r"

expect "ftp>*"
send "binary\r"

#传输文章
expect "ftp>*"  
send "lcd /Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/source\r" 

expect "ftp>*" 
send "cd /home/Hexo/blog/source/_posts\r"

expect "ftp>*"
send "mput *\r"

#传输图片


expect "ftp>*"
send "lcd /Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/pic/17_面向对象建模\r"

expect "ftp>*"
send "mkdir /home/Hexo/blog/source/_posts/17_面向对象建模\r"

expect "ftp>*"
send "cd /home/Hexo/blog/source/_posts/17_面向对象建模\r"

expect "ftp>*"
send "mput *\r"


expect "ftp>*"
send "lcd /Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/pic/18_mysql控制台报错UnknownDatabase\r"

expect "ftp>*"
send "mkdir /home/Hexo/blog/source/_posts/18_mysql控制台报错UnknownDatabase\r"

expect "ftp>*"
send "cd /home/Hexo/blog/source/_posts/18_mysql控制台报错UnknownDatabase\r"

expect "ftp>*"
send "mput *\r"


expect "ftp>*"
send "lcd /Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/pic/19_简洁javascript代码实现动态添加form、input、div等表单元素\r"

expect "ftp>*"
send "mkdir /home/Hexo/blog/source/_posts/19_简洁javascript代码实现动态添加form、input、div等表单元素\r"

expect "ftp>*"
send "cd /home/Hexo/blog/source/_posts/19_简洁javascript代码实现动态添加form、input、div等表单元素\r"

expect "ftp>*"
send "mput *\r"


expect "ftp>*"
send "bye\r"

spawn ssh root@yujizhu.com 
send "sh /home/bin/genBlog.sh\r"
send "exit\r"
interact