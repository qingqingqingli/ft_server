
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

# setting up server blocks
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
RUN apt-get install mariadb-server -y

# create mysql database
RUN service mysql start && \
	echo "CREATE USER 'qli'@'localhost' IDENTIFIED BY 'server';" | mysql -u root && \
	echo "GRANT ALL ON mysql_database.* TO 'qli'@'localhost';" | mysql -u root && \
	echo "CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';" | mysql -u root && \
	echo "GRANT ALL ON mysql_database.* TO 'pma'@'localhost';" | mysql -u root && \
	echo "FLUSH PRIVILEGES;" | mysql -u root && \
	echo "exit" | mysql -u root

# install & configure PHP
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

# define the port number the container should expose
# 80 for HTTP && 443 for HTTPS
EXPOSE 80 443

# run the command
CMD service nginx start &&\
	service mysql restart &&\
	service php7.3-fpm start &&\
	bash
