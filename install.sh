#!/bin/bash
source settings.conf

install_packages() {
 xargs -a package.list sudo apt-get install -y < /dev/null >> installation.log 2>> installation_errors.log
}

setup_php_fpm() {
 /usr/sbin/php-fpm8.1 -v
 sudo ln -s /usr/sbin/php-fpm8.1 /usr/sbin/php-fpm
 sudo systemctl enable php8.1-fpm
 sudo systemctl start php8.1-fpm
}

download_wordpress() {
 sudo mkdir -p /opt/www
 sudo chown www-data: /opt/www
 curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /opt/www
}

create_wordpress_conf() {
 echo "create_wordpress_conf"
 # put wordpress.conf into /etc/apache2/sites-available/
 # and make sure permissions are correct
}

enable_site() {
 a2ensite wordpress.conf
 a2enmod rewrite
 a2dissite 000-default
 #service apache2 reload
 systemctl reload apache2
}

 configure_db() {
  echo "need to check this"
  # CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  # GRANT ALL ON wordpress.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
  # FLUSH PRIVILEGES;  
  mysql -u root -p <<EOF
  CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
  FLUSH PRIVILEGES;
  EXIT;
EOF
}

setup_firewall() {
 ufw app list
 ufw allow in "Apache"
 ufw allow in "OpenSSH"
 ufw app list
}

configure_mysql() {
 mysql_secure_installation
}

apache_test_restart() {
 apache2ctl configtest
 systemctl reload apache2
}

swap_index_order() {
 vi /etc/apache2/mods-enabled/dir.conf
 # Swap the order of items to put index.php first. Something like
 # DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
}

enable_htaccess() {
vi /etc/apache2/sites-available/wordpress.conf
# ensure "AllowOverride All" 

#<VirtualHost *:80>
#. . .
#    <Directory /var/www/wordpress/>
#        AllowOverride All
#    </Directory>
#. . .
#</VirtualHost>
}

needs_research() {
# Aledgedly this is already done upon installing wordpress
# Check wp-config.php after install to check.
curl -s https://api.wordpress.org/secret-key/1.1/salt/

sudo -u www-data vi /opt/www/wordpress/wp-config.php
# define( 'AUTH_KEY',         'put your unique phrase here' );
# define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
# define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
# define( 'NONCE_KEY',        'put your unique phrase here' );
# define( 'AUTH_SALT',        'put your unique phrase here' );
# define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
# define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
# define( 'NONCE_SALT',       'put your unique phrase here' );
}

#install_packages
#download_wordpress
### create_wordpress_conf
#enable_site
#setup_firewall
configure_db
