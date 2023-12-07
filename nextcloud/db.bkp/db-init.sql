flush privileges;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
ALTER USER 'root'@'%'  IDENTIFIED BY 'newpassword';

CREATE USER 'nextcloud'@'%' IDENTIFIED BY 'mynextpass';
GRANT ALL PRIVILEGES ON *.* TO 'nextcloud'@'localhost' WITH GRANT OPTION;
flush privileges;
