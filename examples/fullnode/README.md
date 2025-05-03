### Demonstrate how to use this chart to deploy a fullnode

1. Create a secret with your validator keys:

  ```shell
  kubectl create secret generic fullnode-shannon-keys \
    --from-file=node_key.json \
    --from-file=priv_validator_key.json
  ```

2. Install it:

  ```shell
  helm install <name> . -f examples/fullnode/values.yaml
  ```
