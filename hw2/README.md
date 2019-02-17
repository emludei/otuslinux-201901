# Build RAID 10

* Add two disks to `Vagrantfile`:
```ruby
    :sata5 => {
        :dfile => './vmdisks/sata5.vdi',
        :size => 1024,
        :port => 5
      },
      :sata6 => {
        :dfile => './vmdisks/sata6.vdi',
        :size => 1024,
        :port => 6
      }
```

* Show all disk in vm using `lsblk`:

```bash
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda      8:0    0  40G  0 disk 
`-sda1   8:1    0  40G  0 part /
sdb      8:16   0   1G  0 disk 
sdc      8:32   0   1G  0 disk 
sdd      8:48   0   1G  0 disk 
sde      8:64   0   1G  0 disk 
sdf      8:80   0   1G  0 disk 
sdg      8:96   0   1G  0 disk
```

* Examine disks (whether there is already any raid existed?) `sudo mdadm -E /dev/sd{b,c,d,e,f,g}`:
```bash
[vagrant@otuslinux ~]$ sudo mdadm -E /dev/sd{b,c,d,e,f,g}
mdadm: No md superblock detected on /dev/sdb.
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.
mdadm: No md superblock detected on /dev/sde.
mdadm: No md superblock detected on /dev/sdf.
mdadm: No md superblock detected on /dev/sdg.
```

* Create RAID 10 on 6 devices `sudo mdadm --create --verbose /dev/md0 --level=10 --raid-devices=6 /dev/sd{b,c,d,e,f,g}`

* Check RAID status `cat /proc/mdstat`:
```bash
[vagrant@otuslinux ~]$ cat /proc/mdstat
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      3139584 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]
      
unused devices: <none>
```

* Examine disks `sudo mdadm -E /dev/sd{b,c,d,e,f,g}`:
```bash
[vagrant@otuslinux ~]$ sudo mdadm -E /dev/sd{b,c,d,e,f,g}
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : af451a4e:9386549d:33f4ec58:4cd98d82
           Name : otuslinux:0  (local to host otuslinux)
  Creation Time : Sun Feb 17 17:17:05 2019
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 3139584 (2.99 GiB 3.21 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : 2c3110ee:796dee94:c1039f67:9bb39e69

    Update Time : Sun Feb 17 17:17:14 2019
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 66897b04 - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : af451a4e:9386549d:33f4ec58:4cd98d82
           Name : otuslinux:0  (local to host otuslinux)
  Creation Time : Sun Feb 17 17:17:05 2019
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 3139584 (2.99 GiB 3.21 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : 94a2b877:c3055704:0023d7de:324e8dd8

    Update Time : Sun Feb 17 17:17:14 2019
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 45c13e8d - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : af451a4e:9386549d:33f4ec58:4cd98d82
           Name : otuslinux:0  (local to host otuslinux)
  Creation Time : Sun Feb 17 17:17:05 2019
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 3139584 (2.99 GiB 3.21 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : dd629a3f:43ba80d9:1e4c5fe4:4b94a109

    Update Time : Sun Feb 17 17:17:14 2019
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 1969228e - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : af451a4e:9386549d:33f4ec58:4cd98d82
           Name : otuslinux:0  (local to host otuslinux)
  Creation Time : Sun Feb 17 17:17:05 2019
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 3139584 (2.99 GiB 3.21 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : 072a890d:096331be:766616e5:9d906b65

    Update Time : Sun Feb 17 17:17:14 2019
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : 2889a929 - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : af451a4e:9386549d:33f4ec58:4cd98d82
           Name : otuslinux:0  (local to host otuslinux)
  Creation Time : Sun Feb 17 17:17:05 2019
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 3139584 (2.99 GiB 3.21 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : 21351444:414a0967:ffb75d3b:af1d20a8

    Update Time : Sun Feb 17 17:17:14 2019
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : a0e87a16 - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : af451a4e:9386549d:33f4ec58:4cd98d82
           Name : otuslinux:0  (local to host otuslinux)
  Creation Time : Sun Feb 17 17:17:05 2019
     Raid Level : raid10
   Raid Devices : 6

 Avail Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
     Array Size : 3139584 (2.99 GiB 3.21 GB)
    Data Offset : 4096 sectors
   Super Offset : 8 sectors
   Unused Space : before=4016 sectors, after=0 sectors
          State : clean
    Device UUID : bbc764ba:24c977fe:eec10c38:fa7005b0

    Update Time : Sun Feb 17 17:17:14 2019
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : b33be8cf - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
```

* `sudo mdadm --detail /dev/md0`:
```bash
[vagrant@otuslinux ~]$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Feb 17 17:17:05 2019
        Raid Level : raid10
        Array Size : 3139584 (2.99 GiB 3.21 GB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Sun Feb 17 17:17:14 2019
             State : clean 
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : af451a4e:9386549d:33f4ec58:4cd98d82
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg
```

* Get configuration information of RAID `sudo mdadm --detail --scan --verbose`:
```bash
ARRAY /dev/md0 level=raid10 num-devices=6 metadata=1.2 name=otuslinux:0 UUID=af451a4e:9386549d:33f4ec58:4cd98d82
   devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf,/dev/sdg
```

* Write configuration of RAID to `/etc/mdadm/mdadm.conf`:
```bash
[vagrant@otuslinux ~]$ sudo mkdir -p /etc/mdadm
[vagrant@otuslinux ~]$ echo "DEVICE partitions" | sudo tee /etc/mdadm/mdadm.conf > /dev/null
[vagrant@otuslinux ~]$ sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf > /dev/null
[vagrant@otuslinux ~]$ cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid10 num-devices=6 metadata=1.2 name=otuslinux:0 UUID=af451a4e:9386549d:33f4ec58:4cd98d82
```

* Reboot system `shutdown -r now`

* Check RAID
```bash
[vagrant@otuslinux ~]$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Feb 17 17:17:05 2019
        Raid Level : raid10
        Array Size : 3139584 (2.99 GiB 3.21 GB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Sun Feb 17 17:17:14 2019
             State : clean 
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : af451a4e:9386549d:33f4ec58:4cd98d82
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg

[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdd[2] sdb[0] sde[3] sdf[4] sdc[1]
      3139584 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]
      
unused devices: <none>
```

* Fail of one disk:
```bash
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 --fail /dev/sdb
mdadm: set /dev/sdb faulty in /dev/md0
```

* Check RAID (after fail of `/dev/sdb`):
```bash
[vagrant@otuslinux ~]$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Feb 17 17:17:05 2019
        Raid Level : raid10
        Array Size : 3139584 (2.99 GiB 3.21 GB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Sun Feb 17 17:53:49 2019
             State : clean, degraded 
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 1
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : af451a4e:9386549d:33f4ec58:4cd98d82
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg

       0       8       16        -      faulty   /dev/sdb
[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdd[2] sdb[0](F) sde[3] sdf[4] sdc[1]
      3139584 blocks super 1.2 512K chunks 2 near-copies [6/5] [_UUUUU]
      
unused devices: <none>
```

* Remove failed disk from RAID:
```bash
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 --remove /dev/sdb
mdadm: hot removed /dev/sdb from /dev/md0

[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid10] 
md0 : active raid10 sdg[5] sdd[2] sde[3] sdf[4] sdc[1]
      3139584 blocks super 1.2 512K chunks 2 near-copies [6/5] [_UUUUU]
      
unused devices: <none>
```

* Add new disk to RAID:
```bash
[vagrant@otuslinux ~]$ sudo mdadm /dev/md0 --add /dev/sdb
mdadm: added /dev/sdb

... rebuilding...

[vagrant@otuslinux ~]$ cat /proc/mdstat 
Personalities : [raid10] 
md0 : active raid10 sdb[6] sdg[5] sdd[2] sde[3] sdf[4] sdc[1]
      3139584 blocks super 1.2 512K chunks 2 near-copies [6/6] [UUUUUU]
      
unused devices: <none>

[vagrant@otuslinux ~]$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Feb 17 17:17:05 2019
        Raid Level : raid10
        Array Size : 3139584 (2.99 GiB 3.21 GB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Sun Feb 17 17:59:40 2019
             State : clean 
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : af451a4e:9386549d:33f4ec58:4cd98d82
            Events : 39

    Number   Major   Minor   RaidDevice State
       6       8       16        0      active sync set-A   /dev/sdb
       1       8       32        1      active sync set-B   /dev/sdc
       2       8       48        2      active sync set-A   /dev/sdd
       3       8       64        3      active sync set-B   /dev/sde
       4       8       80        4      active sync set-A   /dev/sdf
       5       8       96        5      active sync set-B   /dev/sdg
```

* Create GPT partition:
```bash
[vagrant@otuslinux ~]$ sudo parted -s /dev/md0 mklabel gpt
```

* Create partitions:
```bash
[vagrant@otuslinux ~]$ sudo parted /dev/md0 mkpart primary ext4 0% 20%
Information: You may need to update /etc/fstab.

[vagrant@otuslinux ~]$ sudo parted /dev/md0 mkpart primary ext4 20% 40%   
Information: You may need to update /etc/fstab.

[vagrant@otuslinux ~]$ sudo parted /dev/md0 mkpart primary ext4 40% 60%  
Information: You may need to update /etc/fstab.

[vagrant@otuslinux ~]$ sudo parted /dev/md0 mkpart primary ext4 60% 80%  
Information: You may need to update /etc/fstab.

[vagrant@otuslinux ~]$ sudo parted /dev/md0 mkpart primary ext4 80% 100% 
Information: You may need to update /etc/fstab.

[vagrant@otuslinux ~]$ sudo parted -s /dev/md0 p
Model: Linux Software RAID Array (md)
Disk /dev/md0: 3215MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size   File system  Name     Flags
 1      1573kB  643MB   642MB               primary
 2      643MB   1287MB  643MB               primary
 3      1287MB  1928MB  642MB               primary
 4      1928MB  2572MB  643MB               primary
 5      2572MB  3213MB  642MB               primary
```

* Create FS on partitions:
```bash
[vagrant@otuslinux ~]$ for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=384 blocks
39200 inodes, 156672 blocks
7833 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=161480704
5 block groups
32768 blocks per group, 32768 fragments per group
7840 inodes per group
Superblock backups stored on blocks: 
    32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=384 blocks
39280 inodes, 157056 blocks
7852 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=161480704
5 block groups
32768 blocks per group, 32768 fragments per group
7856 inodes per group
Superblock backups stored on blocks: 
    32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=384 blocks
39200 inodes, 156672 blocks
7833 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=161480704
5 block groups
32768 blocks per group, 32768 fragments per group
7840 inodes per group
Superblock backups stored on blocks: 
    32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=384 blocks
39280 inodes, 157056 blocks
7852 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=161480704
5 block groups
32768 blocks per group, 32768 fragments per group
7856 inodes per group
Superblock backups stored on blocks: 
    32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=128 blocks, Stripe width=384 blocks
39200 inodes, 156672 blocks
7833 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=161480704
5 block groups
32768 blocks per group, 32768 fragments per group
7840 inodes per group
Superblock backups stored on blocks: 
    32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```

* Mount partitions
```bash
[vagrant@otuslinux ~]$ sudo mkdir -p /raid/part{1,2,3,4,5}

[vagrant@otuslinux ~]$ for i in $(seq 1 5);
> do
>     sudo mount /dev/md0p$i /raid/part$i;
> done

[vagrant@otuslinux ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        40G  8.9G   32G  23% /
devtmpfs        1.9G     0  1.9G   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           1.9G  8.6M  1.9G   1% /run
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
tmpfs           379M     0  379M   0% /run/user/1000
/dev/md0p1      587M  936K  543M   1% /raid/part1
/dev/md0p2      588M  936K  544M   1% /raid/part2
/dev/md0p3      587M  936K  543M   1% /raid/part3
/dev/md0p4      588M  936K  544M   1% /raid/part4
/dev/md0p5      587M  936K  543M   1% /raid/part5
[vagrant@otuslinux ~]$ ll /raid/part1/
total 16
drwx------. 2 root root 16384 Feb 17 18:16 lost+found


[vagrant@otuslinux ~]$ printf '\n#\n# Mount raid partitions\n#\n' | sudo tee -a /etc/fstab > /dev/null
[vagrant@otuslinux ~]$ for i in $(seq 1 5);
> do
>     uuid=`sudo blkid /dev/md0p$i -s UUID -o value`;
>     dir=`echo /raid/part$i`;
>     printf 'UUID=%s\t%s\text4\tdefaults\t0\t0\n' "$uuid" "$dir" | sudo tee -a /etc/fstab > /dev/null;
> done
[vagrant@otuslinux ~]$ cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Mon Jan 28 21:12:08 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=8e4622c4-1066-4ea8-ab6c-9a19f626755c /                       xfs     defaults        0 0
/swapfile none swap defaults 0 0

#
# Mount raid partitions
#
UUID=f0efda20-43d0-46b9-8c0b-dedacbf6e299   /raid/part1 ext4    defaults    0   0
UUID=bcae9c7d-31f3-4ab6-b872-9503354e558f   /raid/part2 ext4    defaults    0   0
UUID=53f68d1f-4887-4625-9fa8-1a42008d4161   /raid/part3 ext4    defaults    0   0
UUID=f6733872-c9d1-4ed0-a3e6-67d020ab315a   /raid/part4 ext4    defaults    0   0
UUID=36fb73f3-d4aa-431c-8411-3b97aa8d7e6a   /raid/part5 ext4    defaults    0   0




```

Scripts:
```bash
for i in $(seq 1 5);
do
    sudo mount /dev/md0p$i /raid/part$i;
done


printf '\n#\n# Mount raid partitions\n#\n' | sudo tee -a /etc/fstab > /dev/null;
for i in $(seq 1 5);
do
    uuid=`sudo blkid /dev/md0p$i -s UUID -o value`;
    dir=`echo /raid/part$i`;
    printf 'UUID=%s\t%s\text4\tdefaults\t0\t0\n' "$uuid" "$dir" | sudo tee -a /etc/fstab > /dev/null;
done
```

* Reboot system `shutdown -r now`

* Check mounted directories:
```bash
[vagrant@otuslinux ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        40G  8.9G   32G  23% /
devtmpfs        1.9G     0  1.9G   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           1.9G  8.6M  1.9G   1% /run
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/md0p3      587M  936K  543M   1% /raid/part3
/dev/md0p2      588M  936K  544M   1% /raid/part2
/dev/md0p5      587M  936K  543M   1% /raid/part5
/dev/md0p1      587M  936K  543M   1% /raid/part1
/dev/md0p4      588M  936K  544M   1% /raid/part4
tmpfs           379M     0  379M   0% /run/user/1000
```