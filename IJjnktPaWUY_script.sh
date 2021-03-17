echo "--------------------------------DEBUT DE L'INSTALLATION---------------------------------------"
apt update && apt upgrade && apt dist-upgrade
apt-get install sudo -y

echo "-----------------------------ATTRIBUTION DES DROITS ADMIN------------------------------------"
sed -i "20i $utilisateur ALL=(ALL:ALL) ALL" /etc/sudoers

apt update -y
apt install zip -y 
apt install unzip -y 


apt install curl && apt upgrade -y

echo "-------------------------------INSTALLATION D'APACHE--------------------------------------"
apt install apache2 apache2-utils libapache2-mod-php

echo "------------------------------INSTALLATION PHPMYADMIN----------------------------------"
apt install mariadb-server -y
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip
unzip phpMyAdmin-4.9.0.1-all-languages.zip
mv phpMyAdmin-4.9.0.1-all-languages /usr/share/phpmyadmin
chown -R www-data:www-data /usr/share/phpmyadmin
apt-get install php-imagick php-phpseclib php-php-gettext php-common php-mysql php-gd php-imap php-json php-curl php-zip php-xml php-mbstring php-bz2 php-intl php-gmp -y

echo "
# phpMyAdmin default Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>

</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" >> /etc/apache2/conf-available/phpmyadmin.conf

a2enconf phpmyadmin.conf
mkdir -p /var/lib/phpmyadmin/tmp
chown www-data:www-data /var/lib/phpmyadmin/tmp
systemctl restart apache2


echo "---------------------------CREATION BASE DE DONNEES------------------------------"
mysql -e "CREATE DATABASE melusine"
mysql -e "CREATE USER 'melusine'@'localhost' IDENTIFIED BY '1234'"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'melusine'@'localhost' WITH GRANT OPTION"

echo "----------------------------------------FIN------------------------------"