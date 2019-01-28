#!/bin/bash
#在livecd里操作
#安装依赖和解固（fmk/fmk/rootfs/*）必须以root身份
#但是git等方式下载OpenWrt固件源码（直接可以刷到该路由，但没有大菠萝功能）和后期./scripts/feeds update -a开始安装都必须切换到普通用户，否则出错

apt-get update
apt -y install binwalk
apt-get  install git-core
apt-get  -y install build-essential
apt-get  -y install zlib1g-dev
apt-get  -y install liblzma-dev
apt-get  -y install python-magic
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
apt-get -y install make
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

#退出root，以普通用户身份（#变$）执行下面的下载源码命令
useradd -m linshiname
passwd linshiname
usermod -a -G sudo linshiname
chsh -s /bin/bash linshiname
#切换成普通用户username
su linshiname
sudo nano 2
sudo chmod +x 2
sudo ./2

#以上中断，复制以下代码后保存为2，再执行该脚本
=============================================
#!/bin/bash

#sudo chmod +x 2
#sudo ./2
#下载该路由型号官网的openwrt源码，尽量原生和简洁
cd root
#浏览器下载git速度更快，解压并重命名放在Home主文件夹，也就是root
#sudo git clone https://github.com/fahawifi/openwrt-cc.git
cd openwrt-cc
tar -zxvf fmk_099.tar.gz
sudo cd fmk
sudo echo "BINWALK=binwalk" >> shared-ng.inc
sudo ./extract-firmware.sh ../upgrade-2.4.2.bin


cd ..
#切换成普通用户username
su linshiname
sudo chmod +x openwrt-cc
sudo mkdir openwrt-cc/files
sudo cp -r openwrt-cc/fmk/fmk/rootfs/* openwrt-cc/files/
sudo rm -rf openwrt-cc/files/lib/modules/*
sudo rm -rf openwrt-cc/files/sbin/modprobe

cd openwrt-cc
sudo ./scripts/feeds update -a
sudo ./scripts/feeds install -a
sudo make menuconfig
sudo make

build_firmware() {
    cd "$top/openwrt-cc"
    make -j$(cat /proc/cpuinfo | grep "^processor" | wc -l)
    for line in $(find "$top/openwrt-cc/bin" -name "*-sysupgrade.bin"); do
        cp "$line" "$top/firmware_images/"
        echo " - [*] File ready at - $line"
    done
   cd "$top"
}

full_build() {
    upstream_version=`curl -s https://www.wifipineapple.com/downloads/nano/ | \
            python -c "import sys, json; print(json.load(sys.stdin)['version'])"`
    current_version=`cat configs/.upstream_version`

    if [ -f "configs/.upstream_version" ]; then
        echo "config file found"
        git submodule update
    else
        echo "config file not found"
        first_run
    fi

    if [ "$upstream_version" < "$current_version" ]; then
        extract_firmware
    fi

    install_scripts

    make defconfig
    build_firmware
}

if [ "$1" = "-f" ]; then
    rm configs/.upstream_version
    full_build
elif
    [ "$1" = "-c" ]; then
    rm -rf firmware_images
    rm -rf firmware-mod-kit/fmk
    cd openwrt-cc
    make dirclean
    # do I need sudo doe?
    rm -rf files
    cd ..
elif
    [ -z "$1" ]; then
    full_build
fi
