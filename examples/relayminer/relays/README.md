# Deploy a Kubernetes CronJob to simulate relays

For development and performance analysis purposes, a Pocket Network Node Operator might want to send many requests in the test environment (`alpha` or `beta` for example) to see how the relayminer, and downstream services behaves in a controlled computer system. This Helm chart enables you to configure a Kubernetes CronJob that will send a fix total amount of relay requests to a relayminer instance for an Application.

For more information, please refer to this pull request: https://github.com/pokt-network/poktroll/pull/1539

## Pre-requisite

1. 1 Supplier and 1 Application staked.
2. Relayminer up and running with staked supplier defined in 1.
3. Fullnode up and running exposing RPC and gRPC endpoints.

# 

In this `values.yaml` example, we are goint o deploy a Kubernetes CronJob that is scheduled every 3 minutes to send 20K relay requests to a relayminer instance for a specified application and supplier.

```shell
?> helm install <release-name> . -f examples/relayminer/relays/values.yaml
```
