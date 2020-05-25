
# the OS to use
FROM debian:buster

# the maintainer & contact details
LABEL MAINTAINER="qli"

# update packages
RUN apt-get update && apt-get upgrade -y

# install Nginx
RUN apt-get install nginx -y

# install openssl packages
RUN apt-get install -y openssl

# setting up main server page
RUN mkdir -p /var/www/localhost/html
RUN chown -R $USER:$USER /var/www/localhost/html
COPY srcs/index.html /var/www/localhost/html
COPY srcs/style.css /var/www/localhost/html

# generate ssl certificate
RUN openssl req -x509 \
	-nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/localhost.key \
	-out /etc/ssl/certs/localhost.crt \
	-subj "/C=NL/ST=Noord Holland/L=Amsterdam\
	/O=Codam/CN=www.localhost.com"

# copy nginx config file to the right place
COPY srcs/nginx.conf /etc/nginx/sites-available/localhost

# symlin this to sites-enabled to enable it
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled

# install MySQL to store & manage site data
RUN apt-get install mariadb-server mariadb-client -y

# create mysql database
RUN service mysql start && \
	echo "CREATE USER 'qli'@'localhost' IDENTIFIED BY 'server';" | mysql -u root && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'qli'@'localhost';" | mysql -u root && \
	echo "CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';" | mysql -u root && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost';" | mysql -u root && \
	echo "GRANT SELECT, INSERT, DELETE, UPDATE ON phpmyadmin.* TO 'root'@'localhost';" | mysql -u root && \
	echo "FLUSH PRIVILEGES;" | mysql -u root && \
	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root

# install & configure PHP to handle the admin of MySQL
RUN apt-get install -y php7.3-fpm php7.3-mysql php-json php-mbstring wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-english.tar.gz
RUN tar -zxvf phpMyAdmin-4.9.5-english.tar.gz
RUN mkdir /var/www/localhost/html/wordpress
RUN mv phpMyAdmin-4.9.5-english /var/www/localhost/html/wordpress/phpMyAdmin
RUN rm -f phpMyAdmin-4.9.5-english.tar.gz
COPY srcs/config.inc.php /var/www/localhost/html/wordpress/phpMyAdmin
RUN chmod 660 /var/www/localhost/html/wordpress/phpMyAdmin/config.inc.php
RUN mkdir /var/www/localhost/html/wordpress/phpMyAdmin/tmp
RUN chmod -R 777 /var/www/localhost/html/wordpress/phpMyAdmin/tmp
RUN chown -R www-data:www-data /var/www/localhost/html/wordpress/phpMyAdmin

# run the database in mysql
RUN service mysql start && \
	mysql < /var/www/localhost/html/wordpress/phpMyAdmin/sql/create_tables.sql -u root

# download wp-cli
RUN apt-get install -y sudo
RUN wget -c https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update

# download wordpress
RUN chmod -R 775 /var/www/localhost/html/wordpress/
RUN wp core download --path=/var/www/localhost/html/wordpress/ --allow-root

# install send mail
# RUN apt-get install -y sendmail

# create a new user & database
RUN service mysql start &&\
	echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root && \
	echo "GRANT ALL ON wordpress.* TO 'qli'@'localhost' IDENTIFIED BY 'server';" | mysql -u root &&\
	echo "FLUSH PRIVILEGES;" | mysql -u root

#install wordpress
RUN service mysql start &&\
	wp config create --dbname=wordpress --dbuser=qli --dbpass=server \
	--locale=ro_RO --path=/var/www/localhost/html/wordpress/ --allow-root
RUN service mysql start &&\
	wp core install --url=localhost/wordpress --title=Testing \
	--admin_user=qli --admin_password=server --admin_email=info@example.com\
	--path=/var/www/localhost/html/wordpress/ --allow-root
RUN chown -R www-data:www-data /var/www/localhost/html/wordpress/

# define the port number the container should expose
# 80 for HTTP && 443 for HTTPS
EXPOSE 80 443

# run the command
CMD service nginx start &&\
	service mysql restart &&\
	service php7.3-fpm start &&\
	bash
