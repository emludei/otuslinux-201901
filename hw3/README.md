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

* Change root (`/`) and update grub config:

```bash
[vagrant@lvm ~]$ sudo -i
[root@lvm ~]# for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
[root@lvm ~]# chroot /mnt/
[root@lvm /]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-862.2.3.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img
done
```

* Create initial ramdisk image again:

```bash
[root@lvm /]# cd boot/
[root@lvm boot]# dracut -v initramfs-3.10.0-862.2.3.el7.x86_64.img 3.10.0-862.2.3.el7.x86_64 --force
...
*** Creating image file ***
*** Creating image file done ***
*** Creating initramfs image file '/boot/initramfs-3.10.0-862.2.3.el7.x86_64.img' done ***
```

* Create logical volume with mirroring (for `/var`):

```bash
[root@lvm boot]# pvcreate /dev/sdc /dev/sdd
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdd" successfully created.
[root@lvm boot]# vgcreate vg_var /dev/sdc /dev/sdd
  Volume group "vg_var" successfully created
[root@lvm boot]# lvcreate -L 1GB -m1 -n lv_var vg_var
  Logical volume "lv_var" created.
```

* Move data from current `/var` to new logical volume:

```bash
[root@lvm boot]# mkfs.ext4 /dev/vg_var/lv_var 
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 262144 blocks
13107 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268435456
8 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

[root@lvm boot]# mount /dev/vg_var/lv_var /mnt/
[root@lvm boot]# cp -aR /var/* /mnt/
[root@lvm boot]# rm -Rf /var/*
[root@lvm boot]# umount /mnt/
[root@lvm boot]# mount /dev/vg_var/lv_var /var/
[root@lvm boot]# ls /var/
adm  cache  db  empty  games  gopher  kerberos  lib  local  lock  log  lost+found  mail  nis  opt  preserve  run  spool  tmp  yp
```

* Update `/etc/fstab`, add automounting of var logical volume to `/var`:

```bash
[root@lvm boot]# echo "`blkid -s UUID /dev/mapper/vg_var-lv_var | awk '{ print $2 }'`    /var    ext4    rw,auto,exec,async,nouser,nosuid,noatime,nodiratime,nodev    0    2" >> /etc/fstab 
```

* Reboot system:

```bash
[root@lvm boot]# exit
exit
[root@lvm ~]# shutdown -r now
...
[vagrant@lvm ~]$ lsblk 
NAME                     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                        8:0    0   40G  0 disk 
├─sda1                     8:1    0    1M  0 part 
├─sda2                     8:2    0    1G  0 part /boot
└─sda3                     8:3    0   39G  0 part 
  ├─VolGroup00-LogVol00  253:0    0    8G  0 lvm  /
  └─VolGroup00-LogVol01  253:1    0  1.5G  0 lvm  [SWAP]
sdb                        8:16   0   20G  0 disk 
└─temp_root-lv_temp_root 253:2    0   20G  0 lvm  
sdc                        8:32   0    2G  0 disk 
├─vg_var-lv_var_rmeta_0  253:3    0    4M  0 lvm  
│ └─vg_var-lv_var        253:7    0    1G  0 lvm  /var
└─vg_var-lv_var_rimage_0 253:4    0    1G  0 lvm  
  └─vg_var-lv_var        253:7    0    1G  0 lvm  /var
sdd                        8:48   0    2G  0 disk 
├─vg_var-lv_var_rmeta_1  253:5    0    4M  0 lvm  
│ └─vg_var-lv_var        253:7    0    1G  0 lvm  /var
└─vg_var-lv_var_rimage_1 253:6    0    1G  0 lvm  
  └─vg_var-lv_var        253:7    0    1G  0 lvm  /var
sde                        8:64   0    1G  0 disk 
sdf                        8:80   0    1G  0 disk 
```

* Remove temp root volume:

```bash
[vagrant@lvm ~]$ sudo lvremove -y /dev/temp_root/lv_temp_root
  Logical volume "lv_temp_root" successfully removed
[vagrant@lvm ~]$ sudo vgremove  /dev/temp_root
  Volume group "temp_root" successfully removed
[vagrant@lvm ~]$ sudo pvremove /dev/sdb
  Labels on physical volume "/dev/sdb" successfully wiped.
```

* Create volume for `/home` directory:

```bash
[vagrant@lvm ~]$ sudo lvcreate -L 4GB -n LogVol_Home /dev/VolGroup00
  Logical volume "LogVol_Home" created.
[vagrant@lvm ~]$ sudo mkfs.ext4 /dev/VolGroup00/LogVol_Home 
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
262144 inodes, 1048576 blocks
52428 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=1073741824
32 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
```

* Move data from current `/home` to `LogVol_Home` volume, and mount it to `/home`:

```bash
[vagrant@lvm ~]$ sudo mount /dev/VolGroup00/LogVol_Home /mnt/
[vagrant@lvm ~]$ sudo cp -aR /home/* /mnt/
[vagrant@lvm ~]$ sudo rm -Rf /home/*
[vagrant@lvm ~]$ sudo umount /mnt/
[vagrant@lvm ~]$ sudo mount /dev/VolGroup00/LogVol_Home /home/
[vagrant@lvm ~]$ echo "`sudo blkid -s UUID /dev/mapper/VolGroup00-LogVol_Home | awk '{ print $2 }'`    /home    ext4    rw,auto,exec,async,nouser,nosuid,noatime,nodiratime,nodev    0    2" | sudo tee --append /etc/fstab > /dev/null 
```

* Generate files in `home`:

```bash
[vagrant@lvm ~]$ sudo touch /home/file{1..100}
[vagrant@lvm ~]$ ls /home/
file1    file13  file18  file22  file27  file31  file36  file40  file45  file5   file54  file59  file63  file68  file72  file77  file81  file86  file90  file95  lost+found
file10   file14  file19  file23  file28  file32  file37  file41  file46  file50  file55  file6   file64  file69  file73  file78  file82  file87  file91  file96  vagrant
file100  file15  file2   file24  file29  file33  file38  file42  file47  file51  file56  file60  file65  file7   file74  file79  file83  file88  file92  file97
file11   file16  file20  file25  file3   file34  file39  file43  file48  file52  file57  file61  file66  file70  file75  file8   file84  file89  file93  file98
file12   file17  file21  file26  file30  file35  file4   file44  file49  file53  file58  file62  file67  file71  file76  file80  file85  file9   file94  file99
```

* Create snapshot:

```bash
[vagrant@lvm ~]$ sudo lvcreate -L 1GB -s -n home_snapshot_001 /dev/VolGroup00/LogVol_Home
  Logical volume "home_snapshot_001" created.
[vagrant@lvm ~]$ sudo lvs
  LV                VG         Attr       LSize Pool Origin      Data%  Meta%  Move Log Cpy%Sync Convert
  LogVol00          VolGroup00 -wi-ao---- 8.00g                                                         
  LogVol01          VolGroup00 -wi-ao---- 1.50g                                                         
  LogVol_Home       VolGroup00 owi-aos--- 4.00g                                                         
  home_snapshot_001 VolGroup00 swi-a-s--- 1.00g      LogVol_Home 0.01                                   
  lv_var            vg_var     rwi-aor--- 1.00g                                         100.00 
```

* Remove some files from `home`:

```bash
[vagrant@lvm ~]$ sudo rm -Rf /home/file{20..80}
[vagrant@lvm ~]$ ls /home/
file1   file100  file12  file14  file16  file18  file2  file4  file6  file8   file82  file84  file86  file88  file9   file91  file93  file95  file97  file99      vagrant
file10  file11   file13  file15  file17  file19  file3  file5  file7  file81  file83  file85  file87  file89  file90  file92  file94  file96  file98  lost+found
```

* Restoring from snapshot:

```bash
[vagrant@lvm ~]$ sudo umount /home
[vagrant@lvm ~]$ sudo lvconvert --merge /dev/VolGroup00/home_snapshot_001 
  Merging of volume VolGroup00/home_snapshot_001 started.
  VolGroup00/LogVol_Home: Merged: 100.00%

[vagrant@lvm ~]$ sudo mount /home
[vagrant@lvm ~]$ ls /home/
file1    file13  file18  file22  file27  file31  file36  file40  file45  file5   file54  file59  file63  file68  file72  file77  file81  file86  file90  file95  lost+found
file10   file14  file19  file23  file28  file32  file37  file41  file46  file50  file55  file6   file64  file69  file73  file78  file82  file87  file91  file96  vagrant
file100  file15  file2   file24  file29  file33  file38  file42  file47  file51  file56  file60  file65  file7   file74  file79  file83  file88  file92  file97
file11   file16  file20  file25  file3   file34  file39  file43  file48  file52  file57  file61  file66  file70  file75  file8   file84  file89  file93  file98
file12   file17  file21  file26  file30  file35  file4   file44  file49  file53  file58  file62  file67  file71  file76  file80  file85  file9   file94  file99
```

* Install zfs (kABI-tracking kmod):

```bash
[vagrant@lvm ~]$ sudo yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_5.noarch.rpm
[vagrant@lvm ~]$ sudo vi /etc/yum.repos.d/zfs.repo
[vagrant@lvm ~]$ head -n 15 /etc/yum.repos.d/zfs.repo
[zfs]
name=ZFS on Linux for EL7 - dkms
baseurl=http://download.zfsonlinux.org/epel/7.5/$basearch/
enabled=0
metadata_expire=7d
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux

[zfs-kmod]
name=ZFS on Linux for EL7 - kmod
baseurl=http://download.zfsonlinux.org/epel/7.5/kmod/$basearch/
enabled=1
metadata_expire=7d
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux

[vagrant@lvm ~]$ sudo yum install zfs
[vagrant@lvm ~]$ sudo modprobe zfs
```

* Create zfs mirror:

```bash
[vagrant@lvm ~]$ sudo zpool create zmirror mirror sde sdf
[vagrant@lvm ~]$ sudo touch /zmirror/file{1..100}
[vagrant@lvm ~]$ ls /zmirror/
file1    file13  file18  file22  file27  file31  file36  file40  file45  file5   file54  file59  file63  file68  file72  file77  file81  file86  file90  file95
file10   file14  file19  file23  file28  file32  file37  file41  file46  file50  file55  file6   file64  file69  file73  file78  file82  file87  file91  file96
file100  file15  file2   file24  file29  file33  file38  file42  file47  file51  file56  file60  file65  file7   file74  file79  file83  file88  file92  file97
file11   file16  file20  file25  file3   file34  file39  file43  file48  file52  file57  file61  file66  file70  file75  file8   file84  file89  file93  file98
file12   file17  file21  file26  file30  file35  file4   file44  file49  file53  file58  file62  file67  file71  file76  file80  file85  file9   file94  file99

[vagrant@lvm ~]$ sudo zpool status zmirror
  pool: zmirror
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	zmirror     ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sde     ONLINE       0     0     0
	    sdf     ONLINE       0     0     0

errors: No known data errors

[vagrant@lvm ~]$ lsblk
NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                          8:0    0   40G  0 disk 
├─sda1                       8:1    0    1M  0 part 
├─sda2                       8:2    0    1G  0 part /boot
└─sda3                       8:3    0   39G  0 part 
  ├─VolGroup00-LogVol00    253:0    0    8G  0 lvm  /
  ├─VolGroup00-LogVol01    253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol_Home 253:2    0    4G  0 lvm  /home
sdb                          8:16   0   20G  0 disk 
sdc                          8:32   0    2G  0 disk 
├─vg_var-lv_var_rmeta_0    253:3    0    4M  0 lvm  
│ └─vg_var-lv_var          253:7    0    1G  0 lvm  /var
└─vg_var-lv_var_rimage_0   253:4    0    1G  0 lvm  
  └─vg_var-lv_var          253:7    0    1G  0 lvm  /var
sdd                          8:48   0    2G  0 disk 
├─vg_var-lv_var_rmeta_1    253:5    0    4M  0 lvm  
│ └─vg_var-lv_var          253:7    0    1G  0 lvm  /var
└─vg_var-lv_var_rimage_1   253:6    0    1G  0 lvm  
  └─vg_var-lv_var          253:7    0    1G  0 lvm  /var
sde                          8:64   0    1G  0 disk 
├─sde1                       8:65   0 1014M  0 part 
└─sde9                       8:73   0    8M  0 part 
sdf                          8:80   0    1G  0 disk 
├─sdf1                       8:81   0 1014M  0 part 
└─sdf9                       8:89   0    8M  0 part

[vagrant@lvm ~]$ sudo mount | grep zfs
zmirror on /zmirror type zfs (rw,seclabel,xattr,noacl)

[vagrant@lvm ~]$ sudo zpool list
NAME      SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
zmirror  1008M   166K  1008M         -     0%     0%  1.00x  ONLINE  -

[vagrant@lvm ~]$ zfs get mounted
NAME     PROPERTY  VALUE    SOURCE
zmirror  mounted   yes      -

[vagrant@lvm ~]$ zfs get mountpoint
NAME     PROPERTY    VALUE       SOURCE
zmirror  mountpoint  /zmirror    default
```

* Change mountpoint:

```bash
[vagrant@lvm ~]$ sudo zfs set mountpoint=/opt zmirror
[vagrant@lvm ~]$ ls /opt/
file1    file13  file18  file22  file27  file31  file36  file40  file45  file5   file54  file59  file63  file68  file72  file77  file81  file86  file90  file95
file10   file14  file19  file23  file28  file32  file37  file41  file46  file50  file55  file6   file64  file69  file73  file78  file82  file87  file91  file96
file100  file15  file2   file24  file29  file33  file38  file42  file47  file51  file56  file60  file65  file7   file74  file79  file83  file88  file92  file97
file11   file16  file20  file25  file3   file34  file39  file43  file48  file52  file57  file61  file66  file70  file75  file8   file84  file89  file93  file98
file12   file17  file21  file26  file30  file35  file4   file44  file49  file53  file58  file62  file67  file71  file76  file80  file85  file9   file94  file99
```

* Create partition for cache:

```bash
[vagrant@lvm ~]$ sudo parted -s /dev/sdb mklabel gpt
[vagrant@lvm ~]$ sudo parted -s /dev/sdb mkpart primary ext4 0 1024
Warning: The resulting partition is not properly aligned for best performance.
[vagrant@lvm ~]$ lsblk
NAME                       MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                          8:0    0    40G  0 disk 
├─sda1                       8:1    0     1M  0 part 
├─sda2                       8:2    0     1G  0 part /boot
└─sda3                       8:3    0    39G  0 part 
  ├─VolGroup00-LogVol00    253:0    0     8G  0 lvm  /
  ├─VolGroup00-LogVol01    253:1    0   1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol_Home 253:7    0     4G  0 lvm  /home
sdb                          8:16   0    20G  0 disk 
└─sdb1                       8:17   0 976.6M  0 part 
sdc                          8:32   0     2G  0 disk 
├─vg_var-lv_var_rmeta_0    253:2    0     4M  0 lvm  
│ └─vg_var-lv_var          253:6    0     1G  0 lvm  /var
└─vg_var-lv_var_rimage_0   253:3    0     1G  0 lvm  
  └─vg_var-lv_var          253:6    0     1G  0 lvm  /var
sdd                          8:48   0     2G  0 disk 
├─vg_var-lv_var_rmeta_1    253:4    0     4M  0 lvm  
│ └─vg_var-lv_var          253:6    0     1G  0 lvm  /var
└─vg_var-lv_var_rimage_1   253:5    0     1G  0 lvm  
  └─vg_var-lv_var          253:6    0     1G  0 lvm  /var
sde                          8:64   0     1G  0 disk 
├─sde1                       8:65   0  1014M  0 part 
└─sde9                       8:73   0     8M  0 part 
sdf                          8:80   0     1G  0 disk 
├─sdf1                       8:81   0  1014M  0 part 
└─sdf9                       8:89   0     8M  0 part 
```

* Add partition `/dev/sdb1` to zpool `zmirror` as cache:

```bash
[vagrant@lvm ~]$ sudo zpool add zmirror cache sdb1
[vagrant@lvm ~]$ zpool status zmirror
  pool: zmirror
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	zmirror     ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sde     ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	cache
	  sdb1      ONLINE       0     0     0

errors: No known data errors
```

* Create snapshot of `zmirror` and restore `zmirror` from it:

```bash
[vagrant@lvm ~]$ sudo zfs snapshot zmirror@snap001
[vagrant@lvm ~]$ ls /opt/.zfs/snapshot/snap001/
file1    file13  file18  file22  file27  file31  file36  file40  file45  file5   file54  file59  file63  file68  file72  file77  file81  file86  file90  file95
file10   file14  file19  file23  file28  file32  file37  file41  file46  file50  file55  file6   file64  file69  file73  file78  file82  file87  file91  file96
file100  file15  file2   file24  file29  file33  file38  file42  file47  file51  file56  file60  file65  file7   file74  file79  file83  file88  file92  file97
file11   file16  file20  file25  file3   file34  file39  file43  file48  file52  file57  file61  file66  file70  file75  file8   file84  file89  file93  file98
file12   file17  file21  file26  file30  file35  file4   file44  file49  file53  file58  file62  file67  file71  file76  file80  file85  file9   file94  file99

[vagrant@lvm ~]$ sudo rm /opt/file{4..98}
[vagrant@lvm ~]$ ls /opt/
file1  file100  file2  file3  file99

[vagrant@lvm ~]$ sudo zfs rollback zmirror@snap001
[vagrant@lvm ~]$ ls /opt/
file1    file13  file18  file22  file27  file31  file36  file40  file45  file5   file54  file59  file63  file68  file72  file77  file81  file86  file90  file95
file10   file14  file19  file23  file28  file32  file37  file41  file46  file50  file55  file6   file64  file69  file73  file78  file82  file87  file91  file96
file100  file15  file2   file24  file29  file33  file38  file42  file47  file51  file56  file60  file65  file7   file74  file79  file83  file88  file92  file97
file11   file16  file20  file25  file3   file34  file39  file43  file48  file52  file57  file61  file66  file70  file75  file8   file84  file89  file93  file98
file12   file17  file21  file26  file30  file35  file4   file44  file49  file53  file58  file62  file67  file71  file76  file80  file85  file9   file94  file99
```