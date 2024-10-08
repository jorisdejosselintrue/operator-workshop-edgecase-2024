> **You can view the slides of our presentation here:**
> * **[https://github.com/jorisdejosselintrue/operator-workshop-edgecase-2024/wiki/Presentation](https://github.com/jorisdejosselintrue/operator-workshop-edgecase-2024/wiki/Presentation)**

# Operator workshop edgecase 2024

## Prerequisites

Before you begin, ensure you have the following tools installed:

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) (or your own working Kubernetes cluster)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://docs.docker.com/get-docker/) or [Podman](https://podman.io/docs/installation)
- [Make](https://www.gnu.org/software/make/) which for Windows you can install the binary from [here](https://gnuwin32.sourceforge.net/packages/make.htm) but we would recommend using [Ubuntu WSL for Windows](https://ubuntu.com/desktop/wsl)

> NOTE: You can use virtualization tools like `VirtualBox` and `VMware Fusion`, but with these, the command `minikube service <svc> -n <namespace>` will probably not work anymore. You will have to use `kubectl port-forward -n <namespace> <svc>` instead, which unfortunately will have to be killed and restarted every time the CRD is edited.

> NOTE: After installing `minikube` with Homebrew on an M1 MacBook you can get the error:
> 
> **You are trying to run the amd64 binary on an Ml system.**
> **Please consider running the darwin/arm64 binary instead.**
> **Download at https://github.com/kubernetes/minikube/releases/download/v1.34.0/minikube-darwin-arm64**
> 
> To fix this with Homebrew you need to [reinstall Homebrew](https://github.com/Homebrew/install?tab=readme-ov-file#uninstall-homebrew)
or install minikube with the [Binary download method](https://minikube.sigs.k8s.io/docs/start/).

> DOCKERNOTE: macOS currently has an [issue](https://github.com/docker/cli/issues/5412) on the latest version of Docker Desktop that makes installs hang. If using macOS, it is recommended to use Podman instead.

> NOTENOTE: Sometimes you will encounter a 503 error on the web app. This is (supposedly) part of the workshop.

#### Optional

- [k9s](https://k9scli.io)

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
   git clone https://github.com/jorisdejosselintrue/operator-workshop-edgecase-2024.git
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
   kubectl get nodes

   NAME       STATUS   ROLES           AGE   VERSION
   minikube   Ready    control-plane   53s   v1.31.0
   ```

## Assignments

It is recommend throughout these tasks to use tools like [k9s](https://k9scli.io/topics/install/) or just the regular command `kubectl get pod -w` in another window to keep track of what is happening when you apply certain commands.

### 1. Install the operator

```bash
cd ansible/waiter-operator/
make deploy IMG=docker.io/jorisjosselin/waiter-operator:latest
```

<details>
  <summary>If you get pull errors please use the following make command</summary>

```bash
make deploy IMG=trcr.nl/ec/waiter-operator:latest
```

</details>

### 2. Install CRD and use it

First lets switch to the namespace where the operator is installed:
```bash
kubectl config set-context --current --namespace=waiter-operator-system
```

Now we can apply the CRD so that the underlying app the operator controls will be deployed:
```bash
kubectl apply -f config/samples/town_v1alpha1_bar.yaml
```

Now this should have deployed a pod next to the operator controller pod called bar-sample:
```bash
kubectl get pod
NAME                                                  READY   STATUS    RESTARTS   AGE
bar-sample-bar-54759bd4d-mpg4n                        1/1     Running   0          63s
waiter-operator-controller-manager-659c77dd4c-vz8gg   2/2     Running   0          3m4s
```

<details>
  <summary>If you also get pull errors here please use the following make command</summary>

```bash
kubectl patch Bar bestbarintown --type='merge' -p '{"spec": { "image": "trcr.nl/ec/waiter-operator-site" } }'
```

</details>

If you have verified that the pod is running, run the following minikube command in a **new terminal window** to forward traffic to the pod:
```bash
minikube update-context
minikube service bestbarintown-bar -n waiter-operator-system
```
This should start your default browser with the website that has just been setup by the operator.

Now look at the applied CRD with:
```bash
kubectl get bars.town.ghcr.io bestbarintown -o yaml
```
```yaml
apiVersion: town.ghcr.io/v1alpha1
kind: Bar
metadata:
...
spec:
  drinks:
    barman:
      amount_of_drinks_drunken: 10
    beer:
      amount: 1
      type: IPA
    coffee:
      strength: strong
    tea:
      amount: 1
      flavor: green
    whisky:
      amount: 1
      flavor: japaneseWood
  size: 1
...
```
The values shown should be the same as on the website.

Now you can edit a value in the CRD and for example set the amount of whisky to 5:

```bash
kubectl edit bar.town.ghcr.io bestbarintown
```
Alternatively if this opens an editor you do not want to use, you can do set the a variable setting the default editor this could be for example `nano`. These examples show how to use `vscode` or `nano`:
```bash
EDITOR='code --wait'; kubectl edit bar.town.ghcr.io bestbarintown
```
> NOTE: You will have to close the file in the vscode editor for it to change the CRD.
```bash
EDITOR='nano'; kubectl edit bar.town.ghcr.io bestbarintown
```

Now if you are checking in another terminal what is happening when you edit the CRD in the `waiter-operator-system` namespace you will see that he pod is getting restarted on edits. If the new pod is healthy you will see the changes you have made.

### 3. The bar is FALLING APART

For the keen observers out there you might have seen that the apps is crashing (The lousy barman is getting to drunk) every now and again. Now the question is why is this happening? Seems like that Jona is helping a little too much.

Now for this exercise we will not edit the operator directly but still use the CRD's. To make it easier the answer lies in the the ansible code that is being run by the operator. That ansible code is located in `ansible/waiter-operator/roles/bar/tasks`.

Now please make Jona stop '''''helping'''''. # Hint: in Ansible if you want to remove a resource you can set `state: "absent"`

Here is the solution directly (but we implore you to at least try):
<details>
  <summary>Reveal me</summary>
  The following cronjob is the one spanning the job that makes the barman drunk (Adds an integer):

  ```bash
  kubectl get cronjobs.batch

  NAME                        SCHEDULE      TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
  bestbarintown-jona-helper   */1 * * * *   <none>     False     0        <none>          44s
  ```

  In the 'Add the Jona helper' task in the 'ansible/waiter-operator/roles/bar/tasks/main.yml' file, you can see the following state being set as 'present' by default:

  ```yaml
  - name: Add the Jona helper
    kubernetes.core.k8s:
      state: "{{ stopitjona | default('present') }}"
  ```

  You can disable the cronjob with the following patch on the CRD:

  ```bash
  kubectl patch Bar bestbarintown --type='merge' -p '{"spec": { "stopitjona": "absent" } }'
  ```

  After waiting a bit the cronjob should not be there anymore:

  ```bash
  kubectl get cronjobs.batch

  No resources found in waiter-operator-system namespace.
  ```
</details>
