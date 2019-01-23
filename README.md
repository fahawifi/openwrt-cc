已修改：/openwrt-cc/include/prereq-build.mk



This is the buildsystem for OpenWrt CC1505 with updated GLI patches,
including GL-AR150, GL-AR300, GL-Domino, GL-MT300N, GL-MT300A, GL-MT750

Patches has been applied. Just use "make menuconfig" to configure your appreciated
configuration for the toolchain and firmware.

To build your own firmware you need to have access to a Linux, BSD or MacOSX system
(case-sensitive filesystem required). Cygwin will not be supported because of
the lack of case sensitiveness in the file system.


#Use in Ubuntu

$ git clone https://github.com/fahawifi/openwrt-cc.git
#不管git哪个openwrt项目，后面的命令都是完全一致的
$ sudo apt-get update
$ sudo apt-get install subversion build-essential git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip git wget
$ chmod +x openwrt-cc
$ cd openwrt-cc
$ ./scripts/feeds update -a
$ ./scripts/feeds install -a
$ make menuconfig
  ..choose your compile target and packages
$ make
```
#./scripts/feeds install -a安装依赖时出错说明
1.Checking 'svn'... failed，但是apt-get install subversion显示已安装最新版本，原因是openwrt-cc所在目录包含中文，全英文路径就自动ok
2.已修改。Checking 'git'... failed.由于OpenWRT对git版本的检测方式有缺陷导致
先命令查看git版本的判断命令。
git --version
修改文件/openwrt-cc/include/prereq-build.mk
把里面的
----------------------------
$(eval $(call SetupHostCommand,git,Please install Git (git-core) >= 1.6.5, \
git clone 2>&1 | grep -- --recursive))
改为：
$(eval $(call SetupHostCommand,git,Please install Git (git-core) >= 1.7.12.2, \
	git –exec-path | xargs -I % – grep -q – –recursive %/git-submodule))
----------------------------


