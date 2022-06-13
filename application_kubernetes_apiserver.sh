# 参數說明:
# –advertise-address: 向集群成员通知 apiserver 消息的 IP 地址。 这个地址必须能够被集群中其他成员访问。 如果 IP 地址为空，将会使用 --bind-address， 如果未指定 --bind-address，将会使用主机的默认接口地址。
# –allow-privileged: 如果为 true，将允许特权容器。[默认值=false]
# –authorization-mode: 在安全端口上进行鉴权的插件的顺序列表。逗号分隔的列表: AlwaysAllow、AlwaysDeny、ABAC、Webhook、RBAC、Node。
# –bind-address: 用来监听 --secure-port 端口的 IP 地址。 集群的其余部分以及 CLI/web 客户端必须可以访问所关联的接口。 如果为空白或未指定地址（0.0.0.0 或 ::），则将使用所有接口。
# –enable-bootstrap-token-auth: 启用以允许将 "kube-system" 名字空间中类型为 "bootstrap.kubernetes.io/token" 的 Secret 用于 TLS 引导身份验证。
# –enable-admission-plugins: 准入控制模块
# –token-auth-file: bootstrap token文件
# –secure-port: 带身份验证和鉴权机制的 HTTPS 服务端口。 不能用 0 关闭。
# -service-account-key-file: 包含 PEM 编码的 x509 RSA 或 ECDSA 私钥或公钥的文件，用于验证 ServiceAccount 令牌。 指定的文件可以包含多个键，并且可以使用不同的文件多次指定标志。 如果未指定，则使用 --tls-private-key-file。 提供 --service-account-signing-key-file 时必须指定。
# –service-cluster-ip-range: CIDR 表示的 IP 范围用来为服务分配集群 IP。 此地址不得与指定给节点或 Pod 的任何 IP 范围重叠。
# –service-node-port-range: 保留给具有 NodePort 可见性的服务的端口范围。 例如："30000-32767"。范围的两端都包括在内。
# –logtostderr: 启用日志
# —v: 日志等级
# –log-dir: 日志目录
#
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
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
WorkingDirectory=/data/k8s/k8s/kube-apiserver
ExecStart=/data/k8s/bin/kube-apiserver \
  --advertise-address=##NODE_IP## \
  --default-not-ready-toleration-seconds=360 \
  --default-unreachable-toleration-seconds=360 \
  --feature-gates=DynamicAuditing=true \
  --max-mutating-requests-inflight=2000 \
  --max-requests-inflight=4000 \
  --default-watch-cache-size=200 \
  --delete-collection-workers=2 \
  --encryption-provider-config=/etc/kubernetes/encryption-config.yaml \
  --etcd-cafile=/etc/kubernetes/cert/ca.pem \
  --etcd-certfile=/etc/kubernetes/cert/kubernetes.pem \
  --etcd-keyfile=/etc/kubernetes/cert/kubernetes-key.pem \
  --etcd-servers=https://etcd01.k8s.vip:2379,https://etcd02.k8s.vip:2379,https://etcd03.k8s.vip:2379 \
  --bind-address=##NODE_IP## \
  --secure-port=6443 \
  --tls-cert-file=/etc/kubernetes/cert/kubernetes.pem \
  --tls-private-key-file=/etc/kubernetes/cert/kubernetes-key.pem \
  --insecure-port=0 \
  --audit-dynamic-configuration \
  --audit-log-maxage=15 \
  --audit-log-maxbackup=3 \
  --audit-log-maxsize=100 \
  --audit-log-truncate-enabled \
  --audit-log-path=/data/k8s/k8s/kube-apiserver/audit.log \
  --audit-policy-file=/etc/kubernetes/audit-policy.yaml \
  --profiling \
  --anonymous-auth=false \
  --client-ca-file=/etc/kubernetes/cert/ca.pem \
  --enable-bootstrap-token-auth \
  --requestheader-allowed-names="aggregator" \
  --requestheader-client-ca-file=/etc/kubernetes/cert/ca.pem \
  --requestheader-extra-headers-prefix="X-Remote-Extra-" \
  --requestheader-group-headers=X-Remote-Group \
  --requestheader-username-headers=X-Remote-User \
  --service-account-key-file=/etc/kubernetes/cert/ca.pem \
  --authorization-mode=Node,RBAC \
  --runtime-config=api/all=true \
  --enable-admission-plugins=NodeRestriction \
  --allow-privileged=true \
  --apiserver-count=3 \
  --event-ttl=168h \
  --kubelet-certificate-authority=/etc/kubernetes/cert/ca.pem \
  --kubelet-client-certificate=/etc/kubernetes/cert/kubernetes.pem \
  --kubelet-client-key=/etc/kubernetes/cert/kubernetes-key.pem \
  --kubelet-https=true \
  --kubelet-timeout=10s \
  --proxy-client-cert-file=/etc/kubernetes/cert/proxy-client.pem \
  --proxy-client-key-file=/etc/kubernetes/cert/proxy-client-key.pem \
  --service-cluster-ip-range=10.254.0.0/16 \
  --service-node-port-range=1024-32767 \
  --logtostderr=true \
  --v=2
Restart=on-failure
RestartSec=10
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

#Master apiserver启用TLS认证后，Node节点kubelet和kube-proxy要与kube-apiserver进行通信，必须使用CA签发的有效证书才可以。
#当Node节点很多时，这种客户端证书颁发需要大量工作，同样也会增加集群扩展复杂度。为了简化流程，
#Kubernetes引入了TLS bootstraping机制来自动颁发客户端证书，kubelet会以一个低权限用户自动向apiserver申请证书，
#kubelet的证书由apiserver动态签署。所以强烈建议在Node上使用这种方式，目前主要用于kubelet，kube-proxy还是由我们统一颁发一个证书。
cat > /opt/kubernetes/etc/token.csv << EOF
$(head -c 16 /dev/urandom | od -An -t x | tr -d ' '),kubelet-bootstrap,10001,"system:node-bootstrapper"
EOF

systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
