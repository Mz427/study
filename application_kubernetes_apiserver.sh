cat > /usr/lib/systemd/system/kube-apiserver.service << EOF
[Unit]
Description=Kubernetes API server
Documentation=

[Service]
EnvironmentFile=/opt/kubernetes/etc/kube-apiserver.conf
ExeStart=/usr/bin/kube-apiserver \
    --apiserver-count=1 \
    --advertise-address=10.9.7.199 \
    --bind-address=10.9.7.199 \
    --secure-port=6443 \
    --etcd-cafile=/opt/etcd/ssl/ca.pem \
    --etcd-certfile=/opt/etcd/ssl/server.pem \
    --etcd-keyfile=/opt/etcd/ssl/server-key.pem \
    --etcd-servers=https://10.9.7.200:2379,https://10.9.7.199:2379,https://10.9.7.198:2379 \
    --service-cluster-ip-range=192.168.1.0/24 \
    --service-node-port-range=30000-32767 \
    --service-account-key-file=/opt/kubernetes/ssl/ca-key.pem \
    --client-ca-file=/opt/kubernetes/ssl/ca.pem \
    --kubelet-client-certificate=/opt/kubernetes/ssl/server.pem \
    --kubelet-client-key=/opt/kubernetes/ssl/server-key.pem \
    --tls-cert-file=/opt/kubernetes/ssl/server.pem  \
    --tls-private-key-file=/opt/kubernetes/ssl/server-key.pem \
    --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \
    --enable-bootstrap-token-auth=true \
    --token-auth-file=/opt/kubernetes/etc/token.csv \
    --allow-privileged=true \
    --authorization-mode=RBAC,Node \
    --audit-log-maxage=30 \
    --audit-log-maxbackup=3 \
    --audit-log-maxsize=100 \
    --audit-log-path=/opt/kubernetes/logs/kubernetes-audit.log
    --logtostderr=true \
    --v=4
    --log-dir=/opt/kubernetes/logs \

[Install]
Wantedby=multi-user.target
EOF
