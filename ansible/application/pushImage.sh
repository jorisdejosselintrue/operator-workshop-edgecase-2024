docker buildx create --name project-v3-builder
docker buildx use project-v3-builder
docker buildx build --push --platform=linux/arm64,linux/amd64,linux/s390x,linux/ppc64le --tag docker.io/jorisjosselin/waiter-operator-site:latest --tag docker.io/jorisjosselin/waiter-operator-site:1.0.0 -f Dockerfile .
docker buildx rm project-v3-builder
docker push -a docker.io/jorisjosselin/waiter-operator-site