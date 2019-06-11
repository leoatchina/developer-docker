# passwd for root
echo root:$PASSWD | chpasswd
# change port for ssh
#sed -i 's/Port 22/Port 8822/g' /etc/ssh/sshd_config
echo 'Port 8822' >> /etc/ssh/sshd_config
#sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# start server with supervisor
/usr/bin/supervisord -c /etc/supervisord.conf
[ -f /root/local/startup.sh ] && bash /root/local/startup.sh
