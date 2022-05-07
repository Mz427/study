cat > /opt/kubernetes/etc/kube-apiserver.conf << EOF
--advertise-address=172.16.210.53 \\
--allow-privileged=true \\
--authorization-mode=RBAC,Node \\

--audit-log-maxage=30 \\
--audit-log-maxbackup=3 \\
--audit-log-maxsize=100 \\
--audit-log-path=/opt/kubernetes/logs/k8s-audit.log"

--bind-address=172.16.210.53 \\
--client-ca-file=/opt/kubernetes/ssl/ca.pem \\

--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \\
--enable-bootstrap-token-auth=true \\

--etcd-cafile=/opt/etcd/ssl/ca.pem \\
--etcd-certfile=/opt/etcd/ssl/server.pem \\
--etcd-keyfile=/opt/etcd/ssl/server-key.pem \\
--etcd-servers=https://172.16.210.53:2379,https://172.16.210.54:2379,https://172.16.210.55:2379 \\

--kubelet-client-certificate=/opt/kubernetes/ssl/server.pem \\
--kubelet-client-key=/opt/kubernetes/ssl/server-key.pem \\

--log-dir=/opt/kubernetes/logs \\
--secure-port=6443 \\

--service-account-key-file=/opt/kubernetes/ssl/ca-key.pem \\
--service-cluster-ip-range=10.0.0.0/24 \\
--service-node-port-range=30000-32767 \\

--tls-cert-file=/opt/kubernetes/ssl/server.pem  \\
--tls-private-key-file=/opt/kubernetes/ssl/server-key.pem \\
--token-auth-file=/opt/kubernetes/cfg/token.csv \\
--v=4 \\
KUBE_APISERVER_OPTS="--logtostderr=false \\
EOF
