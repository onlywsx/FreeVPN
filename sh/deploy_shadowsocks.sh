ssh $1 << EOF

apt update
apt install -y python3-pip 
pip3 install shadowsocks
cd /usr/local/lib/python3.5/dist-packages/shadowsocks/crypto

sed -i -e 's/libcrypto.EVP_CIPHER_CTX_cleanup.argtypes/libcrypto.EVP_CIPHER_CTX_reset.argtypes/g' openssl.py
sed -i -e 's/libcrypto.EVP_CIPHER_CTX_cleanup(self._ctx)/libcrypto.EVP_CIPHER_CTX_reset(self._ctx)/g' openssl.py
EOF

scp ss.conf $1:/usr/local/etc/

ssh $1 << EOF
ssserver -c /usr/local/etc/ss.conf -d restart
EOF
