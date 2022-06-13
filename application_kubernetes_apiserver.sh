#审计日志可选
# –logtostderr：启用日志
# —v：日志等级
# –log-dir：日志目录
# –etcd-servers：etcd集群地址
# –bind-address：监听地址
# –secure-port：https安全端口
# –advertise-address：集群通告地址
# –allow-privileged：启用授权
# –service-cluster-ip-range：Service虚拟IP地址段
# –enable-admission-plugins：准入控制模块
# –authorization-mode：认证授权，启用RBAC授权和节点自管理
# –enable-bootstrap-token-auth：启用TLS bootstrap机制
# –token-auth-file：bootstrap token文件
# –service-node-port-range：Service nodeport类型默认分配端口范围
# –kubelet-client-xxx：apiserver访问kubelet客户端证书
# –tls-xxx-file：apiserver https证书
# –etcd-xxxfile：连接Etcd集群证书
# –audit-log-xxx：审计日志
# 温馨提示: 在 1.23.* 版本之后请勿使用如下参数。
# --enable-swagger-ui has been deprecated,
# --insecure-port has been deprecated,
# --alsologtostderr has been deprecated,
# --logtostderr has been deprecated,
# --log-dir has been deprecated,
# TTLAfterFinished=true.
# will be removed in a future release.
cat > /usr/lib/systemd/system/kube-apiserver.service << EOF
[Unit]
Description=Kubernetes API server
Documentation=

[Service]
EnvironmentFile=/opt/kubernetes/etc/kube-apiserver.conf
ExeStart=/usr/bin/kube-apiserver \
    --allow-privileged=true \
    --apiserver-count=3 \
    --authorization-mode=RBAC,Node \
    --advertise-address=10.9.7.199 \
    --bind-address=10.9.7.199 \
    --secure-port=6443 \
    --etcd-cafile=/opt/etcd/ssl/ca.crt \
    --etcd-certfile=/opt/etcd/ssl/server.crt \
    --etcd-keyfile=/opt/etcd/ssl/server.key \
    --etcd-servers=https://10.9.7.200:2379,https://10.9.7.199:2379,https://10.9.7.198:2379 \
    --service-cluster-ip-range=192.168.1.0/24 \
    --service-node-port-range=30000-32767 \
    --service-account-key-file=/opt/kubernetes/ssl/ca.key \
    --client-ca-file=/opt/kubernetes/ssl/ca.pem \
    --kubelet-client-certificate=/opt/kubernetes/ssl/server.crt \
    --kubelet-client-key=/opt/kubernetes/ssl/server.key \
    --tls-cert-file=/opt/kubernetes/ssl/server.crt \
    --tls-private-key-file=/opt/kubernetes/ssl/server.key \
    --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \
    --enable-bootstrap-token-auth=true \
    --token-auth-file=/opt/kubernetes/etc/token.csv \
    --allow-privileged=true \
    --authorization-mode=RBAC,Node \
    --audit-log-maxage=30 \
    --audit-log-maxbackup=3 \
    --audit-log-maxsize=100 \
    --audit-log-path=/opt/kubernetes/logs/kubernetes-audit.log \
    --logtostderr=true \
    --v=4 \
    --log-dir=/opt/kubernetes/logs \

[Install]
Wantedby=multi-user.target
EOF

cat > /etc/kubernetes/cfg/kube-apiserver.conf << EOF
KUBE_APISERVER_OPTS=" \
    --apiserver-count=3 \
    --advertise-address=10.10.107.225 \
    --allow-privileged=true \
    --authorization-mode=RBAC,Node \
    --bind-address=0.0.0.0 \
    --enable-aggregator-routing=true \
    --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
    --enable-bootstrap-token-auth=true \
    --token-auth-file=/etc/kubernetes/bootstrap-token.csv \--secure-port=6443 \
    --service-node-port-range=30000-32767 \
    --service-cluster-ip-range=10.96.0.0/16 \
    --client-ca-file=/etc/kubernetes/ssl/ca.pem \
    --tls-cert-file=/etc/kubernetes/ssl/apiserver.pem \
    --tls-private-key-file=/etc/kubernetes/ssl/apiserver-key.pem \
    --kubelet-client-certificate=/etc/kubernetes/ssl/apiserver.pem \
    --kubelet-client-key=/etc/kubernetes/ssl/apiserver-key.pem \
    --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname \
    --etcd-cafile=/etc/kubernetes/ssl/ca.pem \
    --etcd-certfile=/etc/kubernetes/ssl/etcd.pem \
    --etcd-keyfile=/etc/kubernetes/ssl/etcd-key.pem \
    --etcd-servers=https://10.10.107.225:2379,https://10.10.107.224:2379,https://10.10.107.223:2379 \
    --service-account-issuer=https://kubernetes.default.svc.cluster.local \
    --service-account-key-file=/etc/kubernetes/ssl/ca-key.pem \
    --service-account-signing-key-file=/etc/kubernetes/ssl/ca-key.pem \
    --proxy-client-cert-file=/etc/kubernetes/ssl/apiserver.pem \
    --proxy-client-key-file=/etc/kubernetes/ssl/apiserver-key.pem \
    --requestheader-allowed-names=kubernetes \
    --requestheader-extra-headers-prefix=X-Remote-Extra- \
    --requestheader-group-headers=X-Remote-Group \
    --requestheader-username-headers=X-Remote-User \
    --requestheader-client-ca-file=/etc/kubernetes/ssl/ca.pem \
    --v=2 \
    --event-ttl=1h \
    --feature-gates=TTLAfterFinished=true \
    --logtostderr=false \
    --log-dir=/var/log/kubernetes
    --audit-log-maxage=30
    --audit-log-maxbackup=3
    --audit-log-maxsize=100
    --audit-log-path=/var/log/kubernetes/kube-apiserver.log
EOF

#Master apiserver启用TLS认证后，Node节点kubelet和kube-proxy要与kube-apiserver进行通信，必须使用CA签发的有效证书才可以。
#当Node节点很多时，这种客户端证书颁发需要大量工作，同样也会增加集群扩展复杂度。为了简化流程，
#Kubernetes引入了TLS bootstraping机制来自动颁发客户端证书，kubelet会以一个低权限用户自动向apiserver申请证书，
#kubelet的证书由apiserver动态签署。所以强烈建议在Node上使用这种方式，目前主要用于kubelet，kube-proxy还是由我们统一颁发一个证书。
cat >/opt/kubernetes/etc/token.csv << EOF
$(head -c 16 /dev/urandom | od -An -t x | tr -d ' '),kubelet-bootstrap,10001,"system:node-bootstrapper"
EOF

systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
