#!/usr/bin/env bash

mkdir qemu_files

wget https://downloads.raspberrypi.org/raspbian_lite_latest 
unzip raspbian_lite_latest -d qemu_files
rm raspbian_lite_latest 

wget http://www.buildroot.org/downloads/buildroot-2019.02.tar.bz2
tar xf buildroot-2019.02.tar.bz2

cd buildroot-2019.02/
make qemu_arm_vexpress_defconfig
make

cp output/images/zImage ../qemu_files/
cp output/images/vexpress-v2p-ca9.dtb ../qemu_files/

cd ..
rm -rf buildroot-2019.02
rm buildroot-2019.02.tar.bz2
