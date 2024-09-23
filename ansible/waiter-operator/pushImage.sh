version=latest; make docker-buildx docker-push  IMG="docker.io/jorisjosselin/waiter-operator:${version}" ; make deploy IMG=docker.io/jorisjosselin/waiter-operator:${version}
version=1.0.4; make docker-buildx docker-push  IMG="docker.io/jorisjosselin/waiter-operator:${version}" ; make deploy IMG=docker.io/jorisjosselin/waiter-operator:${version}

version=latest; make docker-buildx docker-push  IMG="trcr.nl/ec/waiter-operator:${version}" ; make deploy IMG=trcr.nl/ec/waiter-operator:${version}
version=1.0.4; make docker-buildx docker-push  IMG="trcr.nl/ec/waiter-operator:${version}" ; make deploy IMG=trcr.nl/ec/waiter-operator:${version}
