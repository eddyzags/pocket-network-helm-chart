# Deploy a relayminer with keys for the keyring backend

This Helm chart enables you to configure and use the keyring with different backends for the `pocketd` application. Currently, only the `test` keyring backend is supported, in combination with Kubernetes Secrets. You can mount one or more predefined Kubernetes Secrets into the relayminer Kubernetes Pod, but these Kubernetes Secrets must be created before installing the Pocket Network Helm chart, so they can be properly referenced in the Kubernetes pod's configuration.

In this example, you are going to:
* Create an encrypted private/public key pair using `pocketd`.
* Create a Kubernetes Secret with the encrypted private/public key pair using `kubectl`.
* Deploy a relayminer that references the private/public key pair.

```shell
?> pocketd keys add supplier1 --keyring-backend=test

?> kubectl create secret generic pocket-network-shannon-relayminer-key --from-file=supplier1.info=$HOME/.pocket/keyring-test/supplier1.info

?> helm install <release-name> . -f examples/relayminer/keyring/values.yaml
```

> Note: For more information on how to stake a supplier, please refer to the official documentation https://dev.poktroll.com/operate/cheat_sheets/supplier_cheatsheet#2-configure-your-supplier
