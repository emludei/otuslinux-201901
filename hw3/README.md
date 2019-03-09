# LVM homework

* Create temp logical volume for root (`/`), create filesystem for that volume and mount it to `/mnt`:

```bash
[vagrant@lvm ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[vagrant@lvm ~]$ sudo vgcreate temp_root /dev/sdb
  Volume group "temp_root" successfully created
[vagrant@lvm ~]$ sudo lvcreate -l 100%FREE -n lv_temp_root /dev/temp_root
  Logical volume "lv_temp_root" created.

[vagrant@lvm ~]$ sudo mkfs.xfs /dev/temp_root/lv_temp_root
meta-data=/dev/temp_root/lv_temp_root isize=512    agcount=4, agsize=1310464 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=5241856, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[vagrant@lvm ~]$ sudo mount /dev/temp_root/lv_temp_root /mnt
```

* Install `xfsdump` package and dump current root (`/`) to our temp volume:

```bash
[vagrant@lvm ~]$ sudo yum install -y xfsdump
...

[vagrant@lvm ~]$ sudo xfsdump -J - /dev/VolGroup00/LogVol00 | sudo xfsrestore -J - /mnt
...
xfsrestore: restore complete: 369 seconds elapsed
xfsrestore: Restore Status: SUCCESS

[vagrant@lvm ~]$ ll /mnt/
total 12
lrwxrwxrwx.  1 root    root       7 Mar  2 20:52 bin -> usr/bin
drwxr-xr-x.  2 root    root       6 May 12  2018 boot
drwxr-xr-x.  2 root    root       6 May 12  2018 dev
drwxr-xr-x. 79 root    root    8192 Mar  2 20:17 etc
drwxr-xr-x.  3 root    root      21 May 12  2018 home
lrwxrwxrwx.  1 root    root       7 Mar  2 20:52 lib -> usr/lib
lrwxrwxrwx.  1 root    root       9 Mar  2 20:52 lib64 -> usr/lib64
drwxr-xr-x.  2 root    root       6 Apr 11  2018 media
drwxr-xr-x.  2 root    root       6 Apr 11  2018 mnt
drwxr-xr-x.  2 root    root       6 Apr 11  2018 opt
drwxr-xr-x.  2 root    root       6 May 12  2018 proc
dr-xr-x---.  3 root    root     149 Mar  2 20:17 root
drwxr-xr-x.  2 root    root       6 May 12  2018 run
lrwxrwxrwx.  1 root    root       8 Mar  2 20:52 sbin -> usr/sbin
drwxr-xr-x.  2 root    root       6 Apr 11  2018 srv
drwxr-xr-x.  2 root    root       6 May 12  2018 sys
drwxrwxrwt.  8 root    root     172 Mar  2 20:51 tmp
drwxr-xr-x. 13 root    root     144 May 12  2018 usr
drwxrwxr-x.  3 vagrant vagrant   57 Mar  2 20:12 vagrant
drwxr-xr-x. 18 root    root     226 Mar  2 20:13 var
```

* Change root (`/`), update grub config:

```bash
[vagrant@lvm ~]$ sudo -i
[root@lvm ~]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
[root@lvm ~]# sudo chroot /mnt/
[root@lvm /]# grub2-mkconfig -o /boot/grub2/grub.cfg 
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done

```

* Create initial ramdisk image:

```bash
[root@lvm /]# cd /boot/
[root@lvm boot]# ls
config-3.10.0-862.2.3.el7.x86_64  grub   initramfs-3.10.0-862.2.3.el7.x86_64.img  System.map-3.10.0-862.2.3.el7.x86_64
efi                               grub2  symvers-3.10.0-862.2.3.el7.x86_64.gz     vmlinuz-3.10.0-862.2.3.el7.x86_64
[root@lvm boot]# dracut -v initramfs-3.10.0-862.2.3.el7.x86_64.img 3.10.0-862.2.3.el7.x86_64 --force
Executing: /sbin/dracut -v initramfs-3.10.0-862.2.3.el7.x86_64.img 3.10.0-862.2.3.el7.x86_64 --force
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
dracut module 'busybox' will not be installed, because command 'busybox' could not be found!
dracut module 'crypt' will not be installed, because command 'cryptsetup' could not be found!
dracut module 'dmraid' will not be installed, because command 'dmraid' could not be found!
dracut module 'dmsquash-live-ntfs' will not be installed, because command 'ntfs-3g' could not be found!
dracut module 'multipath' will not be installed, because command 'multipath' could not be found!
*** Including module: bash ***
*** Including module: nss-softokn ***
*** Including module: i18n ***
*** Including module: drm ***
*** Including module: plymouth ***
*** Including module: dm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 60-persistent-storage-dm.rules
Skipping udev rule: 55-dm.rules
*** Including module: kernel-modules ***
Omitting driver floppy
*** Including module: lvm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 56-lvm.rules
Skipping udev rule: 60-persistent-storage-lvm.rules
*** Including module: qemu ***
*** Including module: resume ***
*** Including module: rootfs-block ***
*** Including module: terminfo ***
*** Including module: udev-rules ***
Skipping udev rule: 40-redhat-cpu-hotplug.rules
Skipping udev rule: 91-permissions.rules
*** Including module: biosdevname ***
*** Including module: systemd ***
*** Including module: usrmount ***
*** Including module: base ***
*** Including module: fs-lib ***
*** Including module: shutdown ***
*** Including modules done ***
*** Installing kernel module dependencies and firmware ***
*** Installing kernel module dependencies and firmware done ***
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Generating early-microcode cpio image contents ***
*** No early-microcode cpio image needed ***
*** Store current command line parameters ***
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-862.2.3.el7.x86_64.img' done ***


```

* Change `rd.lvm.lv=VolGroup00/LogVol00` to `rd.lvm.lv=temp_root/lv_temp_root` in `/boot/grub2/grub.cfg` via `vi`.

* Reboot system:

```bash
[root@lvm boot]# exit 
[root@lvm ~]# shutdown -r now
...

[vagrant@lvm ~]$ lsblk 
NAME                     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                        8:0    0   40G  0 disk 
├─sda1                     8:1    0    1M  0 part 
├─sda2                     8:2    0    1G  0 part /boot
└─sda3                     8:3    0   39G  0 part 
  ├─VolGroup00-LogVol00  253:1    0 37.5G  0 lvm  
  └─VolGroup00-LogVol01  253:2    0  1.5G  0 lvm  [SWAP]
sdb                        8:16   0   20G  0 disk 
└─temp_root-lv_temp_root 253:0    0   20G  0 lvm  /
sdc                        8:32   0    2G  0 disk 
sdd                        8:48   0    2G  0 disk 
sde                        8:64   0    1G  0 disk 
sdf                        8:80   0    1G  0 disk
```

* Remove old (40GB) and create new logic volume (8GB) for root (`/`):

```bash
[vagrant@lvm ~]$ sudo lvremove -y /dev/VolGroup00/LogVol00 
  Logical volume "LogVol00" successfully removed
[vagrant@lvm ~]$ sudo lvcreate -n LogVol00 -L 8GB -y /dev/VolGroup00
  Wiping xfs signature on /dev/VolGroup00/LogVol00.
  Logical volume "LogVol00" created.
[vagrant@lvm ~]$ sudo mkfs.xfs /dev/VolGroup00/LogVol00 
meta-data=/dev/VolGroup00/LogVol00 isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

* Dump root (`/`) to new logical volume (8GB):

```bash
[vagrant@lvm ~]$ sudo mount /dev/VolGroup00/LogVol00 /mnt/
[vagrant@lvm ~]$ sudo xfsdump -J - /dev/temp_root/lv_temp_root | sudo xfsrestore -J - /mnt/
...
xfsdump: dump complete: 15 seconds elapsed
xfsdump: Dump Status: SUCCESS
xfsrestore: restore complete: 15 seconds elapsed
xfsrestore: Restore Status: SUCCESS
```


