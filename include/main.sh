#!/bin/bash

Dispaly_Selection()
{
#set mysql root password

    MysqlRootPWD="123456"
    Echo_Yellow "Please setup root password of MySQL.(Default password: 123456)"
    read -p "Please enter: " MysqlRootPWD
    if [ "${MysqlRootPWD}" = "" ]; then
        MysqlRootPWD="123456"
    fi
    echo -e " \e[0;32mMySQL root password: \e[0;31m${MysqlRootPWD}\e[0m"

#do you want to enable or disable the InnoDB Storage Engine?
    echo "==========================="

    InstallInnodb="y"
    Echo_Yellow "Do you want to enable or disable the InnoDB Storage Engine?"
    read -p "Default enable,Enter your choice [Y/n]: " InstallInnodb

    case "${InstallInnodb}" in
    [yY][eE][sS]|[yY])
        echo -e " \e[0;32mYou will \e[0;31menable\e[0;32m the InnoDB Storage Engine!\e[0m"
    ;;
    [nN][oO]|[nN])
        echo -e " \e[0;32mYou will \e[0;31mdisable\e[0;32m the InnoDB Storage Engine!\e[0m"
    ;;
    *)
        echo -e " \e[0;32mNo input,The InnoDB Storage Engine will \e[0;31menable\e[0m"
        InstallInnodb="y"
    esac

#which MySQL Version do you want to install?
    echo "==========================="

    DBSelect="5"
    Echo_Yellow "You have 6 options for your DataBase install."
    echo -e "   \e[0;31m1\e[0m: Install MySQL ${MySQL_Version1}"
    echo -e "   \e[0;31m2\e[0m: Install MySQL ${MySQL_Version2}"
    echo -e "   \e[0;31m3\e[0m: Install MySQL ${MySQL_Version3}"
    echo -e "   \e[0;31m4\e[0m: Install MariaDB ${MariaDB_Version4}"
    echo -e "   \e[0;31m5\e[0m: Install MariaDB ${MariaDB_Version5} \e[44;37m(Default)\e[0m"
    echo -e "   \e[0;31m6\e[0m: Install MariaDB ${MariaDB_Version6}"
    read -p "Enter your choice (1, 2, 3, 4, 5 or 6): " DBSelect

    case "${DBSelect}" in
    1)
        echo -e " \e[0;32mYou will install \e[0;31mMySQL ${MySQL_Version1}\e[0m"
    ;;
    2)
        echo -e " \e[0;32mYou will install \e[0;31mMySQL ${MySQL_Version2}\e[0m"
    ;;
    3)
        echo -e " \e[0;32mYou will install \e[0;31mMySQL ${MySQL_Version3}\e[0m"
    ;;
    4)
        echo -e " \e[0;32mYou will install \e[0;31mMariaDB ${MariaDB_Version4}\e[0m"
    ;;
    5)
        echo -e " \e[0;32mYou will install \e[0;31mMariaDB ${MariaDB_Version5}\e[0m"
    ;;
    6)
        echo -e " \e[0;32mYou will install \e[0;31mMariaDB ${MariaDB_Version6}\e[0m"
    ;;
    *)
        echo -e " \e[0;32mNo input,You will install \e[0;31mMariaDB ${MariaDB_Version5}\e[0m"
        DBSelect="5"
    esac

    if [ "${DBSelect}" = "4" ] || [ "${DBSelect}" = "5" ] || [ "${DBSelect}" = "6" ]; then
        MySQL_Bin="/usr/local/mariadb/bin/mysql"
        MySQL_Config="/usr/local/mariadb/bin/mysql_config"
        MySQL_Dir="/usr/local/mariadb"
     else
        MySQL_Bin="/usr/local/mysql/bin/mysql"
        MySQL_Config="/usr/local/mysql/bin/mysql_config"
        MySQL_Dir="/usr/local/mysql"
    fi

#which PHP Version do you want to install?
    echo "==========================="

    PHPSelect="5"
    Echo_Yellow "You have 6 options for your PHP install."
    echo -e "   \e[0;31m1\e[0m: Install PHP ${PHP_Version1}"
    echo -e "   \e[0;31m2\e[0m: Install PHP ${PHP_Version2}"
    echo -e "   \e[0;31m3\e[0m: Install PHP ${PHP_Version3}"
    echo -e "   \e[0;31m4\e[0m: Install PHP ${PHP_Version4}"
    echo -e "   \e[0;31m5\e[0m: Install PHP ${PHP_Version5} \e[44;37m(Default)\e[0m"
    echo -e "   \e[0;31m6\e[0m: Install PHP ${PHP_Version6}"
    read -p "Enter your choice (1, 2, 3, 4, 5 or 6): " PHPSelect

    case "${PHPSelect}" in
    1)
        echo -e " \e[0;32mYou will install \e[0;31mPHP ${PHP_Version1}\e[0m"
    ;;
    2)
       echo -e " \e[0;32mYou will install \e[0;31mPHP ${PHP_Version2}\e[0m"
    ;;
    3)
        echo -e " \e[0;32mYou will install \e[0;31mPHP ${PHP_Version3}\e[0m"
    ;;
    4)
        echo -e " \e[0;32mYou will install \e[0;31mPHP ${PHP_Version4}\e[0m"
    ;;
    5)
        echo -e " \e[0;32mYou will install \e[0;31mPHP ${PHP_Version5}\e[0m"
    ;;
    6)
        echo -e " \e[0;32mYou will install \e[0;31mPHP ${PHP_Version6}\e[0m"
    ;;
    *)
        echo -e " \e[0;32mNo input,You will install \e[0;31mPHP ${PHP_Version5}\e[0m"

        PHPSelect="5"
    esac

#which Memory Allocator do you want to install?
    echo "==========================="

    SelectMalloc="1"
    Echo_Yellow "You have 3 options for your Memory Allocator install."
    echo -e "   \e[0;31m1\e[0m: Don't install Memory Allocator. \e[44;37m(Default)\e[0m"
    echo -e "   \e[0;31m2\e[0m: Install Jemalloc"
    echo -e "   \e[0;31m3\e[0m: Install TCMalloc"
    read -p "Enter your choice (1, 2 or 3): " SelectMalloc

    case "${SelectMalloc}" in
    1)
        echo -e " \e[0;32mYou will not install Memory Allocator.\e[0m"
    ;;
    2)
        echo -e " \e[0;32mYou will install \e[0;31mJeMalloc\e[0m"
    ;;
    3)
        echo -e " \e[0;32mYou will install \e[0;31mTCMalloc\e[0m"
    ;;
    *)
        echo -e " \e[0;32mNo input,You will not install Memory Allocator.\e[0m"
        SelectMalloc="1"
    esac

    if [ "${SelectMalloc}" =  "1" ]; then
        MySQL51MAOpt=''
        MySQL55MAOpt=''
        NginxMAOpt=''
     elif [ "${SelectMalloc}" =  "2" ]; then
        MySQL51MAOpt='--with-mysqld-ldflags=-ljemalloc'
        MySQL55MAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF"
        MariaDBMAOpt=''
        NginxMAOpt="--with-ld-opt='-ljemalloc'"
     elif [ "${SelectMalloc}" =  "3" ]; then
        MySQL51MAOpt='--with-mysqld-ldflags=-ltcmalloc'
        MySQL55MAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ltcmalloc' -DWITH_SAFEMALLOC=OFF"
        MariaDBMAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ltcmalloc' -DWITH_SAFEMALLOC=OFF"
        NginxMAOpt='--with-google_perftools_module'
    fi
}

Nginx_Selection()
{
    #which Nginx Version do you want to install?
    echo "==========================="
    NginxSelect="1"
    Echo_Yellow "You have 2 options for your Nginx install."
    echo -e "   \e[0;31m1\e[0m: Install Nginx ${Nginx_Version1} \e[44;37m(Default)\e[0m"
    echo -e "   \e[0;31m2\e[0m: Install Nginx ${Nginx_Version2}"
    read -p "Enter your choice (1 or 2): " NginxSelect

    if [ "${NginxSelect}" = "1" ]; then
        echo -e " \e[0;32mYou will install \e[0;31mNginx ${Nginx_Version1}\e[0m"
     elif [ "${NginxSelect}" = "2" ]; then
        echo -e " \e[0;32mYou will install \e[0;31mNginx ${Nginx_Version2}\e[0m"
     else
        echo -e " \e[0;32mNo input,You will install \e[0;31mNginx ${Nginx_Version1}\e[0m"
        NginxSelect="1"
    fi
}

Apache_Selection()
{
    echo "==========================="
#set Server Administrator Email Address
    ServerAdmin=""
    read -p "Please enter Administrator Email Address:" ServerAdmin
    if [ "${ServerAdmin}" == "" ]; then
        echo "Administrator Email Address will set to hongm@sina.com!"
        ServerAdmin="hongm@sina.com"
     else
        echo "==========================="
        echo Server Administrator Email: "${ServerAdmin}"
        echo "==========================="
    fi

#which Apache Version do you want to install?
    echo "==========================="
    ApacheSelect="2"
    Echo_Yellow "You have 2 options for your Apache install."
    echo -e "   \e[0;31m1\e[0m: Install Apache ${Apache_Version1}"
    echo -e "   \e[0;31m2\e[0m: Install Apache ${Apache_Version2} \e[44;37m(Default)\e[0m"
    read -p "Enter your choice (1 or 2): " ApacheSelect

    if [ "${ApacheSelect}" = "1" ]; then
        echo -e " \e[0;32mYou will install \e[0;31mApache ${Apache_Version1}\e[0m"
     elif [ "${ApacheSelect}" = "2" ]; then
        echo -e " \e[0;32mYou will install \e[0;31mApache ${Apache_Version2}\e[0m"
     else
        echo -e " \e[0;32mNo input,You will install \e[0;31mApache ${Apache_Version2}\e[0m"
        ApacheSelect="2"
    fi
}

Press_Install()
{
    . include/version.sh
    echo ""
    echo "Press any key to install...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
}

Press_Start()
{
    echo ""
    echo "Press any key to start...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
}

Install_LSB()
{
    if [ "$PM" = "yum" ]; then
        yum -y install redhat-lsb
    elif [ "$PM" = "apt" ]; then
        apt-get update
        apt-get install -y lsb-release
    fi
}

Get_Dist_Version()
{
    Install_LSB
    eval ${DISTRO}_Version=`lsb_release -rs`
    eval echo "${DISTRO} \${${DISTRO}_Version}"
}

Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    Get_OS_Bit
}

Get_RHEL_Version()
{
    Get_Dist_Name
    if [ "${DISTRO}" = "RHEL" ]; then
        if grep -Eqi "release 5." /etc/redhat-release; then
            echo "Current Version: RHEL Ver 5"
            RHEL_Ver='5'
        elif grep -Eqi "release 6." /etc/redhat-release; then
            echo "Current Version: RHEL Ver 6"
            RHEL_Ver='6'
        elif grep -Eqi "release 7." /etc/redhat-release; then
            echo "Current Version: RHEL Ver 7"
            RHEL_Ver='7'
        fi
    fi
}

Get_OS_Bit()
{
    if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
        Is_64bit='y'
    else
        Is_64bit='n'
    fi
}

Get_ARM()
{
    if uname -m | grep -Eqi "arm"; then
        Is_ARM='y'
    fi
}

Download_Files()
{
    local URL=$1
    local FileName=$2
    if [ -s "${FileName}" ]; then
        echo "${FileName} [found]"
    else
        echo "Error: ${FileName} not found!!!download now..."
        wget -c ${URL}
    fi
}

Tar_Cd()
{
    local FileName=$1
    local DirName=$2
    cd ${cur_dir}/src
    [[ -d "${DirName}" ]] && rm -rf ${DirName}
    echo "Uncompress ${FileName}..."
    tar zxf ${FileName}
    echo "cd ${DirName}..."
    cd ${DirName}
}

Print_Sys_Info()
{
    cat /etc/issue
    cat /etc/*-release
    uname -a
    MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
    echo "Memory is: ${MemTotal} MB "
    df -h
}

StartUp()
{
    init_name=$1
    echo "Add ${init_name} service at system startup..."
    if [ "$PM" = "yum" ]; then
        chkconfig --add ${init_name}
        chkconfig ${init_name} on
    elif [ "$PM" = "apt" ]; then
        update-rc.d -f ${init_name} defaults
    fi
}

Remove_StartUp()
{
    init_name=$1
    echo "Removing ${init_name} service at system startup..."
    if [ "$PM" = "yum" ]; then
        chkconfig ${init_name} off
        chkconfig --del ${init_name}
    elif [ "$PM" = "apt" ]; then
        update-rc.d -f ${init_name} remove
    fi
}

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

Get_PHP_Ext_Dir()
{
    Cur_PHP_Version=`/usr/local/php/bin/php -r 'echo PHP_VERSION;'`
    if echo "${Cur_PHP_Version}" | grep -Eqi '^5.2.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.3.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.4.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20100525/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.5.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.6.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20131226/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^7.0.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20141001/"
    fi
}

Check_Stack()
{
    if [[ -s /usr/local/php/bin/php-cgi || -s /usr/local/php/sbin/php-fpm ]] && [[ -s /usr/local/php/etc/php-fpm.conf && -s /etc/init.d/php-fpm && -s /usr/local/nginx/sbin/nginx ]]; then
        Get_Stack="lnmp"
    elif [[ -s /usr/local/nginx/sbin/nginx && -s /usr/local/apache/bin/httpd && -s /usr/local/apache/conf/httpd.conf && -s /etc/init.d/httpd && ! -s /usr/local/php/sbin/php-fpm ]]; then
        Get_Stack="lnmpa"
    elif [[ -s /usr/local/apache/bin/httpd && -s /usr/local/apache/conf/httpd.conf && -s /etc/init.d/httpd && ! -s /usr/local/php/sbin/php-fpm ]]; then
        Get_Stack="lamp"
    else
        Get_Stack="unknow"
    fi
}

Check_DB()
{
    if [[ -s /usr/local/mariadb/bin/mysql && -s /usr/local/mariadb/bin/mysqld_safe && -s /etc/my.cnf ]]; then
        MySQL_Bin="/usr/local/mariadb/bin/mysql"
        MySQL_Config="/usr/local/mariadb/bin/mysql_config"
        MySQL_Dir="/usr/local/mariadb"
        Is_MySQL="n"
        DB_Name="mariadb"
    else
        MySQL_Bin="/usr/local/mysql/bin/mysql"
        MySQL_Config="/usr/local/mysql/bin/mysql_config"
        MySQL_Dir="/usr/local/mysql"
        Is_MySQL="y"
        DB_Name="mysql"
    fi
}

Verify_DB_Password()
{
    Check_DB
    read -p "verify your current database root password: " DB_Root_Password
    ${MySQL_Bin} -uroot -p${DB_Root_Password} -e "quit"
    if [ $? -eq 0 ]; then
        echo "MySQL root password correct."
    else
        echo "MySQL root password incorrect!Please check!"
        Verify_DB_Password
    fi
    if [ "${DB_Root_Password}" = "" ]; then
        Verify_DB_Password
    fi
}