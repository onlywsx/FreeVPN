ssh $1 << EOF
rm -rf strongswan*
apt update

apt install libpam-dev libssl-dev libgmp-dev build-essential ca-certificates

wget http://download.strongswan.org/strongswan-5.5.3.tar.gz
tar xzf strongswan-5.5.3.tar.gz
cd strongswan-5.5.3/

./configure  --enable-eap-identity --enable-eap-md5 \
--enable-eap-mschapv2 --enable-eap-tls --enable-eap-ttls --enable-eap-peap  \
--enable-eap-tnc --enable-eap-dynamic --enable-eap-radius --enable-xauth-eap  \
--enable-xauth-pam  --enable-dhcp  --enable-openssl  --enable-addrblock --enable-unity  \
--enable-certexpire --enable-radattr --enable-tools --enable-openssl --disable-gmp

make
make install
EOF

scp ss.tar.gz $1:/usr/local/etc/
scp iptables-save.bk $1:

ssh $1 << EOF
iptables-restore < iptables-save.bk
cd /usr/local/etc/
tar zxvf ss.tar.gz
ipsec restart 
EOF
