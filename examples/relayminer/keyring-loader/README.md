### Demonstrate how to use this chart to deploy a RelayMiner using the Keyring-Loader tool.

1. Create a secret with your keys, following the structure suggested by [Keyring-Loader](https://github.com/pokt-shannon/shannon-keyring-loader/pkgs/container/shannon-keyring-loader#keysjson-example)

  ```shell
  kubectl create secret generic shannon-keys --from-file=keys.json
  ```

2. Install it:

  ```shell
  helm install <name> . -f examples/relayminer/keyring-loader/values.yaml
  ```
