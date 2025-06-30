# Deploy a Kubernetes CronJob to simulate relays

To support development and performance analysis, a Pocket Network Node Operator may need to send a high volume of requests in a test environments (such as `alpha` or `beta`) to observe the behavior of the relayminer and downstream services in a controlled setup. This Helm Chart configures a Kubernetes CronJob to send a fixed number of relay requests to a relayminer instance on behalf of an Application.

For more information, please refer to this pull request: https://github.com/pokt-network/poktroll/pull/1539

## Pre-requisite

1. 1 Supplier and 1 Application staked.
2. Relayminer up and running with staked supplier defined in 1.
3. Fullnode up and running exposing the RPC and gRPC endpoints.

In this `values.yaml` example, we are going to deploy a Kubernetes CronJob that is scheduled every 3 minutes to send 20K relay requests to a relayminer instance for a specified application and supplier.

```shell
?> helm install <release-name> . -f examples/relayminer/relays/values.yaml
```
