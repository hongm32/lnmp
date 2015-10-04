#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

MoodleFileName="moodle29_git.tgz"
Download_MirrorSlave='http://218.4.138.116:807/file.php/1/soft'
Download_Mirror='http://10.32.103.10/soft'


# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

cur_dir=$(pwd)
if [ -s /root/lnmp-install.log ]; then
    mv ${cur_dir}/lnmp-install.log ${cur_dir}/lnmp-install.last.log
    mv ${cur_dir}/moodle-install.log ${cur_dir}/moodle-install.last.log
fi

Stack="lnmp"
LNMP_Ver=${cur_dir##*-}

. include/main.sh
. include/init.sh
. include/mysql.sh
. include/mariadb.sh
. include/php.sh
. include/nginx.sh
. include/apache.sh
. include/end.sh


Select_Moodle()
{
    #set Moodle admin email
    echo "==========================="
    MoodleAdminEmail="hongm@sina.com"
    echo -e " \e[0;33mPlease setup E-mail of Moodle Admin.(Default email: hongm@sina.com)\e[0m"
    read -p "Please enter: " MoodleAdminEmail
    if [ "${MoodleAdminEmail}" = "" ]; then
         MoodleAdminEmail="hongm@sina.com"
    fi
    echo -e " \e[0;32mMoodle admin E-mail: \e[0;31m${MoodleAdminEmail}\e[0m"


    #which Moodle Version do you want to install?
    echo "==========================="
    MoodleSelect="4"
    echo -e " \e[0;33mYou have 5 options for your Moodle install.\e[0m"
    echo -e "   \e[0;31m1\e[0m: Install Moodle 2.6 (Legacy releases)"
    echo -e "   \e[0;31m2\e[0m: Install Moodle 2.7 (Security-only-supported releases)"
    echo -e "   \e[0;31m3\e[0m: Install Moodle 2.8 (Other supported releases)"
    echo -e "   \e[0;31m4\e[0m: Install Moodle 2.9 (Latest release)\e[44;37m(Default)\e[0m"
    echo -e "   \e[0;31m5\e[0m: Install Moodle 3.0 (Development release)"
    read -p "Enter your choice (1, 2, 3, 4 or 5): " MoodleSelect
    case "${MoodleSelect}" in
        1)
            echo -e " \e[0;32mYou will install \e[0;31mMoodle 2.6\e[0m"
            MoodleVer="MOODLE_26_STABLE"
            Moodle_Version="2.6"
        ;;
        2)
            echo -e " \e[0;32mYou will install \e[0;31mMoodle 2.7\e[0m"
            MoodleVer="MOODLE_27_STABLE"
            Moodle_Version="2.7"
        ;;
        3)
            echo -e " \e[0;32mYou will install \e[0;31mMoodle 2.8\e[0m"
            MoodleVer="MOODLE_28_STABLE"
            Moodle_Version="2.8"
        ;;
        4)
            echo -e " \e[0;32mYou will install \e[0;31mMoodle 2.9\e[0m"
            MoodleVer="MOODLE_29_STABLE"
            Moodle_Version="2.9"
        ;;
        5)
            echo -e " \e[0;32mYou will install \e[0;31mMoodle 3.0Dev\e[0m"
            MoodleVer="master"
            Moodle_Version="3.0"
        ;;
        *)
            echo -e " \e[0;32mNo input,You will install \e[0;31mMoodle 2.9\e[0m"
            MoodleSelect="4"
            MoodleVer="MOODLE_29_STABLE"
            Moodle_Version="2.9"
    esac

    echo "======================================"
    domain=""
    read -p "Please enter domain(example: www.moodle.org): " domain
    if [ "${domain}" = "" ]; then
        echo "No enter,domain name can't be empty."
        exit 1
    fi
    if [ ! -f "/usr/local/nginx/conf/vhost/${domain}.conf" ]; then
        echo -e " \e[0;32mYour domain: \e[0;31m${domain}\e[0m"
     else
        echo -e " \e[0;32m${domain} is exist!\e[0m"
    fi
}

Start_Moodle()
{
    echo ""
    echo "Press any key to install...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
}

Install_Moodle()
{
    echo -e " \e[0;32m[+] Create ${domain} configuration ...\e[0m"
    echo 'server' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '    {' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        listen 80;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        #listen [::]:80;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo "        server_name ${domain};" >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        index index.html index.htm index.php default.html default.htm default.php;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        root  /www/moodle;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        include moodle.conf;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        location ~ [^/]\.php(/|$)' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        {' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '           fastcgi_pass  unix:/tmp/php-cgi.sock;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '            fastcgi_index index.php;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '            include fastcgi.conf;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '            include pathinfo.conf;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        }' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '        access_log off;' >>/usr/local/nginx/conf/vhost/${domain}.conf
    echo '    }' >>/usr/local/nginx/conf/vhost/${domain}.conf
    /etc/init.d/nginx restart


    echo -e " \e[0;32m[+] Download Moodle Git Clone ...\e[0m"
    cd ${cur_dir}/src
    if [ -s "${MoodleFileName}.00" ]; then
        echo "${MoodleFileName} [found]"
     else
        echo "Error: ${MoodleFileName} not found!!!download now..."
        wget -c ${Download_Mirror}/moodle/${MoodleFileName}.00
        if [ $? -ge 0 -a ! -f ${MoodleFileName}.00 ]; then
            wget -c ${Download_MirrorSlave}/moodle/${MoodleFileName}.00
            wget -c ${Download_MirrorSlave}/moodle/${MoodleFileName}.01
            wget -c ${Download_MirrorSlave}/moodle/${MoodleFileName}.02
            wget -c ${Download_MirrorSlave}/moodle/${MoodleFileName}.03
         else
            wget -c ${Download_Mirror}/moodle/${MoodleFileName}.01
            wget -c ${Download_Mirror}/moodle/${MoodleFileName}.02
            wget -c ${Download_Mirror}/moodle/${MoodleFileName}.03
        fi
    fi


    echo -e " \e[0;32m[+] Install Moodle Soucre...\e[0m"
    mkdir -p /www
    if [ -s "${MoodleFileName}.00" ]; then
        cat ${MoodleFileName}.* |tar xz -C /www/
        cd /www/moodle
        git reset --hard
        git pull
        if [ "${MoodleSelect}" = "4" ]; then
            git reset --hard origin/${MoodleVer}
         else
            git branch --track ${MoodleVer} origin/${MoodleVer}
            git checkout ${MoodleVer}
        fi
     else
        if [ "${MoodleSelect}" = "5" ]; then
            echo "Moodle 3.0Dev Not Found!! download now..."
            wget -c https://download.moodle.org/download.php/direct/moodle/moodle-latest.tgz
            tar zxf moodle-latest.tgz -C /www/
            rm -f moodle-latest.tgz
         else
            echo "Error: moodle-latest-${MoodleVer:7:2}.tgz not found!!!download now..."
            wget -c http://download.moodle.org/download.php/direct/stable${MoodleVer:7:2}/moodle-latest-${MoodleVer:7:2}.tgz
            tar zxf moodle-latest-${MoodleVer:7:2}.tgz -C /www/
            rm -f moodle-latest-${MoodleVer:7:2}.tgz
        fi
    fi

    cd ${cur_dir}/src
    echo '<?PHP  // Moodle configuration file' > /www/moodle/config.php
    echo 'unset($CFG);' >> /www/moodle/config.php
    echo 'global $CFG;' >> /www/moodle/config.php
    echo '$CFG = new stdClass();' >> /www/moodle/config.php
    echo '$CFG->dbtype    = "mariadb";' >> /www/moodle/config.php
    echo '$CFG->dblibrary = "native";' >> /www/moodle/config.php
    echo '$CFG->dbhost    = "localhost";' >> /www/moodle/config.php
    echo '$CFG->dbname    = "moodle";' >> /www/moodle/config.php
    echo '$CFG->dbuser    = "moodle";' >> /www/moodle/config.php
    echo "\$CFG->dbpass    = \"${DB_Root_Password}\";" >> /www/moodle/config.php
    echo '$CFG->prefix    = "mdl_";' >> /www/moodle/config.php
    echo '$CFG->dboptions = array(' >> /www/moodle/config.php
    echo '  "dbpersist" => 0,' >> /www/moodle/config.php
    echo '  "dbport" => "",' >> /www/moodle/config.php
    echo '  "dbsocket" => "",' >> /www/moodle/config.php
    echo ');' >> /www/moodle/config.php
    echo "\$CFG->wwwroot   = \"http://${domain}\";" >> /www/moodle/config.php
    echo '$CFG->dataroot  = "/www/moodledata";' >> /www/moodle/config.php
    echo '$CFG->directorypermissions = 0777;' >> /www/moodle/config.php
    echo '$CFG->admin = "admin";' >> /www/moodle/config.php
    echo 'require_once(dirname(__FILE__) . "/lib/setup.php"); // Do not edit' >> /www/moodle/config.php
    mkdir -p /www/moodledata
    chown -R www:www /www/moodle
    chown -R www:www /www/moodledata
    chmod -R 755 /www/moodle
    chmod -R 755 /www/moodledata
    find /www/moodle -type f -exec chmod 0644 {} \;

    echo -e " \e[0;32m[+] Install Moodle DataBase ...\e[0m"
    echo "grant all on moodle.* to 'moodle'@'localhost' identified by '${DB_Root_Password}';" > /tmp/mariadb_sec_script
    echo "flush privileges;" >> /tmp/mariadb_sec_script
    echo "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" >> /tmp/mariadb_sec_script
    /usr/local/mariadb/bin/mysql -u root -p${DB_Root_Password} -h localhost < /tmp/mariadb_sec_script
    n=0
    while [ $n -le 8 -a ! -f /usr/local/mariadb/data/moodle/mdl_user.frm ]
    do
        /usr/bin/php /www/moodle/admin/cli/install_database.php --lang=zh_cn --adminpass=${DB_Root_Password} --adminemail=${MoodleAdminEmail} --fullname=ITCenter --shortname=ITCenter --agree-license
    done

    if [ $n -ge 8 ]; then
        echo "Network error! Please continue to install http://${IP} in the browser!"
     else
        /usr/bin/mysql -u root -p${MysqlRootPWD} -h localhost -e "UPDATE moodle.mdl_config SET value='firstname,lastname' WHERE name='alternativefullnameformat';"
        /usr/bin/mysql -u root -p${MysqlRootPWD} -h localhost -e "UPDATE moodle.mdl_config SET value='0' WHERE name='defaulthomepage';"
        /usr/bin/mysql -u root -p${MysqlRootPWD} -h localhost -e "UPDATE moodle.mdl_config SET value='CN' WHERE name='country';"
        /usr/bin/mysql -u root -p${MysqlRootPWD} -h localhost -e "UPDATE moodle.mdl_config SET value='Asia/Shanghai' WHERE name='timezone';"
        /usr/bin/mysql -u root -p${MysqlRootPWD} -h localhost -e "UPDATE moodle.mdl_config SET value='' WHERE name='docroot';"
        /usr/bin/php /www/moodle/admin/cli/mysql_compressed_rows.php -f
    fi

    wget  -c ${Download_Mirror}/moodle/zh_cn/zh_cn_local.tar.gz
    if  [ $? -ge 0 -a ! -f zh_cn_local.tar.gz ]; then 
        wget -c ${Download_MirrorSlave}/moodle/zh_cn/zh_cn_local.tar.gz
    fi
    if  [ -f zh_cn_local.tar.gz ]; then
        tar zxf zh_cn_local.tar.gz -C /www/moodledata/lang
    fi

    rm -f /tmp/mariadb_sec_script
}

Install_DB()
{
    if [ "${DBSelect}" = "1" ]; then
        Install_MySQL_51
    elif [ "${DBSelect}" = "2" ]; then
        Install_MySQL_55
    elif [ "${DBSelect}" = "3" ]; then
        Install_MySQL_56
    elif [ "${DBSelect}" = "4" ]; then
        Install_MariaDB_5
    elif [ "${DBSelect}" = "5" ]; then
        Install_MariaDB_10
    elif [ "${DBSelect}" = "6" ]; then
        Install_MariaDB_10
    fi
}

Install_PHP()
{
    if [ "${PHPSelect}" = "1" ]; then
        Install_PHP_52
    elif [ "${PHPSelect}" = "2" ]; then
        Install_PHP_53
    elif [ "${PHPSelect}" = "3" ]; then
        Install_PHP_54
    elif [ "${PHPSelect}" = "4" ]; then
        Install_PHP_55
    elif [ "${PHPSelect}" = "5" ]; then
        Install_PHP_56
    elif [ "${PHPSelect}" = "6" ]; then
        Install_PHP_70
    fi
}

LNMP_Stack()
{
    Press_Install
    Print_Sys_Info
    if [ "${DISTRO}" = "RHEL" ]; then
        RHEL_Modify_Source
    fi
    Get_Dist_Version
    if [ "${DISTRO}" = "Ubuntu" ]; then
        Ubuntu_Modify_Source
    fi
    Set_Timezone
    if [ "$PM" = "yum" ]; then
        CentOS_InstallNTP
        CentOS_RemoveAMP
        CentOS_Dependent
    elif [ "$PM" = "apt" ]; then
        Deb_InstallNTP
        Xen_Hwcap_Setting
        Deb_RemoveAMP
        Deb_Dependent
    fi
    Disable_Selinux
    Check_Download
    Install_Autoconf
    Install_Libiconv
    Install_Libmcrypt
    Install_Mhash
    Install_Mcrypt
    Install_Freetype
    Install_Curl
    Install_Pcre
    if [ "${SelectMalloc}" = "2" ]; then
        Install_Jemalloc
    elif [ "${SelectMalloc}" = "3" ]; then
        Install_TCMalloc
    fi
    if [ "$PM" = "yum" ]; then
        CentOS_Lib_Opt
    elif [ "$PM" = "apt" ]; then
        Deb_Lib_Opt
        Deb_Check_MySQL
    fi
    Install_DB
    Export_PHP_Autoconf
    Install_PHP
    Install_Nginx
    Creat_PHP_Tools
    Add_LNMP_Startup
    Check_LNMP_Install
}


Get_Dist_Name
if [ "${DISTRO}" = "unknow" ]; then
    Echo_Red "Unable to get Linux distribution name, or do NOT support the current distribution."
    exit 1
fi
clear
echo "+------------------------------------------------------------------------+"
echo "|           Moodle for ${DISTRO} Linux Server, Written by XueHong           |"
echo "+------------------------------------------------------------------------+"
echo "|         A tool to auto-compile & install LNMP+Moodle on Linux          |"
echo "+------------------------------------------------------------------------+"

if [[ -s /usr/local/nginx/conf/nginx.conf && -s /usr/local/nginx/sbin/nginx ]]; then
    echo -e " \e[0;31mNginx OK.\e[0m"
    Select_Moodle
    Start_Moodle
 else
    Dispaly_Selection
    Select_Moodle
    LNMP_Stack 2>&1 | tee -a ${cur_dir}/lnmp-install.log
    DB_Root_Password=${MysqlRootPWD}
fi
Install_Moodle 2>&1 | tee -a ${cur_dir}/moodle-install.log
