#!/usr/bin/env bash

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y mdadm smartmontools hdparm gdisk

mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
mdadm --create --verbose /dev/md0 --level=10 --raid-devices=6 /dev/sd{b,c,d,e,f,g}

# Waiting for creation of RAID 10
while [ -n "$(mdadm --detail /dev/md0 | grep -ioE 'State :.*resyncing')" ]; do
    sleep 1
done

# Write RAID configuration to /etc/mdadm/mdadm.conf
mkdir -p /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

# Create partitions
parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

# Create FS on partitions
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done

# Create dirs and mount partitions to dirs
mkdir -p /raid/part{1,2,3,4,5}

for i in $(seq 1 5);
do
    sudo mount /dev/md0p$i /raid/part$i;
done

printf '\n#\n# Mount raid partitions\n#\n' >> /etc/fstab;
for i in $(seq 1 5);
do
    uuid=`blkid /dev/md0p$i -s UUID -o value`;
    dir=`echo /raid/part$i`;
    printf 'UUID=%s\t%s\text4\tdefaults\t0\t0\n' "$uuid" "$dir" >> /etc/fstab;
done