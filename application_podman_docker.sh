podman search image_name
podman pull image_name
podman [start][stop][restart] container_name
podman exec [OPTIONS] CONTAINER COMMAND [ARG...]
podman exec -ti container_name /bin/bash
podman ps [-a]
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

podman run -d \
    --restart always \
    --name rabbitmq \
    -p 5672:5672 \
    -p 15672:15672 \
    -e RABBITMQ_DEFAULT_USER=admin \
    -e RABBITMQ_DEFAULT_PASS=admin \
    rabbitmq:latest
