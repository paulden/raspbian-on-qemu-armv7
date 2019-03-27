#!/usr/bin/env bash

qemu-system-arm \
        -M vexpress-a9 \
        -m 256 \
        -kernel qemu_files/zImage \
        -dtb qemu_files/vexpress-v2p-ca9.dtb \
        -sd qemu_files/2018-11-13-raspbian-stretch.img \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2" \
        -serial stdio \
        -net nic -net user,hostfwd=tcp::2222-:22
