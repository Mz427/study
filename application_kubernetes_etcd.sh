#Install etcd:
mkdir -p /opt/etcd/{bin,etc,ssl}
cd /opt
wget https://github.com/etcd-io/etcd/releases/download/v3.5.2/etcd-v3.5.2-linux-amd64.tar.gz
tar -xzv -f etcd-v3.5.2-linux-amd64.tar.gz
cp etcd-v3.5.2-linux-amd64/etcd* etcd/bin

#Create etcd.service.
cat > etcd/etc/etcd.conf << EOF
#[Member]
ETCD_NAME="etcd-master1"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://10.9.7.199:2380"
ETCD_LISTEN_CLIENT_URLS="https://10.9.7.199:2379"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://10.9.7.199:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://10.9.7.199:2379"
ETCD_INITIAL_CLUSTER="etcd-master1=https://10.9.7.199:2380,etcd-master2=https://10.9.7.198:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

cat > /usr/lib/systemd/system/etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=/opt/etcd/etc/etcd.conf
ExecStart=/opt/etcd/bin/etcd \
    --cert-file=/opt/etcd/ssl/server.crt \
    --key-file=/opt/etcd/ssl/server.key \
    --peer-cert-file=/opt/etcd/ssl/server.crt \
    --peer-key-file=/opt/etcd/ssl/server.key \
    --trusted-ca-file=/opt/etcd/ssl/ca.crt \
    --peer-trusted-ca-file=/opt/etcd/ssl/ca.crt
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl enable etcd
systemctl start etcd

#Management command:
etcd --version
etcd --help
etcdctl --help
etcdctl --write-out="table" \
    --cacert=/opt/etcd/ssl/ca.crt \
    --cert=/opt/etcd/ssl/server.crt \
    --key=/opt/etcd/ssl/server.key \
    --endpoints=10.9.7.200:2379,10.9.7.199:2379,10.9.7.198:2379 \
    endpoint [status] [health]
    member list
