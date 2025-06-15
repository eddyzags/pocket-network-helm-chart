# Deploy a fullnode with keys for the keyring backend

This chart enables you to reference one or more Kubernetes Secrets to be mounted into the fullnode Kubernetes Pod. After deployment, you can configure your fullnode to operate as a validator. Validators play a key role in the Pocket Network blockchain by participating in an automated voting process to commit new blocks.

In this `values.yaml` example, you are going to deploy a fullnode with these specificities:
* Use local file system as persistent storage for `pocketd` working directory.
* Enable the mounting of Kubernetes Secret into 

```shell
?> helm install <release-name> . -f examples/fullnode/keyring/values.yaml
```

> Note: This `values.yaml` won't work out-of-the-box because you need to provide the Kubernetes Secret key first.

> Note: Be careful when deploying a validator, there is change of slashing. We suggest you read about [Sentry Node Architecture](https://hub.cosmos.network/main/validators/validator-faq#how-can-validators-protect-themselves-from-denial-of-service-attacks) first.

> Note: For more information on how to stake a validator, please refer to the official documentation https://dev.poktroll.com/operate/cheat_sheets/validator_cheatsheet#configure-validator
