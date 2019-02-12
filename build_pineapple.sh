#!/bin/bash
#在livecd里操作，kali系统，不同系统路径会不同，主要是切换用户后路径变更
#nano 1
#chmod +x 1
#./1
#安装依赖和解固（fmk/fmk/rootfs/*）必须以root身份
#但是git等方式下载OpenWrt固件源码（直接可以刷到该路由，但没有大菠萝功能）和后期./scripts/feeds update -a开始安装都必须切换到普通用户，否则出错
sudo su
apt-get update
apt-get -y upgrade
apt -y install binwalk
apt-get -y install git-core
apt-get -y install build-essential
apt-get -y install zlib1g-dev
apt-get -y install liblzma-dev
apt-get -y install python-magic
apt-get -y install subversion
apt-get -y install build-essential
apt-get -y install git-core
apt-get -y install libncurses5-dev
apt-get -y install zlib1g-dev
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
apt-get -y install bison
apt-get -y install gcc-multilib
apt-get -y install flex
apt-get -y install gperf
apt-get -y install libc6-dev-i386

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
cd
cd /home/wei

#退出root身份，命令autossh(-p 22删除)登录后，在$状态下完成以下命令
#命令连接autossh(-p 22删除)
nano 2
chmod +x 2
./2

#以上中断，复制以下代码后保存为2，再执行该脚本
=============================================
#!/bin/bash

#下载该路由型号官网的openwrt源码，尽量原生和简洁

#浏览器下载git速度更快，解压并重命名放在Home主文件夹，也就是root
git clone https://github.com/fahawifi/openwrt-cc.git
mkdir openwrt-cc/files
cd
sudo chmod +x openwrt-cc

cd openwrt-cc
sudo chmod +x ./scripts/feeds
#feeds update在本地电脑非常慢，在vps快
sudo ./scripts/feeds update -a
#sudo ./scripts/feeds install -a
#sudo make menuconfig
#sudo make

cd openwrt-cc
#切换成root才有权限解固
tar -zxvf fmk_099.tar.gz
cd fmk
sudo echo "BINWALK=binwalk" >> shared-ng.inc
sudo ./extract-firmware.sh ../upgrade-2.4.2.bin
#把.bin改为.zip后缀，解压得到的文件和/fmk/fmk/rootfs里面的内容是一样的，放到openwrt-cc/files
#unzip -o -d /openwrt-cc/files upgrade-2.4.2.zip

sudo cp -r openwrt-cc/fmk/fmk/rootfs/* openwrt-cc/files/
sudo rm -rf openwrt-cc/files/lib/modules/*
sudo rm -rf openwrt-cc/files/sbin/modprobe

sudo ./scripts/feeds install -a
sudo make menuconfig
sudo make

