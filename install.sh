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

setup_firewall() {
 ufw app list
 ufw allow in "Apache"
 ufw allow in "OpenSSH"
}

configure_mysql() {
 mysql_secure_installation
}

needs_research() {
# dont know what this is. Looks security related. 
sudo -u www-data vi /srv/www/wordpress/wp-config.php
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );
}

