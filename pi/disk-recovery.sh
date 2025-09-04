#!/bin/bash

pi=pi@192.168.1.3
disk=/dev/mmcblk0

# backup pi disk (over network) while running :)
backup(){
  ssh ${pi} "sudo /bin/dd if=${disk} | gzip -c" | dd of=piDisk.raw.gz
  ssh ${pi} "sudo sfdisk -d ${disk}" > mmcblk0_partitions
}

# restore disk partitions (to a new local drive)
restore(){
  sfdisk ${disk} < mmcblk0_partitions
  gunzip --stdout -c piDisk.raw.gz | sudo dd of=${disk} bs=64k
}
