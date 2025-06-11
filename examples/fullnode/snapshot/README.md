# Deploy a fullnode with a snapshot

This charts allows you to download a pocket network recorded blockchain state at a specific block height. It is
useful if you want to speed up the fullnode syncing process, and also as a fast failsafe, you may roll your
fullnode back to an ealier point if an error occured.
You can define in the value files which type of mechanism you want to use to download the snapshot before
executing the fullnode:
* `ariac`: uses a lightweight multi-protocol CLI download utility to fetch the blockchain snapshot. [More information here](https://github.com/eddyzags/pocket-network-helm-chart/blob/main/values.yaml#L1299-L1333)
* `custom`: use your own init container to download and extract a snapshot into the fullnode Kubernetes Pod. [More information here](https://github.com/eddyzags/pocket-network-helm-chart/blob/main/values.yaml#L1299-L1333)

In this `values.yaml` example, we are going to deploy a fullnode with these specififties:
* Use local file system as a persistent storage for `pocketd` working directory.
* Enable the snapshot feature using `ariac` type.
* Enable a Kubernetes Liveness probe.

```shell
?> helm install <release-name> . -f examples/fullnode/snapshot/values.yaml
```
