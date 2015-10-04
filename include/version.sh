#!/bin/bash

# Main Version
if [ "${NginxSelect}" = "1" ]; then
    Nginx_Ver="nginx-${Nginx_Version1}"
 elif [ "${NginxSelect}" = "2" ]; then
    Nginx_Ver="nginx-${Nginx_Version2}"
fi
if [ "${DBSelect}" = "1" ]; then
    Mysql_Ver="mysql-${MySQ_Version1}"
 elif [ "${DBSelect}" = "2" ]; then
    Mysql_Ver="mysql-${MySQ_Version2}"
 elif [ "${DBSelect}" = "3" ]; then
    Mysql_Ver="mysql-${MySQ_Version3}"
 elif [ "${DBSelect}" = "4" ]; then
    Mariadb_Ver="mariadb-${MariaDB_Version4}"
 elif [ "${DBSelect}" = "5" ]; then
    Mariadb_Ver="mariadb-${MariaDB_Version5}"
 elif [ "${DBSelect}" = "6" ]; then
    Mariadb_Ver="mariadb-${MariaDB_Version6}"
fi
if [ "${PHPSelect}" = "1" ]; then
    Php_Ver="php-${PHP_Version1}"
 elif [ "${PHPSelect}" = "2" ]; then
    Php_Ver="php-${PHP_Version2}"
 elif [ "${PHPSelect}" = "3" ]; then
    Php_Ver="php-${PHP_Version3}"
 elif [ "${PHPSelect}" = "4" ]; then
    Php_Ver="php-${PHP_Version4}"
 elif [ "${PHPSelect}" = "5" ]; then
    Php_Ver="php-${PHP_Version5}"
 elif [ "${PHPSelect}" = "6" ]; then
    Php_Ver="php-${PHP_Version6}"
fi

# Other Version
Autoconf_Ver="autoconf-2.69"
Libiconv_Ver="libiconv-1.14"
LibMcrypt_Ver="libmcrypt-2.5.8"
Mcypt_Ver="mcrypt-2.6.8"
Mash_Ver="mhash-0.9.9.9"
Freetype_Ver="freetype-2.5.5"
Curl_Ver="curl-7.42.1"
Pcre_Ver="pcre-8.37"
Jemalloc_Ver="jemalloc-3.6.0"
TCMalloc_Ver="gperftools-2.4"
Libunwind_Ver="libunwind-1.1"
if [ "${PHPSelect}" = "1" ]; then
    PhpMyAdmin_Ver="phpMyAdmin-${PhpMyAdmin_Version1}-all-languages"
else
    PhpMyAdmin_Ver="phpMyAdmin-${PhpMyAdmin_Version2}-all-languages"
    if [ "${DBSelect}" = "1" ]; then
        PhpMyAdmin_Ver="phpMyAdmin-${PhpMyAdmin_Version1}-all-languages"
    fi
fi
APR_Ver="apr-1.5.2"
APR_Util_Ver="apr-util-1.5.4"
Mod_RPAF_Ver="mod_rpaf-0.8.4-rc3"
if [ "${ApacheSelect}" = "1" ]; then
    Apache_Version="httpd-${Apache_Version1}"
 elif [ "${ApacheSelect}" = "2" ]; then
    Apache_Version="httpd-${Apache_Version1}"
fi
Pureftpd_Ver="pure-ftpd-1.0.37"
Pureftpd_Manager_Ver="User_manager_for-PureFTPd_v2.1_CN"
XCache_Ver="xcache-3.2.0"
ImageMagick_Ver="ImageMagick-6.9.1-2"
Imagick_Ver="imagick-3.1.2"
ZendOpcache_Ver="zendopcache-7.0.4"
Redis_Stable_Ver="redis-3.0.1"
Redis_Old_Ver="redis-2.8.20"
PHPRedis_Ver="redis-2.2.7"
Memcached_Ver="memcached-1.4.22"
Libmemcached_Ver="libmemcached-1.0.18"
PHPMemcached_Ver="memcached-2.2.0"
PHPMemcache_Ver="memcache-3.0.8"

# Display Version
if [ "${Stack}" != "" ]; then
    echo ""
    Echo_Green "You will install ${Stack} stack."
    if [ "${Stack}" != "lamp" ]; then
        echo ${Nginx_Ver}
    fi
    if [[ "${DBSelect}" = "1" || "${DBSelect}" = "2" || "${DBSelect}" = "3" ]]; then
        echo "${Mysql_Ver}"
    elif [[ "${DBSelect}" = "4" || "${DBSelect}" = "5" ]]; then
        echo "${Mariadb_Ver}"
    fi
    echo "${Php_Ver}"
    if [ "${Stack}" != "lnmp" ]; then
        echo "${Apache_Version}"
    fi
    if [ "${SelectMalloc}" = "2" ]; then
        echo "${Jemalloc_Ver}"
    elif [ "${SelectMalloc}" = "3" ]; then
        echo "${TCMalloc_Ver}"
    fi
fi

#http://nginx.org/en/download.html
#https://downloads.mariadb.org/
#http://php.net/downloads.php
#ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
#http://ftp.gnu.org/pub/gnu/libiconv/
#http://sourceforge.net/projects/mcrypt/files/Libmcrypt/
#http://www.phpmyadmin.net/home_page/downloads.php
#http://ftp.gnu.org/gnu/autoconf/
#http://savannah.nongnu.org/download/freetype/
#http://sourceforge.net/projects/mhash/
#wget -c http://nginx.org/download/$Nginx_Ver.tar.gz
#wget -c --no-check-certificate https://downloads.mariadb.org/f/$Mariadb_Ver/source/$Mariadb_Ver.tar.gz
#wget -c http://www.php.net/distributions/$Php_Ver.tar.gz
#wget -c ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$Pcre_Ver.tar.gz
#wget -c http://ftp.gnu.org/pub/gnu/libiconv/$Libiconv_Ver.tar.gz
#wget -c http://downloads.sourceforge.net/mcrypt/$LibMcrypt_Ver.tar.gz
# phpMyAdmin_version=${PhpMyAdmin_Ver#*-} && phpMyAdmin_version=${phpMyadmin_version%%-*}
#wget -c http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/$phpMyAdmin_version/$PhpMyAdmin_Ver.tar.gz
#wget -c http://ftp.gnu.org/gnu/autoconf/$Autoconf_Ver.tar.gz
#wget -c http://download.savannah.gnu.org/releases/freetype/$Freetype_Ver.tar.gz
# mhash_version=${Mash_Ver#*-}
#wget -c http://downloads.sourceforge.net/project/mhash/mhash/$mhash_version/$Mash_Ver.tar.gz
#wget -c http://mirror.bit.edu.cn/apache//apr/${APR_Ver}.tar.gz
#wget -c http://mirror.bit.edu.cn/apache//apr/${APR_Util_Ver}.tar.gz
#wget -c http://mirrors.hust.edu.cn/apache/httpd/${Apache_Version}.tar.gz