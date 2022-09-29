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
        export M=`free | grep Mem: | awk '{print $2}'`
        export MT=`echo $(( $M / 1024 ))`
        echo "#Memory Usage: X/${MT}MB (X.XX%)" 
}

function cpuload() {
        export CPULoad=$[100-$(vmstat 1 2| tail -1|awk '{print $15}')]
        echo "#CPU load: ${CPULoad}%"
}

function cpuload2() {
        export CPULoad=`uptime | awk '{print $8}' | tr ',' '$'`
        echo "#CPU load: ${CPULoad}%"
}

function lvmOn() {
        export X=`vgs | grep -v VG | awk '{print $1}'`
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
        export IP=`ifconfig $NET | grep -v inet6 | egrep 'inet|ether' | awk '{print $2}' | head -1`
        export MAC=`ifconfig $NET | grep -v inet6 | egrep 'inet|ether' | awk '{print $2}' | tail -1`
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
cpuload2
lvmOn
countActiveConnections
countLoggedUsers
getIP
countSudoCommands
