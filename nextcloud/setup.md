# https://blog.braincoke.fr/server/install-nextcloud-with-docker/

# create the password secrets
# containing password must be ended with a line-break

touch next_db_password.txt
touch next_db_root_password.txt


# mysql:

# https://wolfgang.gassler.org/reset-password-mariadb-mysql-docker/
1. run docker with command:  --skip-grant-tables
2. log into a bash shell of the db container
3. mysql -u root -p (login with empty pass)
4. run db-init.sql contents (copy paste) or stdin

mysql -u root -pMyRootPass < /docker-entrypoint-initdb.d/mysql*.sql

# nextcloud
sudo chown -R www-data:root /var/www/html/data

