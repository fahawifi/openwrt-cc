#!/bin/bash
#从本地压缩openwrt-cc目录并上传到vps
#tar -zcvf openwrt-cc.tar.gz /root/openwrt-cc
#scp /root/openwrt-cc.tar.gz ubuntu@111.231.253.82:/home/ubuntu
#sudo su
#tar -zxvf openwrt-cc.tar.gz

#从vps下载整个目录到 本地电脑root
#scp -r ubuntu@111.231.253.160:/home/ubuntu/openwrt-cc/files /root
#scp -r ubuntu@111.231.253.160:/home/ubuntu/openwrt-cc/feeds /root

apt-get update
apt -y install binwalk
apt-get -y install git-core
apt-get -y install build-essential
apt-get -y install zlib1g-dev
apt-get -y install liblzma-dev
apt-get -y install python-magic
apt-get -y install subversion
apt-get -y install libncurses5-dev
apt-get -y install gawk
apt-get -y install flex
apt-get -y install quilt
apt-get -y install libssl-dev
apt-get -y install xsltproc
apt-get -y install libxml-parser-perl
apt-get -y install mercurial
apt-get -y install bzr
apt-get -y install ecj
apt-get -y install cvs
apt-get -y install unzip
apt-get -y install bzip2
apt-get -y install git
apt-get -y install wget
apt-get -y install gcc
apt-get -y install g++ 
apt-get -y install binutils 
apt-get -y install patch
apt-get -y install bison 
apt-get -y install autoconf 
apt-get -y install gettext 
apt-get -y install texinfo 
apt-get -y install sharutils
apt-get -y install ncurses-term
apt-get -y install asciidoc
apt-get -y install libz-dev
apt-get -y install make
apt-get -y install libssl-dev
apt-get -y install ncurses-dev
apt-get -y install bison
apt-get -y install gcc-multilib
apt-get -y install flex
apt-get -y install gperf
apt-get -y install libelf-dev
apt-get -y install libc6-dev-i386
apt-get -y upgrade
#直接设置dns，解析网站地址解决国外非被墙的网站网速慢，需重启网络
echo '192.30.253.112 github.com' >> /etc/hosts
echo '151.101.185.194 github.global.ssl.fastly.net' >> /etc/hosts

#nano 1
#chmod +x 1
#./1
#安装依赖和解固（fmk/fmk/rootfs/*）必须以root身份
#但是git等方式下载OpenWrt固件源码（直接可以刷到该路由，但没有大菠萝功能）和后期./scripts/feeds update -a开始安装都必须切换到普通用户，否则出错
cd
sudo useradd -m wei
sudo passwd  wei 
sudo usermod -a -G sudo wei 
sudo chsh -s /bin/bash wei
su wei
#Password: 
#To run a command as administrator (user "root"), use "sudo <command>".
#See "man sudo_root" for details.
#wei@VM-98-43-ubuntu:/home/ubuntu$ 


#可以是root身份，只要最后的make是普通用户即可
sudo nano 2
sudo chmod +x 2
sudo ./2

#以上中断，复制以下代码后保存为2，再执行该脚本
=============================================
#!/bin/bash

#下载该路由型号官网的openwrt源码，尽量原生和简洁

#这部分可以在本地电脑完成后在上传到vps，zip解固到files+feeds文件夹clone，迅速
sudo git clone https://github.com/fahawifi/openwrt-cc.git
sudo mkdir openwrt-cc/files
cd openwrt-cc
#切换成root才有权限解固
sudo tar -zxvf fmk_099.tar.gz
cd fmk
sudo echo "BINWALK=binwalk" >> shared-ng.inc
sudo ./extract-firmware.sh ../upgrade-2.4.2.bin
#把.bin改为.zip后缀，解压得到的文件放到openwrt-cc/files，和/fmk/fmk/rootfs里面的内容看似是一样的，其实不同
#在kali中失败，必须Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-130-generic x86_64)

cd
sudo chmod +x openwrt-cc
sudo cp -r openwrt-cc/fmk/fmk/rootfs/* openwrt-cc/files/
sudo rm -rf openwrt-cc/files/lib/modules/*
sudo rm -rf openwrt-cc/files/sbin/modprobe



su wei
cd
cd /home/wei
sudo nano 3
sudo chmod +x 3
sudo ./3

================================
#!/bin/bash
sudo tar -zxvf openwrt-cc.tar.gz
cd
cd openwrt-cc
sudo chmod +x ./scripts/feeds
sudo ./scripts/feeds update -a
sudo ./scripts/feeds install -a
sudo make menuconfig
sudo make
