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

arch
cpu
vcpu
mem
cpuload2
