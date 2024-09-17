
# Operator workshop edgecase 2024

This repository contains assignments and examples for using custom operators with Minikube. These exercises will help you understand how to develop, deploy, and manage Kubernetes operators in a local development environment.

## Prerequisites

Before you begin, ensure you have the following tools installed:

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/docs/installation)
- [Make](https://www.gnu.org/software/make/) which for Windows you can install the binary from [here](https://gnuwin32.sourceforge.net/packages/make.htm) but we would recommend using [Ubuntu WSL for Windows](https://ubuntu.com/desktop/wsl)

NOTE: You can use virtualization tools like `VirtualBox` and `VMware Fusion`, but with these, the command `minikube service <svc> -n <namespace>` will probably not work anymore. You will have to use `kubectl port-forward -n <namespace> <svc>` instead, which unfortunately will have to be killed and restarted every time the CRD is edited.

DOCKERNOTE: macOS currently has an [issue](https://github.com/docker/cli/issues/5412) on the latest version of Docker Desktop that makes installs hang. If using macOS, it is recommended to use Podman instead.

## Repository Structure

```bash
.
├── .gitignore
├── README.md
└── ansible/
    ├── application/
    ├── commands.sh
    └── waiter-operator/
```

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/operator-workshop-edgecase-2024.git
   cd operator-workshop-edgecase-2024
   ```

2. Start Minikube:
   ```bash
   # If you use Docker
   minikube start --driver=docker
   # If you use Podman
   minikube start --driver=podman --container-runtime=cri-o
   ```

3. Test if it has worked:
   ```bash
   kubectl get nodes
   ```
   Should give you something like the following output:
   ```bash
   ❯ kubectl get nodes
    NAME       STATUS   ROLES           AGE   VERSION
    minikube   Ready    control-plane   53s   v1.31.0
   ```

## Assignments

### 1. Install the operator

```bash
cd ansible/waiter-operator/
make deploy IMG=ghrc.io/jorisdejosselintrue/waiter-operator:latest
```

### 2. Install CRD and use it
First lets switch to the namespace where the operator is installed:
```bash
kubectl config set-context --current --namespace=waiter-operator
```

Now we can apply the CRD so that the underlying app the operator controls will be deployed:
```bash
kubectl apply -f config/samples/town_v1alpha1_bar.yaml
```

## Cleanup

To remove all resources created during the assignments, run:

```bash
./scripts/cleanup.sh
```