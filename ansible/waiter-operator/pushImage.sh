version=latest; make docker-buildx docker-push  IMG="docker.io/jorisjosselin/waiter-operator:${version}" ; make deploy IMG=docker.io/jorisjosselin/waiter-operator:${version}
version=1.0.1; make docker-buildx docker-push  IMG="docker.io/jorisjosselin/waiter-operator:${version}" ; make deploy IMG=docker.io/jorisjosselin/waiter-operator:${version}
