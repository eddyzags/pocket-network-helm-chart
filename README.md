# Helm Chart package for Pocket Network

Pocket Network is permissionless decentralized physical infrastructure (DePin) protocol that incentivizes and coordinates a network of node operators to provide open data access to anyone. This repository bootstraps a Pocket Network deployment on a Kubernetes cluster using the Helm package manager.

[Overview of Pocket Network](https://pocket.network/)

## TL;DR
```shell
?> helm install release-1 https://github.com/eddyzags/pocket-network-helm-charts
```
## Introduction

## Prerequisites
* Kubernetes 1.32+
* Helm 3.17.2+

## Installing the Chart

To install the chart with name `my-release`
```
helm install my-release https://github.com/eddyzags/pocket-network-helm-charts --values shannon-values.yaml
```
> Note: You must specify the value in yaml file. This is an example with the values related to Shannon protocol.

This command deploy the different Pocket Network actors based on the values provided in the 

## Configuration and installation details

### Resources and limits

Pocket Network charts allow setting resource requests and limits for every protocol actors (containers) inside the chart deployment. There are inside the `resources` values.
To make this resource and limit definition easier to define, this chart contains a `resources.preset` attribute that sets the `resources.limits` and `resources.requests`. These presets are recommended by the community, but you can define your own.

> Note: You can either define a preset (`resources.preset=small` for example) or an explicit . If you define both, the `resources.limits` and `resources.requests` will be used.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose a prometheus metrics endpoint, and a `ServiceMonitor` object. This chart will define the necessary configurations to be automatically scraped by Prometheus.

> Note: it is necessary to have a working installation of Prometheus Operator for the integration to work.

### Ingress

#TODO(eddyzags): define integration with ingress

### Provisionning keys

#TODO(eddyzags): write steps to configure keys

## Parameters

### Global parameters

| Name            | Description                                   | Value |
|-----------------|-----------------------------------------------|-------|
| `protocol`      | decentralized framework to access network     | ""    |
| `network`       | different stage of the protocol testing phase | ""    |
| `version`       | Semantic versionning of the pocketd software  | ""    |
| `homeDirectory` | pocketd working directory                     | ""    |

### Shannon parameters
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| homeDirectory | string | `"/home/pocket/.pocket"` |  |
| network | string | `"testnet-beta"` |  |
| protocol | string | `"shannon"` |  |
| shannon.fullnode.affinity | object | `{}` |  |
| shannon.fullnode.cometbft.app | string | `""` |  |
| shannon.fullnode.cometbft.client | string | `""` |  |
| shannon.fullnode.cometbft.config | string | `""` |  |
| shannon.fullnode.cometbft.secret.key.name | string | `"pocket-network-eddyzags-shannon"` |  |
| shannon.fullnode.cometbft.secret.key.nodeKeyName | string | `"node_key.json"` |  |
| shannon.fullnode.cometbft.secret.key.privValidatorKeyName | string | `"priv_validator_key.json"` |  |
| shannon.fullnode.cometbft.secret.type | string | `"Secret"` |  |
| shannon.fullnode.cometbft.volumes.config.key.appKeyName | string | `"app.toml"` |  |
| shannon.fullnode.cometbft.volumes.config.key.clientKeyName | string | `"client.toml"` |  |
| shannon.fullnode.cometbft.volumes.config.key.configKeyName | string | `"config.toml"` |  |
| shannon.fullnode.cometbft.volumes.config.key.name | string | `"pocket-network-eddyzags-shannon"` |  |
| shannon.fullnode.cometbft.volumes.enabled | bool | `false` |  |
| shannon.fullnode.cometbft.volumes.type | string | `"ConfigMap"` |  |
| shannon.fullnode.containersSecurityContext | object | `{}` |  |
| shannon.fullnode.enabled | bool | `true` |  |
| shannon.fullnode.image.repository | string | `"ghcr.io/pokt-network/pocketd"` |  |
| shannon.fullnode.image.tag | string | `""` |  |
| shannon.fullnode.imagePullSecrets | list | `[]` |  |
| shannon.fullnode.ingress.annotations | object | `{}` |  |
| shannon.fullnode.ingress.className | string | `""` |  |
| shannon.fullnode.ingress.enabled | bool | `false` |  |
| shannon.fullnode.ingress.hosts | list | `[]` |  |
| shannon.fullnode.ingress.tls | list | `[]` |  |
| shannon.fullnode.initContainersSecurityContext.runAsGroup | int | `1025` |  |
| shannon.fullnode.initContainersSecurityContext.runAsUser | int | `1025` |  |
| shannon.fullnode.livenessProbe.enabled | bool | `true` |  |
| shannon.fullnode.livenessProbe.failureThreshold | int | `5` |  |
| shannon.fullnode.livenessProbe.initialDelaySeconds | int | `10` |  |
| shannon.fullnode.livenessProbe.periodSeconds | int | `15` |  |
| shannon.fullnode.livenessProbe.successThreshold | int | `1` |  |
| shannon.fullnode.livenessProbe.timeoutSeconds | int | `5` |  |
| shannon.fullnode.nodeSelector | object | `{}` |  |
| shannon.fullnode.podAnnotations | object | `{}` |  |
| shannon.fullnode.podSecurityContext | object | `{}` |  |
| shannon.fullnode.resources.preset.enabled | bool | `false` |  |
| shannon.fullnode.resources.preset.name | string | `"medium"` |  |
| shannon.fullnode.resources.values.limits.cpu | string | `"3000m"` |  |
| shannon.fullnode.resources.values.limits.memory | string | `"3Gi"` |  |
| shannon.fullnode.resources.values.requests.cpu | string | `"2000m"` |  |
| shannon.fullnode.resources.values.requests.memory | string | `"2Gi"` |  |
| shannon.fullnode.service.type | string | `"ClusterIP"` |  |
| shannon.fullnode.storage.data.enabled | bool | `true` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.accessModes[0] | string | `"ReadWriteOnce"` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.annotations | object | `{}` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.resources.limits.storage | string | `"1500Gi"` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.resources.requests.storage | string | `"1000Gi"` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.selector.matchLabels."app.pocket.network" | string | `"pocket-network-test-shannon"` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.storageClassName | string | `""` |  |
| shannon.fullnode.storage.data.volumeClaimTemplate.volumeMode | string | `"Filesystem"` |  |
| shannon.fullnode.tolerations | list | `[]` |  |
| shannon.fullnode.volumeMounts | list | `[]` |  |
| shannon.fullnode.volumes | list | `[]` |  |
| shannon.relayminer.affinity | object | `{}` |  |
| shannon.relayminer.autoscaling.enabled | bool | `false` |  |
| shannon.relayminer.autoscaling.maxReplicas | int | `100` |  |
| shannon.relayminer.autoscaling.minReplicas | int | `1` |  |
| shannon.relayminer.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| shannon.relayminer.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| shannon.relayminer.cometbft.clientConfig | string | `"# specifies the broadcast mode for the TxService.Broadcast RPC\nbroadcast-mode = \"sync\"\n# name of the targeted chain to send transaction\nchain-id = \"pocket-beta\"\n# specifies where keys are stored\nkeyring-backend = \"test\"\n# rpc interface for the specified chain.\nnode = \"tcp://pocket-network-eddyzags-shannon-fullnode.pocket-network.svc.cluster.local:26657\"\n# client output format (json|text)\noutput = \"text\"\n"` |  |
| shannon.relayminer.config.default_signing_key_names[0] | string | `"supplier1"` |  |
| shannon.relayminer.config.metrics.addr | string | `":9090"` |  |
| shannon.relayminer.config.metrics.enabled | bool | `true` |  |
| shannon.relayminer.config.ping.addr | string | `"localhost:8081"` |  |
| shannon.relayminer.config.ping.enabled | bool | `true` |  |
| shannon.relayminer.config.pocket_node.query_node_grpc_url | string | `"tcp://pocket-network-eddyzags-shannon-fullnode.pocket-network.svc.cluster.local:9090"` |  |
| shannon.relayminer.config.pocket_node.query_node_rpc_url | string | `"tcp://pocket-network-eddyzags-shannon-fullnode.pocket-network.svc.cluster.local:26657"` |  |
| shannon.relayminer.config.pocket_node.tx_node_rpc_url | string | `"tcp://pocket-network-eddyzags-shannon-fullnode.pocket-network.svc.cluster.local:26657"` |  |
| shannon.relayminer.config.pprof.addr | string | `"localhost:6060"` |  |
| shannon.relayminer.config.pprof.enabled | bool | `true` |  |
| shannon.relayminer.config.signing_key_name | string | `"supplier1"` |  |
| shannon.relayminer.config.smt_store_path | string | `"/.pocket/smt"` |  |
| shannon.relayminer.config.suppliers[0].listen_url | string | `"http://0.0.0.0:8545"` |  |
| shannon.relayminer.config.suppliers[0].service_config.backend_url | string | `"http://anvil.apps.svc.cluster.local:8547/"` |  |
| shannon.relayminer.config.suppliers[0].service_config.publicly_exposed_endpoints[0] | string | `"91.168.138.156"` |  |
| shannon.relayminer.config.suppliers[0].service_id | string | `"anvil"` |  |
| shannon.relayminer.containersSecurityContext | object | `{}` |  |
| shannon.relayminer.development.delve.acceptMulticlient | bool | `true` |  |
| shannon.relayminer.development.delve.addr | string | `":40004"` |  |
| shannon.relayminer.development.delve.apiVersion | int | `2` |  |
| shannon.relayminer.development.delve.enabled | bool | `false` |  |
| shannon.relayminer.development.delve.headless | bool | `true` |  |
| shannon.relayminer.enabled | bool | `false` |  |
| shannon.relayminer.gasAdjustment | float | `1.5` |  |
| shannon.relayminer.gasPrices | string | `"0.0001upokt"` |  |
| shannon.relayminer.grpcInsecure | bool | `true` |  |
| shannon.relayminer.image.pullPolicy | string | `"IfNotPresent"` |  |
| shannon.relayminer.image.repository | string | `"ghcr.io/pokt-network/pocketd"` |  |
| shannon.relayminer.image.tag | string | `""` |  |
| shannon.relayminer.imagePullSecrets | list | `[]` |  |
| shannon.relayminer.ingress.annotations | object | `{}` |  |
| shannon.relayminer.ingress.className | string | `""` |  |
| shannon.relayminer.ingress.enabled | bool | `false` |  |
| shannon.relayminer.ingress.hosts | list | `[]` |  |
| shannon.relayminer.ingress.tls | list | `[]` |  |
| shannon.relayminer.initContainersSecurityContext.runAsGroup | int | `1025` |  |
| shannon.relayminer.initContainersSecurityContext.runAsUser | int | `1025` |  |
| shannon.relayminer.keyringBackend | string | `"test"` |  |
| shannon.relayminer.livenessProbe.ping.enabled | bool | `false` |  |
| shannon.relayminer.livenessProbe.ping.initialDelaySeconds | int | `10` |  |
| shannon.relayminer.livenessProbe.ping.periodSeconds | int | `15` |  |
| shannon.relayminer.logs.level | string | `"info"` |  |
| shannon.relayminer.nodeSelector | object | `{}` |  |
| shannon.relayminer.podAnnotations | object | `{}` |  |
| shannon.relayminer.podSecurityContext | object | `{}` |  |
| shannon.relayminer.prometheus.serviceMonitor.enabled | bool | `true` |  |
| shannon.relayminer.replicas | int | `1` |  |
| shannon.relayminer.resources.limits.cpu | string | `"3000m"` |  |
| shannon.relayminer.resources.limits.memory | string | `"3Gi"` |  |
| shannon.relayminer.resources.preset.enabled | bool | `false` |  |
| shannon.relayminer.resources.preset.name | string | `"medium"` |  |
| shannon.relayminer.resources.requests.cpu | string | `"2000m"` |  |
| shannon.relayminer.resources.requests.memory | string | `"2Gi"` |  |
| shannon.relayminer.secret.key.keyName | string | `"supplier1.info"` |  |
| shannon.relayminer.secret.key.name | string | `"pocket-network-eddyzags-shannon-relayminer"` |  |
| shannon.relayminer.secret.type | string | `"Secret"` |  |
| shannon.relayminer.service.type | string | `"ClusterIP"` |  |
| shannon.relayminer.tolerations | list | `[]` |  |
| shannon.relayminer.volumeMounts | list | `[]` |  |
| shannon.relayminer.volumes | list | `[]` |  |
| version | string | `"0.1.1"` |  |

## Troubleshooting

## Upgrading
