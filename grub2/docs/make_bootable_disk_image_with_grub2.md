### make_bootable_disk_image_with_grub2

```shell
# os: ubuntu-16.04
# grub-install: (GRUB) 1.99

# cylinders=100 heads=16 sectors=63
dd if=/dev/zero of=./disk.img count=$((100*16*63))

sudo losetup /dev/loop0 ./disk.img

sudo gparted /dev/loop0
# create an MS-DOS partition table
# create primary partition ext2

# sudo fdisk -lu /dev/loop0

sudo losetup /dev/loop1 ./disk.img -o $((512*2048))

sudo mount /dev/loop1 /mnt

sudo mkdir -p /mnt/boot/grub/

sudo vim /mnt/boot/grub/device.map
# (hd0) /dev/loop0
# (hd0,1) /dev/loop1

sudo grub-install --root-directory=/mnt --grub-mkdevicemap=/mnt/boot/grub/device.map --no-floppy /dev/loop0

...

sync

sudo umount /mnt

sudo losetup -d /dev/loop0

sudo losetup -d /dev/loop1
```

#### reference

http://heguangyu5.github.io/my-linux/html/4-%E5%88%B6%E4%BD%9Cdisk.html

http://my-zhang.github.io/blog/2014/06/28/make-bootable-linux-disk-image-with-grub2/