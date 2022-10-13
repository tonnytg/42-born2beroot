#!/bin/bash

function arch() {
        export ARCH=`uname -a`
        echo "#Architecture: $ARCH"
}

function cpu() {
        export CPU=`cat /proc/cpuinfo | grep cores | awk '{print $4}'`
        echo "#CPU physical : $CPU" 
}

function vcpu() {
        export VCPU=`cat /proc/cpuinfo | grep processor | wc -l`
        echo "#vCPU : $VCPU"
}

function mem() {
        export MT=`free | grep Mem: | awk '{print $2}'`
        export MT=`echo $(( $MT / 1024 ))`
        export MU=`free | grep Mem: | awk '{print $3}'`
        export MU=`echo $(( $MU / 1024 ))`
        export MP=`free | grep Mem | awk '{print $3/$2 * 100}'`
        echo "#Memory Usage: ${MU}/${MT}MB (${MP:0:3}%)" 
}

function diskUsage() {
        export DA=`df | grep root | awk '{print $4}'`
        export DU=`df | grep root | awk '{print $3}'`
        export DT=`echo $(( $DA + DU ))`
        export DT=`echo $(( $DT / 1024 ))`
        export DT2=`df -h | grep root | awk '{print $2}'`
        export DU=`echo $(( $DU / 1024 ))`
        export DP=`echo $DU $DT | awk '{print $1/$2 * 100}'`
        echo "#Disk Usage: ${DU}/${DT2} (${DP:0:2}%)"
}

function cpuload() {
        export T=`top -b -n 1 | grep Cpu | awk '{print $7$8}' | cut -d',' -f2 | tr -d 'id'`
        export T=`bc<<<"100.0 - $T"`
        echo "#CPU load: ${T}%"
}

function lastBoot() {
        export LBD=`last --time-format iso | head -1 | awk '{print $4}' | cut -d'T' -f1`
        export LBH=`last --time-format iso | head -1 | awk '{print $4}' | cut -d'T' -f2`
        echo "#Last boot: ${LBD} ${LBH:0:4}"
}

function lvmOn() {
        export X="antthoma-vg"
        export X=`echo $X | sed 's/-/--/g'`
        cat /etc/fstab | grep $X 2>&1 >> /dev/null
        if [ $? -eq 0 ];then
                echo "#LVM use: yes"
        else
                echo "#LVM use: no"
        fi
}

function countActiveConnections() {
        export CONESTAB=`ss -tn | grep -v State | wc -l`
        echo "#Connections TCP : ${CONESTAB} ESTABLISHED"
}

function countLoggedUsers() {
        export TotalUsers=`w | grep -v USER | grep -v load | awk '{print $1}' | wc -l`
        echo "#User log: ${TotalUsers}"
}

function getIP() {
        export NET="enp0s3"
        export IP=`/usr/sbin/ifconfig $NET | grep -v inet6 | egrep 'inet|ether' | awk '{print $2}' | head -1`
        export MAC=`/usr/sbin/ifconfig $NET | grep -v inet6 | egrep 'inet|ether' | awk '{print $2}' | tail -1`
        echo "#Network: IP ${IP} (${MAC})"
}

function countSudoCommands() {
        export SudoTotal=`journalctl _COMM=sudo | grep COMMAND | wc -l`
        echo "#Sudo : ${SudoTotal} cmd"
}

arch
cpu
vcpu
mem
diskUsage
cpuload
lastBoot
lvmOn
countActiveConnections
countLoggedUsers
getIP
countSudoCommands
