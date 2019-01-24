#!/bin/bash
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
apt-get -y install git
apt-get -y install wget

git clone https://github.com/fahawifi/openwrt-cc.git
chmod +x openwrt-cc
mkdir openwrt-cc/files
cd openwrt-cc
tar -zxvf fmk_099.tar.gz
cd fmk
echo "BINWALK=binwalk" >> shared-ng.inc
./extract-firmware.sh ../upgrade-2.4.2.bin

    cd
    cd home/unbuntu
    mkdir openwrt-cc/files
    cp -r fmk/fmk/rootfs/* openwrt-cc/files/
    rm -rf openwrt-cc/files/lib/modules/*
    rm -rf openwrt-cc/files/sbin/modprobe


install_scripts() {
    cd "$top/openwrt-cc"
    ./scripts/feeds update -a
    ./scripts/feeds install -a
}

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
