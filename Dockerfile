# @package  Personal ISP Containers
# @asset    nginx + php-fpm
# @author   https://github.com/krausb/

FROM debian:latest

RUN apt-get update -qqy --fix-missing --allow-unauthenticated
RUN apt-get install -qqy nginx php-fpm php-cli php-mysql php-curl php-xsl php-gd php-mbstring

# preparing config dirs
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
RUN rm -f /etc/nginx/sites-enabled/default

# linking nginx configs
COPY server-conf/nginx.conf /etc/nginx/nginx.conf
COPY server-conf/caches.conf /etc/nginx/conf.d/caches.conf
COPY site-conf/vhost.conf /etc/nginx/sites-enabled/vhost.conf

# preparing php config dirs
RUN mv /etc/php/7.0/fpm/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf.orig
RUN mv /etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/php.ini.orig
RUN mv /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf.orig
COPY server-conf/php-fpm/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
COPY server-conf/php-fpm/php.ini /etc/php/7.0/fpm/php.ini
COPY server-conf/php-fpm/www.conf /etc/php/7.0/fpm/pool.d/www.conf

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 80
VOLUME /srv/data

RUN mkdir -p /srv/data; chmod 775 /srv/data; chown -R www-data:www-data /srv/data

CMD ["/usr/local/bin/start.sh"]
