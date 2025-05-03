### Demonstrate how to use this chart to deploy a RelayMiner using the a secret that holds all the keys for the keyring.

1. Load a local keyring with your keys: https://dev.poktroll.com/tools/user_guide/create-new-wallet?_highlight=keyring#what-is-a-keyring-backend
2. Create a secret from your keyring (local)

  ```shell
  kubectl create secret generic relayminer-keyring \
    $(for file in <KEYRING_PATH>/*; do echo --from-file=$(basename "$file")="$file"; done)
  ```

3. Install it (replace `SUPPLIER_KEYNAME` and/or add more lines like that one, just increase the index):

  ```shell
  helm install <name> . \
    --set shannon.relayminer.config.default_signing_key_names[0]=<SUPPLIER_KEYNAME> \
    -f examples/relayminer/keyring/values.yaml
  ```
