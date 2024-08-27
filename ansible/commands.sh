mkdir waiter-operator
cd waiter-operator
operator-sdk init --domain ghcr.io --plugins ansible
operator-sdk create api --group divebar --version v1alpha1 --kind Coffee --generate-role

make docker-build docker-push IMG="ghcr.io/jorisdejosselintrue/waiter-operator:v0.0.1"
make install
make deploy IMG=ghcr.io/jorisdejosselintrue/waiter-operator:v0.0.1

kustomize build config/default

make deploy

# operator-sdk olm install

# make bundle IMG="ghcr.io/waiter-operator:v0.0.1"
# make bundle-build bundle-push

# operator-sdk run bundle ghcr.io/waiter-operator-bundle:v0.0.1

# operator-sdk cleanup waiter-operator



mkdir memcached-operator
cd memcached-operator
operator-sdk init --domain ttl.sh --plugins ansible

make docker-build docker-push IMG="ttl.sh/memcached-operator:v0.0.1"

operator-sdk olm install

make bundle IMG="ttl.sh/memcached-operator:v0.0.1"
make bundle-build bundle-push

operator-sdk run bundle ttl.sh/memcached-operator-bundle:v0.0.1

operator-sdk cleanup memcached-operator