#HTTPS通信过程:
#()私钥加密内容.
#{}公钥加密内容.
client-----------http request----------->server
                                     [key0, pub_key]
                                           |
                                           |
client<-------------pub_key--------------server
[pub_key]                            [key0, pub_key]
  |
  |
client--------------{key1}-------------->server
[pub_key, key1]                      [key0, pub_key, key1]
                                           |
                                           |
client<----------(http response)---------server #使用key1加密
[pub_key, key1]                      [key0, pub_key, key1]
  |
  |
#使用key1解密得到内容
#以上过程存在黑客冒充服务器通信漏洞.

#HTTPS+CA证书通信过程:
#()私钥加密内容.
#{}公钥加密内容.
client-----------http request----------->server<----------CA
                                     [key0, CA{证书内容, pub_key}]
                                           |
                                           |
client<------CA{证书内容, pub_key}-------server
[CA{证书内容, pub_key}]              [key0, CA{证书内容, pub_key}]
  |
#验证证书真实性
  |
client--------------{key1}-------------->server
[pub_key, key1]                      [key0, pub_key, key1]
                                           |
                                           |
client<----------(http response)---------server #使用key1加密
[pub_key, key1]                      [key0, pub_key, key1]
  |
  |
#使用key1解密得到内容
#以上过程存在黑客冒充服务器通信漏洞.

#生成根証書.
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -subj "/CN=10.9.7.199" -days 365 -out ca.crt

#Create a config file for generating a Certificate Signing Request (CSR).
cat > csr.conf << EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = <country>
ST = <state>
L = <city>
O = <organization>
OU = <organization unit>
CN = <MASTER_IP>

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
IP.1 = <MASTER_IP>
IP.2 = <MASTER_CLUSTER_IP>

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names
EOF

#生成自签証書.
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr [-config csr.conf]
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
#生成根签証書.
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt \
    -days 365 -extensions v3_ext -extfile csr.conf
