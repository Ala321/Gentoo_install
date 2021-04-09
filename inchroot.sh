function makeconf {
cp /usr/share/portage/config/make.conf.example /etc/portage/make.conf
cat << EOF > /etc/portage/make.conf
CFLAGS=" -O2 -pipe -fPIE -fstack-protector-all -fPIC -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2"
CXXFLAGS="${CFLAGS}"
# WARNING: Changing your CHOST is not something that should be done lightly.
# Please consult http://www.gentoo.org/doc/en/change-chost.xml before changing.
CHOST="x86_64-pc-linux-gnu"
# These are the USE and USE_EXPAND flags that were used for
# buidling in addition to what is provided by the profile.
 #CPU_FLAGS_X86="mmx sse sse2"
PORTDIR="/usr/portage"
DISTDIR="${PORTDIR}/distfiles"
PKGDIR="${PORTDIR}/packages"
MAKEIOTS="-j40"
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


resolver


#repos
