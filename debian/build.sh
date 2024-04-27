#!/bin/bash

BUILD_HOME=`pwd`
tmp_workspace="../../build_iso/"

# 删除已经存在的workspace目录
if [ -d "$tmp_workspace" ]; then
    echo "$tmp_workspace 已经目录存在，正在删除..."
    rm -rf $tmp_workspace
    echo "目录已删除"
fi

SCRIPT_PATH=`pwd`

# 重新创建并进入 workspace 目录
mkdir ${tmp_workspace}
cd ${tmp_workspace}

#记录workspace的绝对路径
WORKSPACE_DIR=`pwd`
echo "workspace 绝对路径："$WORKSPACE_DIR

lb config \
	--color \
	--apt-options "--yes -o APT::Install-Recommends=false"\
	--distribution bookworm \
	--architectures amd64 \
	--archive-areas "main contrib non-free non-free-firmware"\
	--bootappend-live "boot=live components" \
    	--debian-installer live \
    	--debian-installer-distribution bookworm \
    	--debian-installer-gui true \
    	--iso-application "Cutefish" \
    	--iso-publisher "Cutefish Project" \
    	--iso-volume "Cutefish Live" \
    	--linux-packages "linux-image linux-headers" \
    	--uefi-secure-boot enable \

cd ${BUILD_HOME}
# 复制cutefish安装包
CUTEFISH_SRC_PATH=../cutefish_desktop/cutefish_packages/debs/
CUTEFISH_DEPEND_PATH=./depends/
CUTEFIHS_DEST_PATH=${tmp_workspace}/config/packages.chroot/
cp ${CUTEFISH_SRC_PATH}/*.deb ${CUTEFIHS_DEST_PATH}
rm ${CUTEFISH_DEST_PATH}/*build-deps*
#cp ${CUTEFISH_DEPEND_PATH}/*.deb ${CUTEFIHS_DEST_PATH}
	
# 配置cutefish相关依赖包
cp ./package/cutefish.list.chroot ${tmp_workspace}/config/package-lists/
cp ./package/qt.list.chroot ${tmp_workspace}/config/package-lists/


cd ${WORKSPACE_DIR}
#lb build > err.log 2>&1
lb build | tee ${BUILD_HOME}/err.log

exit
