#!/bin/bash
#nano 1
#chmod +x 1
#./1
#安装依赖和解固（fmk/fmk/rootfs/*）必须以root身份
#但是git等方式下载OpenWrt固件源码（直接可以刷到该路由，但没有大菠萝功能）和后期./scripts/feeds update -a开始安装都必须切换到普通用户，否则出错

#下载该路由型号官网的openwrt源码，尽量原生和简洁
#这部分依赖需在本地电脑用酸酸乳挂代理完成更新后压缩在上传到vps，
#从本地压缩openwrt-cc目录并上传到vps，迅速
sudo git clone https://github.com/fahawifi/openwrt-cc.git
sudo mkdir openwrt-cc/files
cd openwrt-cc
#解压得到openwrt-cc/fmk文件夹，这是解压.bin格式路由固件的软件
sudo tar -zxvf fmk_099.tar.gz
sudo chmod +x ./scripts/feeds
sudo ./scripts/feeds update -a
sudo ./scripts/feeds install -a
#切换成root才有权限解固

#从本地压缩openwrt-cc目录并上传到vps
tar -zcvf openwrt-cc.tar.gz /root/openwrt-cc
cd
#上传连接到vps前，先删除root/.ssh/
rm -rf /root/.ssh/known_hosts
#上传本地电脑文件到vps,@后跟的ip要换，/home/ubuntu是vps的路径
#scp openwrt-cc.tar.gz ubuntu@111.231.253.82:/home/ubuntu
================================

#!/bin/bash
#从vps下载整个目录到 本地电脑root
#scp -r ubuntu@111.231.253.160:/home/ubuntu/openwrt-cc/files /root
#scp -r ubuntu@111.231.253.160:/home/ubuntu/openwrt-cc/feeds /root
sudo su
cd /home/ubuntu
sudo tar -zxvf openwrt-cc.tar.gz
#一个固件下列命令只需要一次就可以把openwrt-cc/files保存下来，下次固件更新只需要删除files重新操作一遍即可

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



cd openwrt-cc
sudo ./scripts/feeds install -a
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
cd openwrt-cc
sudo make menuconfig
sudo make
