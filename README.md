# Raspbian on QEMU with ARMv7

Emulate Raspbian on QEMU with ARMv7 using Buildroot to configure your kernel and set a Python environment to run scripts using Keras on Tensorflow.

## TL;DR

Use the Shell scripts at root (you may need to enable execution with `chmod +x <script>.sh`). Details of what's happening in these scripts are in sections below.

- To download and build files, run the following script:

```
./download_and_build.sh
```

- To run Raspbian on QEMU using created files, run the following script:

```
./run_raspbian_on_qemu.sh
```

## Download and build files

Download and unzip the image of Raspbian (the version fetched here is the `lite`, you may switch to what you need):

```
wget http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2018-11-15/2018-11-13-raspbian-stretch-lite.zip
unzip 2018-11-13-raspbian-stretch-lite.zip
```

Download and untar Buildroot package:

```
wget http://www.buildroot.org/downloads/buildroot-2019.02.tar.bz2
tar xf buildroot-2019.02.tar.bz2
```

Set Buildroot configuration file to build QEMU ARM using V-Express and start:

```
cd buildroot-2019.02/
make qemu_arm_vexpress_defconfig
make
```

Output files are located in the `output/images` folder. 
This will create default `rootfs`, the kernel to be used `zImage` and the DTB `vexpress-v2p-ca9.dtb`.

You now have everything needed to start Raspbian on QEMU.


## Start Raspbian on QEMU

Install QEMU if needed an run the following command (if needed, adapt the path to local files):

```
qemu-system-arm \
        -M vexpress-a9 \
        -m 256 \
        -kernel vexpress/zImage \
        -dtb vexpress/vexpress-v2p-ca9.dtb \
        -sd 2018-11-13-raspbian-stretch.img \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2" \
        -serial stdio \
        -net nic -net user,hostfwd=tcp::2222-:22
```

If everything went well, Raspbian should boot (default username and password of Raspbian are `pi` and `raspberry` respectively).

You may enable SSH using `sudo raspi-config` from Raspbian, go to `Interfacing Options`, `SSH` and select `<Yes>`.
After that, you may access your emulated Raspbian machine using SSH from your local OS:

```
ssh -p 2222 pi@localhost
```

Password is required to establish connection.

## Resize Pi's filesystem
On the host, run 
```
qemu-img resize <image_name>.img +<size>G
```
Then, on the PI, run 
```
sudo fdisk /dev/mmcblk0
```

fdisk is in interactive mode by default. Run sequentially : 
```
>p  #Get the first segment for /dev/mmcblk0p2 (probably 98304)
>d
>2
>n
>2
>p
>98304
>w
```
then reboot the pi
```
sudo reboot -h now
```
then, on the pi, run 
```
sudo resize2fs /dev/mmcblk0p2
```
Now your Pi has more space on filesystem

## Ansible

Be careful to update the file ```ansible/inventories/hosts ``` with the right password for the pi.
To launch playbooks, at the root of the project, run
```
ansible-playbook -i ansible/inventories ansible/<name_of_playbook.yml>
```
You need to first connect to the pi through ssh

## Integration test 
Copy the files in ```data_for_integration_test``` on the pi (scp for example)
Copy the image in ```qemu_files``` you want to boot on the pi (with dd for example)
Boot the Pi
Run the code, with python3 interpreter, in ```snippet_integration.py```. Please be careful with paths for model and images
