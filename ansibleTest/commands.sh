mkdir memcached-operator
cd memcached-operator
operator-sdk init --domain ttl.sh --plugins ansible

make docker-build docker-push IMG="ttl.sh/memcached-operator:v0.0.1"

operator-sdk olm install

make bundle IMG="ttl.sh/memcached-operator:v0.0.1"
make bundle-build bundle-push

operator-sdk run bundle ttl.sh/memcached-operator-bundle:v0.0.1

operator-sdk cleanup memcached-operator