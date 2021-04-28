function makeconf {
cp /usr/share/portage/config/make.conf.example /etc/portage/make.conf
processor=$((($(cat /proc/cpuinfo | awk '/^processor/{print $3}' | tail -1))+1))
echo $processor
cat << EOF > /etc/portage/make.conf
CFLAGS=" -O2 -pipe -fPIE -fstack-protector-all -fPIC -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2"
CXXFLAGS="\${CFLAGS}"
# WARNING: Changing your CHOST is not something that should be done lightly.
# Please consult http://www.gentoo.org/doc/en/change-chost.xml before changing.
CHOST="x86_64-pc-linux-gnu"
# These are the USE and USE_EXPAND flags that were used for
# buidling in addition to what is provided by the profile.
 #CPU_FLAGS_X86="mmx sse sse2"
PORTDIR="/usr/portage"
DISTDIR="\${PORTDIR}/distfiles"
PKGDIR="\${PORTDIR}/packages"
MAKEIOTS="-j$processor"
GENTOO_MIRRORS="http://ftp.vectranet.pl/gentoo/ ftp://ftp.vectranet.pl/gentoo/ rsync://ftp.vectranet.pl/gentoo/"
LDFLAGS="-Wl,-z,now -Wl,-z,relro"
#USE="bindist peer_perms"
POLICY_TYPES="strict"
CHOST="x86_64-pc-linux-gnu"
EOF
}

function repos {
mkdir -p /etc/portage/repos.conf
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
}



function resolver {
cat << EOF > /etc/resolv.conf
search i.mp.pl
nameserver 192.168.17.2
nameserver 10.120.120.2
nameserver 172.17.0.2
#nameserver 172.17.16.2
EOF
}

function sync {
emerge-webrsync
}
function profile {
plist=$(eselect profile list | grep hardened | grep stable | grep -v no-multilib | grep -v selinux | awk '{print $1}' |  sed 's/[^0-9]//g')
eselect profile set $plist
}
function updateworld {
emerge --deep --with-bdeps=y --changed-use --update -q @world
}
function setlocal {
cat << EOF > /etc/locale.gen
en_US.UTF-8 UTF-8 

EOF
locale-gen
}
function progs {
echo "Europe/Warsaw" > /etc/timezone
emerge --config sys-libs/timezone-data
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
emerge net-misc/ntp
emerge app-misc/mc
net-analyzer/tcpdump

}

function kernel {
emerge bc
wget=$(wget --output-document - --quiet https://www.kernel.org/ | grep -C 5 "longterm" -m1 | grep tarball)
echo $wget
wget=${wget##*<a href=\"}
wget=${wget%\" *}
echo $wget
cd /usr/src/
wget --quiet $wget
tar  -xf linux*.tar.xz

}

function grboot {
emerge grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
}


resolver
repos
makeconf
sync
profile
updateworld
setlocal
progs
grboot
kernel
