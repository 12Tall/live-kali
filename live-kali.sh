# Copied from https://www.kali.org/docs/usb/usb-persistence-encryption/

# 0x01 Start by imaging the Kali ISO onto your USB stick
  # you can also do it via Etcher or other tools

# in this case our USB device is "/dev/sdb"
sudo dd if=kali-linux-2021.1-live-amd64.iso of=/dev/sdb bs=4M

# 0x02 Create and format an additional partition on the USB stick
sudo parted  # by parted
  print devices  # list all devices
  select /dev/sdb  # select a device
  print  # list partitions on "/dev/sdb"
  mkpart primary 3591 15600  # make a partition from 3,591M to 15,600M
  mkpart primary 15600 100%  # create another partition for data storage
  # resizepart part_id  # resize the partition
  quit  # exit. 

sudo mkfs.ntfs /dev/sdb4  # format data partition to NTFS

# 0x03 Ecrypt the partition with LUKS
sudo cryptsetup --verbose --verify-passphrase luksFormat /dev/sdb3
# sdb3 is our new partition
# this step may ask you to set a password

# 0x04 Open the encrypted partition
sudo cryptsetup luksOpen /dev/sdb3 my_usb

# 0x05 Create an ext4 filesystem and label it
sudo mkfs.ext4 /dev/mapper/my_usb
sudo e2label /dev/mapper/my_usb persistence

# 0x06 Mount the partition and create your persistence.conf so changes persist across reboots:
sudo mkdir -p /mnt/my_usb
sudo mount /dev/mapper/my_usb /mnt/my_usb
# sudo chmod -R 777 /mnt/my_usb
echo "/ union" > /mnt/my_usb/persistence.conf
sudo umount /dev/mapper/my_usb
sudo cryptsetup luksClose /dev/mapper/my_usb

# done

# unlock session while screen locked
loginctl list-sessions  
loginctl unlock-session session-id
# ctrl+alt+F7 switch to GUI
