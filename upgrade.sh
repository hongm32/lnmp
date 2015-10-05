#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

cur_dir=$(pwd)
Download_Mirror='http://hongm.emoodle.org'
action=$1
shopt -s extglob
Upgrade_Date=$(date +"%Y%m%d%H%M%S")

. include/main.sh
. include/init.sh
. include/upgrade_nginx.sh
. include/upgrade_php.sh
. include/upgrade_mysql.sh
. include/upgrade_mariadb.sh
. include/upgrade_mysql2mariadb.sh

Get_Dist_Name
Get_OS_Bit

Display_Upgrade_Menu()
{
    echo -e " \e[0;33mYou have 7 options for Upgrade.\e[0m"
    echo -e "   \e[0;31m1\e[0m: Upgrade Nginx"
    echo -e "   \e[0;31m2\e[0m: Upgrade MySQL"
    echo -e "   \e[0;31m3\e[0m: Upgrade MariaDB"
    echo -e "   \e[0;31m4\e[0m: Upgrade PHP for LNMP"
    echo -e "   \e[0;31m5\e[0m: Upgrade PHP for LNMPA or LAMP"
    echo -e "   \e[0;31m6\e[0m: Upgrade MySQL to MariaDB"
    echo -e "   \e[0;31mexit\e[0m: Exit current script"
    echo "###################################################"
    read -p "Enter your choice (1, 2, 3, 4, 5, 6 or exit): " action
}

clear
echo "+-----------------------------------------------------------------------+"
echo "|             Upgrade script for LNMP , Written by Hongm                |"
echo "+-----------------------------------------------------------------------+"
echo "|     A tool to upgrade Nginx,MySQL/Mariadb,PHP for LNMP/LNMPA/LAMP     |"
echo "+-----------------------------------------------------------------------+"

if [ "${action}" == "" ]; then
    Display_Upgrade_Menu
fi

    case "${action}" in
    1|[nN][gG][iI][nN][xX])
        Upgrade_Nginx 2>&1 | tee /root/upgrade_nginx${Upgrade_Date}.log
    ;;
    2|[mM][yY][sS][qQ][lL])
        Upgrade_MySQL 2>&1 | tee /root/upgrade_mysq${Upgrade_Date}.log
    ;;
    3|[mM][aA][rR][iI][aA][dD][bB])
        Upgrade_MariaDB 2>&1 | tee /root/upgrade_mariadb${Upgrade_Date}.log
    ;;
    4|[pP][hP][pP])
        Stack="lnmp"
        Upgrade_PHP 2>&1 | tee /root/upgrade_lnmp_php${Upgrade_Date}.log
    ;;
    5|[pP][hP][pP][aA])
        Upgrade_PHP 2>&1 | tee /root/upgrade_a_php${Upgrade_Date}.log
    ;;
    6|[mM]2[mY])
        Upgrade_MySQL2MariaDB 2>&1 | tee /root/upgrade_mysql2mariadb${Upgrade_Date}.log
    ;;
    [eE][xX][iI][tT])
        exit 1
    ;;
    *)
        echo "Usage: ./upgrade.sh {nginx|mysql|mariadb|m2m|php|phpa}"
        exit 1
    ;;
    esac