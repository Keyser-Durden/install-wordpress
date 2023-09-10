#!/bin/bash

download_wordpress() {
 sudo mkdir -p /opt/www
 sudo chown www-data: /opt/www
 curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /opt/www
}

enable_site() {
 a2ensite wordpress
 a2enmod rewrite
 a2dissite 000-default
 service apache2 reload
}
 
configure_db() {
 echo "Nothing here yet"
}
