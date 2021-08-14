podman run -d -t -i --privileged \
    --restart always \
    --name registry \
    -p 5000:5000 \
    -v /var/lib/registry:/var/lib/registry \
    registry:2
podman run -d -t -i \
    --restart always \
    --name postgresql \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=929393 \
    postgres:latest
