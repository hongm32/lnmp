#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Version
. include/mainversion.sh


# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi
cur_dir=$(pwd)
if [ -s ${cur_dir}/lnmp-install.log ]; then
    mv ${cur_dir}/lnmp-install.log ${cur_dir}/lnmp-install.last.log
fi


Stack=$1
if [ "${Stack}" = "" ]; then
    Stack="lnmp"
else
    Stack=$1
fi


Download_Mirror='http://218.4.138.116:807/file.php/1/soft'
Download_MirrorSlave='http://hongm.emoodle.org'

LNMP_Ver=${cur_dir##*-}
. include/main.sh
. include/init.sh
. include/mysql.sh
. include/mariadb.sh
. include/php.sh
. include/nginx.sh
. include/apache.sh
. include/end.sh

Get_Dist_Name

if [ "${DISTRO}" = "unknow" ]; then
    Echo_Red "Unable to get Linux distribution name, or do NOT support the current distribution."
    exit 1
fi

clear
echo "+------------------------------------------------------------------------+"
echo "|          LNMP V${LNMP_Ver} for ${DISTRO} Linux Server, Written by XueHong         |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install LNMP/LNMPA/LAMP on Linux       |"
echo "+------------------------------------------------------------------------+"


Init_Install()
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
}

Install_Database()
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
    Nginx_Selection
    Init_Install
    Install_Database
    Export_PHP_Autoconf
    Install_PHP
    Install_Nginx
    Creat_PHP_Tools
    Add_LNMP_Startup
    Check_LNMP_Install
}

LNMPA_Stack()
{
    Nginx_Selection
    Apache_Selection
    Init_Install
    Install_Database
    Export_PHP_Autoconf
    if [ "${ApacheSelect}" = "1" ]; then
        Install_Apache_22
    else
        Install_Apache_24
    fi
    Install_PHP
    Install_Nginx
    Creat_PHP_Tools
    Add_LNMPA_Startup
    Check_LNMPA_Install
}

LAMP_Stack()
{
    Apache_Selection
    Init_Install
    Install_Database
    Export_PHP_Autoconf
    if [ "${ApacheSelect}" = "1" ]; then
        Install_Apache_22
    else
        Install_Apache_24
    fi    
    Install_PHP
    Creat_PHP_Tools
    Add_LAMP_Startup
    Check_LAMP_Install
}

case "${Stack}" in
    lnmp)
        Dispaly_Selection
        LNMP_Stack 2>&1 | tee -a /root/lnmp-install.log
        ;;
    lnmpa)
        Dispaly_Selection
        LNMPA_Stack 2>&1 | tee -a /root/lnmp-install.log
        ;;
    lamp)
        Dispaly_Selection
        LAMP_Stack 2>&1 | tee -a /root/lnmp-install.log
        ;;
    *)
        Echo_Red "Usage: $0 {lnmp|lnmpa|lamp}"
        ;;
esac
