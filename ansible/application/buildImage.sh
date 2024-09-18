docker buildx create --name project-v3-builder
docker buildx use project-v3-builder
docker buildx build --push --platform=linux/arm64,linux/amd64,linux/s390x,linux/ppc64le --tag ttl.sh/joriswebsitetest --tag ttl.sh/joriswebsitetest:0.0.1 -f Dockerfile .
docker buildx rm project-v3-builder
docker push -a ttl.sh/joriswebsitetest