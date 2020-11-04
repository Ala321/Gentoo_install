TGTDEV=/dev/sda
DIR=/mnt/gentoo
function mkpart {
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +40G # 100 MB boot parttion
  n #
  p #
  2 #
    #
  +8G #
  t # new partition
  1 #
  83 # primary partition
  t # partion number 2
  2 # default, start immediately after preceding partition
  82 # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
}

function mkfs {
    #reiser
    echo mkreiserfs ${TGTDEV}1 -f
}
function mountsda {
    mkdir -p $DIR
    mount /dev/sda1 /mnt/gentoo
}

function getstage {
    cd /mnt/gentoo
    wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20201101T214503Z/hardened/stage3-amd64-hardened-20201101T214503Z.tar.xz
    tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
}
function chrot {
    mount --types proc /proc $DIR/proc
    mount --rbind /sys $DIR/sys
    mount --make-rslave $DIR/sys
    mount --rbind /dev $DIR/dev
    mount --make-rslave $DIR/dev
    chroot $DIR /bin/bash
    source /etc/profile
    export PS1="(chroot) ${PS1}"
}
mkpart
mkfs
mountsda
getstage
chrot  
