# Helm Chart for Pocket Network

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Pocket Network is permissionless decentralized physical infrastructure (DePin) protocol that incentivizes and coordinates a network of node operators to provide open data access to anyone. This repository bootstraps a Pocket Network deployment on a Kubernetes cluster using the Helm package manager.

[Overview of Pocket Network](https://pocket.network/)

## TL;DR
```shell
?> git clone git@github.com:eddyzags/pocket-network-helm-chart.git && cd pocket-helm-chart

?> helm install release-1 . -f shannon-values.yaml
```

# Table of Contents

- [Prerequisites](#prerequisites)
- [Installing the Chart](#installing-the-chart)
- [Configuration and Installation Details](#configuration-and-installation-details)
  - [Customizing relayminer and fullnode using configuration](#customizing-relayminer-and-fullnode-using-configuration)
  - [Provisionning keys](#provisionning-keys)
  - [Resources and limits](#resources-and-limits)
  - [Fullnode persistence](#fullnode-persistence)
    - [Adjust permissions of persistent volume mountpoint](#adjust-permissions-of-persistent-volume-mountpoint)
  - [Prometheus metrics](#prometheus-metrics)
  - [Accessing Pocket Network services from outside the cluster](#accessing-pocket-network-services-from-outside-the-cluster)
  - [Deploy fullnode with Cosmosvisor](#deploy-fullnode-with-cosmosvisor)
- [Parameters](#parameters)

## Prerequisites
* Kubernetes 1.23+
* Helm 3.9.0+
* Provisionning keys for Pocket Network Kubernetes Pods (e.g fullnode and relayminer)

## Installing the Chart

To install the chart with name `my-release`
```
?> git clone git@github.com:eddyzags/pocket-network-helm-chart.git && cd pocket-helm-chart

?> helm install fullnode .  -f shannon-values.yaml
```
> Note: You must specify the value in yaml file. This is an example with the values related to Shannon protocol.

This command deploy a fullnode with default values.

## Configuration and installation details

### Customizing relayminer and fullnode using configuration

### Fullnode

A fullnode requires a more in-depth setup to configure Tendermint (consensus engine), the P2P network, the RPC servers, and the consensus parameters. Additionally, it requires the application-specific settings related to staking, gas, API, block prunning. This chart provides multiple solutions to provision these configuration files.

* Option A) Define the configuration file as input values while installing the chart. This can be useful if you already have these configuration files in your local machine.

```
?> helm install release-1 . -f shannon-values.yaml --set-file 'shannon.fullnode.cometbft.config=config.toml' --set-file 'shannon.fullnode.cometbft.app=app.toml' --set-file 'shannon.fullnode.cometbft.client=client.toml'
```

* Option B) Use Kubernetes `ConfigMap` to mount configuration files. This can be useful if you want to use a single configuration for all your fullnode for example.

```
# values.yaml

shannon:
  fullnode:
    enabled: true
    cometbft:
      volumes:
        enabled: true
        type: ConfigMap
        config:
          key:
            name: pocket-network-release-1-shannon
            configKeyName: config.toml
            clientKeyName: client.toml
            appKeyName: app.toml
```

* Option C) Use default value define in the `shannon-values.yaml`. It can be useful for testing purposes.

```
?> helm install my-release . --f shannon-values.yaml
```

#### Relayminer

A relayminer configuration typically involves service endpoint you want to send relays to, a pocket rpc node (you can use the fullnode of this chart for example) to sign each processed relays. This configuration can be tailored to your need by providing a `shannon.relayminer.config` in the Helm values. This a personalized configuration for the relayminer:

```
# values.yaml

shannon:
  relayminer:
    enabled: true
    config:
      default_signing_key_names: [supplier1]
      smt_store_path: /.pocket/smt
      pocket_node:
        query_node_rpc_url: tcp://node:26657
        query_node_grpc_url: tcp://node:9090
        tx_node_rpc_url: tcp://node:26657
      suppliers:
      - service_id: anvil
        service_config:
          backend_url: http://anvil:8547/
          publicly_exposed_endpoints:
            - relayminer1
        listen_url: http://0.0.0.0:8545
      metrics:
        enabled: true
        addr: :9090
      pprof:
        enabled: true
        addr: localhost:6060
      ping:
        enabled: true
        addr: localhost:8081
```

### Provisionning keys

This section refers to the key management capabilities this chart offers to configure each instance of the Pocket Network which are essential for signing transactions and managing accounts on a Cosmos-based blockchain.

#### Relayminer

In Pocket Network, all relayminers needs one or multiple signing key to sign each relays he serves with a private key. Therefore, each key name listed in `shannon.relayminer.config.default_signing_key_names` must be present in the keyring backend used to start the Relayminer instances.
This example demonstrates how to provision a key through Kubernetes secret while using a `keyring-backend=test`:

```
# values.yaml

shannon:
  relayminer:
    enabled: true
    secret:
      type: Secret
      key:
        name: pocket-network-release-1-shannon-relayminer
        keyName: supplier1.info
```

> Note: Every signing key names (`shannon.relayminer.config.default_signing_key_names`) must have a corresponding secret key. Therefore, if I have `shannon.relayminer.config.default_signing_key_names=["relayminer"]`, we must provide a secret with `shannon.relayminer.secret.key.keyName="relayminer.info"` (name must be the same without file extension .info)

#### Fullnode

A Shannon Fullnode requires two important key files. The node key as a unique identifier for your node on the P2P network used solely for identifying and authenticating with others, and the validator private key used for signing consensus messages (e.g. block proposals, votes). This example demonstrates how to provision a node and validator private key for a fullnode:

```
# values.yaml

shannon:
  fullnode:
    enabled: true
    combetbft:
      secret:
        type: Secret
        key:
          name: pocket-network-release-1-shannon
          nodeKeyName: node_key.json
          privValidatorKeyName: priv_validator_key.json
```

### Resources and limits

Pocket Network charts allow setting resource requests and limits for every containers inside the chart deployment. There are inside the `resources` values.
To make this resource and limit definition easier to define, this chart contains a `resources.preset` attribute that sets the `resources.limits` and `resources.requests`. These presets are recommended by the community, but you can define your own.

```
# values.yaml

shannon:
  fullnode:
    enabled: true
    resources:
      preset:
        enabled: false
        name: medium
      requests:
        cpu: 2000m
        memory: 2Gi
      limits:
        cpu: 3000m
        memory: 3Gi
```

> Note: If the preset is enabled, the templating engine will ignore the `shannon.fullnode.resources.requests` and `shannon.fullnode.resources.limits` fields.

### Fullnode Persistence

The fullnode software stores the various runtime data such as state information, configuration files, and other crucial data required for the operation of a node inside the volume mount of the container. This chart provides multiple options to manage this volume for the fullnode

* Option A) Use an empty data directory to start the fullnode on a clean slate. This can be useful for test purposes.

```
# values.yaml

shannon:
  fullnode:
    enabled: true
    storage:
      data:
      enabled: false
```

> Note: This options doesn't persistent the data across deployments. In other words, if the Kubernetes Pod restarts, you will loose all your data.

* Option B) Use a Persistent Volume Claim (PVC) to start the fullnode on a clean slate, or an existing slate. Persistent Volume Claims are used to keep data across deployments. This integration is known to work in Google Cloud Platform (GCP), Amazon Web services (AWS), on-premise, and minikube.

```
# values.yaml

shannon:
  fullnode:
    enabled: true
    storage:
      data:
      enabled: true
      volumeClaimTemplate:
        annotations: {}
        accessModes: ["ReadWriteOnce"]
        storageClassName: ""
        selector:
          matchLabels:
            app.pocket.network: pocket-network-pv-shannon
        volumeMode: Filesystem
        resources:
          requests:
            storage: 1000Gi
          limits:
            storage: 1500Gi
```

#### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container process can write data into it. Follow this link to know which UID and GID is configured by default for [ghcr.io/pokt-network/pocketd](https://github.com/pokt-network/poktroll/blob/3ba0390f66636f16441bbf53950ae4c8990479ca/Dockerfile.release#L11-L12)

### Prometheus metrics

The applications can be integrated with Prometheus by defining a custom resource to automatically scrapped the metrics.

> Note: A functional installation of Prometheus Operator with the necessary permissions to access required resources in the target namespace is essential for this integration to work.

#### Relayminer

For the relayminer, setting `shannon.relayminer.config.metrics.enabled` and `shannon.relayminer.prometheus.serviceMonitor.enabled` to `true` will send the application metrics to Prometheus. `shannon.relayminer.config.metrics.enabled` exposes a Prometheus endpoint to consume applications metrics. And `shannon.relayminer.prometheus.serviceMonitor.enabled` creates a `ServiceMonitor` custom resource that points to the `shannon.relayminer.config.metrics.addr`.

```
# values.yaml

shannon:
  relayminer:
    enabled: true
    config:
      metrics:
        enabled: true
        addr: :9090
    prometheus:
      serviceMonitor:
        enabled: true
```

#### Fullnode

For the fullnode, the CosmosSDK `shannon.fullnode.cometbft.config` configuration file gives us the ability to activate a prometheus collector connections at a specific endpoint. Every metrics in this [CosmosBFT - Metrics](https://docs.cometbft.com/main/explanation/core/metrics) documentation will be available to you.
When the `prometheus` option is enabled in `config.toml` and an address and port are specified using `prometheus_listen_addr`, this chart automatically adds the port to a Kubernetes Service and creates a corresponding `ServiceMonitor` pointing to it.

An example is available in the default values - [see here](https://github.com/eddyzags/pocket-network-helm-chart/blob/6aca94ba72ee7a792bf71110a399c50596119ce0/shannon-values.yaml#L861-L881)

### Accessing Pocket Network Services from outside the cluster

This section outlines how to configure external access, allowing users to interact with your service through the Pocket Network's decentralized infrastructure.

#### Relayminer

The Relayminer exposes servers, each hosting one or more services that a supplier has staked on-chain to the Pocket Network. This chart provides the ability to expose those servers using a Kubernetes Ingress custom resource. The following example demonstrates how to define external access to two servers for the Relayminer:

```
# values.yaml

shannon:
  relayminer:
    enabled: true
    config:
      suppliers:
      - service_id: anvil
        service_config:
          backend_url: http://anvil:8547/
          publicly_exposed_endpoints:
            - servera.relayminer.example.com
        listen_url: http://0.0.0.0:8545
      - service_id: ollama
        service_config:
          backend_url: http://ollama:8080/
          publicly_exposed_endpoints:
            - serverb.relayminer.example.com
        listen_url: http://0.0.0.0:8546
    ingress:
      enabled: true
      className: ""
      annotations: {}
      tls:
      - hosts:
          - servera.relayminer.example.com
        secretName: servera-realyminer-example-com
      - hosts:
          - serverb.relayminer.example.com
        secretName: serverb-realyminer-example-com
      hosts:
      - host: servera.relayminer.example.com
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: relayminer-service
                port:
                  number: 8545
      - host: serverb.relayminer.example.com
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: relayminer-service
                port:
                  number: 8546
```

> Note: For Kubernetes to route traffic properly, the value of `shannon.relayminer.ingress.hosts[].paths[].backend.service.port.number` must match the port specified in `shannon.relayminer.config.suppliers[].listen_url`.

This example demonstrates how to define an external access with a certificate request using cert-manager.

```
shannon:
  relayminer:
    enabled: true
    config:
      suppliers:
      - service_id: anvil
        service_config:
          backend_url: http://anvil:8547/
          publicly_exposed_endpoints:
            - servera.relayminer.example.com
        listen_url: http://0.0.0.0:8545
      - service_id: ollama
        service_config:
          backend_url: http://ollama:8080/
          publicly_exposed_endpoints:
            - serverb.relayminer.example.com
        listen_url: http://0.0.0.0:8546
    ingress:
      # activates the definition of an ingress resource.
      enabled: true
      className: ""
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-staging
        cert-manager.io/acme-challenge-type: "http01"
        cert-manager.io/acme-http01-edit-in-place: "true"
        cert-manager.io/issue-temporary-certificate: "true"
        cert-manager.io/duration: 2160h
        cert-manager.io/private-key-algorithm: rsa
        cert-manager.io/private-key-encoding: PKCSI
        cert-manager.io/private-key-size: 2048
      tls:
      - hosts:
          - servera.relayminer.example.com
        secretName: pocket-network-shannon-relayminer-servera
      - hosts:
          - serverb.relayminer.example.com
        secretName: pocket-network-shannon-relayminer-serverb
      hosts:
      - host: servera.relayminer.example.com
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: relayminer-service
                port:
                  number: 8545
      - host: serverb.relayminer.example.com
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: relayminer-service
                port:
                  number: 8546
```

#### Fullnode

The fullnode can expose one public-facing port to allow other nodes to connect, query its status, and broadcast transactions. This chart allows configuration of an external service using Kubernetes NodePort, exposing the port on each node’s IP at a static port.

```
shannon:
  fullnode:
    service:
      local:
        type: ClusterIP
      external:
        enabled: true
        type: NodePort
        p2p:
          nodePort: 26656
```

> Note: the `shannon.fullnode.service.local` field creates a Kubernetes Service resource for internal service communication inside the Kubernetes cluster.

### Deploy fullnode with Cosmosvisor

Cosmovisor is a daemon process for Cosmos SDK-based application binaries. It monitors the governance module for on-chain upgrade proposals and automatically manages chain upgrades. This chart provides the ability to configure Cosmovisor for a full node setup.

```
# values.yaml

shannon:
  fullnode:
    enabled: true
    cosmosvisor:
      enabled: true
      daemon:
        name: "pocketd"
        allowDownloadBinaries: true
        restartAfterUpgrade: true
        unsafeSkipBackup: false
        pollInterval: 300ms
        preupgradeMaxRetries: 0
```

> Note: For more informations about what the cosmosvisor daemon does, [read this documentation](https://docs.cosmos.network/v0.45/run-node/cosmovisor.html)

## Parameters

## Values

<table height="400px" >
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td id="homeDirectory">homeDirectory</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"/home/pocket/.pocket"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="network">network</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"testnet-beta"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="protocol">protocol</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"shannon"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--affinity">shannon.fullnode.affinity</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--app">shannon.fullnode.cometbft.app</td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<a href="./shannon-values.yaml">see example in shannon-values.yaml</a>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--client">shannon.fullnode.cometbft.client</td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<a href="./shannon-values.yaml">see example in shannon-values.yaml</a>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--config">shannon.fullnode.cometbft.config</td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<a href="./shannon-values.yaml">see example in shannon-values.yaml</a>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--secret--key--name">shannon.fullnode.cometbft.secret.key.name</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-eddyzags-shannon"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--secret--key--nodeKeyName">shannon.fullnode.cometbft.secret.key.nodeKeyName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"node_key.json"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--secret--key--privValidatorKeyName">shannon.fullnode.cometbft.secret.key.privValidatorKeyName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"priv_validator_key.json"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--secret--type">shannon.fullnode.cometbft.secret.type</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"Secret"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--config--key--appKeyName">shannon.fullnode.cometbft.volumes.config.key.appKeyName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"app.toml"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--config--key--clientKeyName">shannon.fullnode.cometbft.volumes.config.key.clientKeyName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"client.toml"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--config--key--configKeyName">shannon.fullnode.cometbft.volumes.config.key.configKeyName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"config.toml"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--config--key--name">shannon.fullnode.cometbft.volumes.config.key.name</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-fullnode-shannon"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--enabled">shannon.fullnode.cometbft.volumes.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--type">shannon.fullnode.cometbft.volumes.type</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"ConfigMap"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--containersSecurityContext">shannon.fullnode.containersSecurityContext</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--daemon--allowDownloadBinaries">shannon.fullnode.cosmosvisor.daemon.allowDownloadBinaries</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--daemon--name">shannon.fullnode.cosmosvisor.daemon.name</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocketd"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--daemon--pollInterval">shannon.fullnode.cosmosvisor.daemon.pollInterval</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"300ms"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--daemon--preupgradeMaxRetries">shannon.fullnode.cosmosvisor.daemon.preupgradeMaxRetries</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
0
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--daemon--restartAfterUpgrade">shannon.fullnode.cosmosvisor.daemon.restartAfterUpgrade</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--daemon--unsafeSkipBackup">shannon.fullnode.cosmosvisor.daemon.unsafeSkipBackup</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cosmosvisor--enabled">shannon.fullnode.cosmosvisor.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--enabled">shannon.fullnode.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--image--repository">shannon.fullnode.image.repository</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"ghcr.io/pokt-network/pocketd"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--image--tag">shannon.fullnode.image.tag</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
""
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--imagePullSecrets">shannon.fullnode.imagePullSecrets</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--ingress--annotations">shannon.fullnode.ingress.annotations</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--ingress--className">shannon.fullnode.ingress.className</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
""
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--ingress--enabled">shannon.fullnode.ingress.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--ingress--hosts">shannon.fullnode.ingress.hosts</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--ingress--tls">shannon.fullnode.ingress.tls</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--initContainersSecurityContext--runAsGroup">shannon.fullnode.initContainersSecurityContext.runAsGroup</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1025
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--initContainersSecurityContext--runAsUser">shannon.fullnode.initContainersSecurityContext.runAsUser</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1025
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--livenessProbe--enabled">shannon.fullnode.livenessProbe.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--livenessProbe--failureThreshold">shannon.fullnode.livenessProbe.failureThreshold</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
5
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--livenessProbe--initialDelaySeconds">shannon.fullnode.livenessProbe.initialDelaySeconds</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
10
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--livenessProbe--periodSeconds">shannon.fullnode.livenessProbe.periodSeconds</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
15
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--livenessProbe--successThreshold">shannon.fullnode.livenessProbe.successThreshold</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--livenessProbe--timeoutSeconds">shannon.fullnode.livenessProbe.timeoutSeconds</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
5
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--nodeSelector">shannon.fullnode.nodeSelector</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--podAnnotations">shannon.fullnode.podAnnotations</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--podSecurityContext">shannon.fullnode.podSecurityContext</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--resources--preset--enabled">shannon.fullnode.resources.preset.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--resources--preset--name">shannon.fullnode.resources.preset.name</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"medium"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--resources--values--limits--cpu">shannon.fullnode.resources.values.limits.cpu</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"10000m"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--resources--values--limits--memory">shannon.fullnode.resources.values.limits.memory</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"38Gi"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--resources--values--requests--cpu">shannon.fullnode.resources.values.requests.cpu</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"8000m"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--resources--values--requests--memory">shannon.fullnode.resources.values.requests.memory</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"32Gi"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--service--external--enabled">shannon.fullnode.service.external.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--service--external--p2p--nodePort">shannon.fullnode.service.external.p2p.nodePort</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
30000
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--service--external--type">shannon.fullnode.service.external.type</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"NodePort"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--service--local--type">shannon.fullnode.service.local.type</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"ClusterIP"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--enabled">shannon.fullnode.storage.data.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--accessModes[0]">shannon.fullnode.storage.data.volumeClaimTemplate.accessModes[0]</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"ReadWriteOnce"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--annotations">shannon.fullnode.storage.data.volumeClaimTemplate.annotations</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--resources--limits--storage">shannon.fullnode.storage.data.volumeClaimTemplate.resources.limits.storage</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"1500Gi"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--resources--requests--storage">shannon.fullnode.storage.data.volumeClaimTemplate.resources.requests.storage</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"1000Gi"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--selector--matchLabels--"app--pocket--network"">shannon.fullnode.storage.data.volumeClaimTemplate.selector.matchLabels."app.pocket.network"</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-test-shannon"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--storageClassName">shannon.fullnode.storage.data.volumeClaimTemplate.storageClassName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
""
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--volumeMode">shannon.fullnode.storage.data.volumeClaimTemplate.volumeMode</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"Filesystem"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--telemetry--logs--format">shannon.fullnode.telemetry.logs.format</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"json"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--telemetry--logs--level">shannon.fullnode.telemetry.logs.level</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"info"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--telemetry--logs--noColor">shannon.fullnode.telemetry.logs.noColor</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--telemetry--trace--enabled">shannon.fullnode.telemetry.trace.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--telemetry--trace--store">shannon.fullnode.telemetry.trace.store</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
""
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--tolerations">shannon.fullnode.tolerations</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--volumeMounts">shannon.fullnode.volumeMounts</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--volumes">shannon.fullnode.volumes</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--affinity">shannon.relayminer.affinity</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--autoscaling--enabled">shannon.relayminer.autoscaling.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--autoscaling--maxReplicas">shannon.relayminer.autoscaling.maxReplicas</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
100
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--autoscaling--minReplicas">shannon.relayminer.autoscaling.minReplicas</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--autoscaling--targetCPUUtilizationPercentage">shannon.relayminer.autoscaling.targetCPUUtilizationPercentage</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
80
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--autoscaling--targetMemoryUtilizationPercentage">shannon.relayminer.autoscaling.targetMemoryUtilizationPercentage</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
80
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--cometbft--clientConfig">shannon.relayminer.cometbft.clientConfig</td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<a href="./shannon-values.yaml">see example in shannon-values.yaml</a>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--default_signing_key_names[0]">shannon.relayminer.config.default_signing_key_names[0]</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"supplier1"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--metrics--addr">shannon.relayminer.config.metrics.addr</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
":9090"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--metrics--enabled">shannon.relayminer.config.metrics.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--ping--addr">shannon.relayminer.config.ping.addr</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
":8081"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--ping--enabled">shannon.relayminer.config.ping.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--pocket_node--query_node_grpc_url">shannon.relayminer.config.pocket_node.query_node_grpc_url</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"tcp://node:9090"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--pocket_node--query_node_rpc_url">shannon.relayminer.config.pocket_node.query_node_rpc_url</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"tcp://node:26657"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--pocket_node--tx_node_rpc_url">shannon.relayminer.config.pocket_node.tx_node_rpc_url</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"tcp://node:26657"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--pprof--addr">shannon.relayminer.config.pprof.addr</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
":6060"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--pprof--enabled">shannon.relayminer.config.pprof.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--smt_store_path">shannon.relayminer.config.smt_store_path</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"/.pocket/smt"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--suppliers[0]--listen_url">shannon.relayminer.config.suppliers[0].listen_url</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"http://0.0.0.0:8545"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--suppliers[0]--service_config--backend_url">shannon.relayminer.config.suppliers[0].service_config.backend_url</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"http://anvil:8547/"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--suppliers[0]--service_config--publicly_exposed_endpoints[0]">shannon.relayminer.config.suppliers[0].service_config.publicly_exposed_endpoints[0]</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"relayminer1"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--suppliers[0]--service_id">shannon.relayminer.config.suppliers[0].service_id</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"anvil"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--containersSecurityContext">shannon.relayminer.containersSecurityContext</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--development--delve--acceptMulticlient">shannon.relayminer.development.delve.acceptMulticlient</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--development--delve--addr">shannon.relayminer.development.delve.addr</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
":40004"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--development--delve--apiVersion">shannon.relayminer.development.delve.apiVersion</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
2
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--development--delve--enabled">shannon.relayminer.development.delve.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--development--delve--headless">shannon.relayminer.development.delve.headless</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--enabled">shannon.relayminer.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--gasAdjustment">shannon.relayminer.gasAdjustment</td>
			<td>
float
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1.5
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--gasPrices">shannon.relayminer.gasPrices</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"0.0001upokt"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--grpcInsecure">shannon.relayminer.grpcInsecure</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--image--pullPolicy">shannon.relayminer.image.pullPolicy</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"IfNotPresent"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--image--repository">shannon.relayminer.image.repository</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"ghcr.io/pokt-network/pocketd"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--image--tag">shannon.relayminer.image.tag</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
""
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--imagePullSecrets">shannon.relayminer.imagePullSecrets</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--ingress--annotations">shannon.relayminer.ingress.annotations</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--ingress--className">shannon.relayminer.ingress.className</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"external"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--ingress--enabled">shannon.relayminer.ingress.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--ingress--hosts">shannon.relayminer.ingress.hosts</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--ingress--tls">shannon.relayminer.ingress.tls</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--initContainersSecurityContext--runAsGroup">shannon.relayminer.initContainersSecurityContext.runAsGroup</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1025
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--initContainersSecurityContext--runAsUser">shannon.relayminer.initContainersSecurityContext.runAsUser</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1025
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--keyringBackend">shannon.relayminer.keyringBackend</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"test"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--livenessProbe--ping--enabled">shannon.relayminer.livenessProbe.ping.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--livenessProbe--ping--initialDelaySeconds">shannon.relayminer.livenessProbe.ping.initialDelaySeconds</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
10
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--livenessProbe--ping--periodSeconds">shannon.relayminer.livenessProbe.ping.periodSeconds</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
15
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--nodeSelector">shannon.relayminer.nodeSelector</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--podAnnotations">shannon.relayminer.podAnnotations</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--podSecurityContext">shannon.relayminer.podSecurityContext</td>
			<td>
object
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{}
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--prometheus--serviceMonitor--enabled">shannon.relayminer.prometheus.serviceMonitor.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
true
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--replicas">shannon.relayminer.replicas</td>
			<td>
int
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
1
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--resources--limits--cpu">shannon.relayminer.resources.limits.cpu</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"3000m"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--resources--limits--memory">shannon.relayminer.resources.limits.memory</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"3Gi"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--resources--preset--enabled">shannon.relayminer.resources.preset.enabled</td>
			<td>
bool
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
false
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--resources--preset--name">shannon.relayminer.resources.preset.name</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"medium"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--resources--requests--cpu">shannon.relayminer.resources.requests.cpu</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"2000m"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--resources--requests--memory">shannon.relayminer.resources.requests.memory</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"2Gi"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--secret--key--keyName">shannon.relayminer.secret.key.keyName</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"supplier1.info"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--secret--key--name">shannon.relayminer.secret.key.name</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-supplier-shannon-relayminer"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--secret--type">shannon.relayminer.secret.type</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"Secret"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--service--type">shannon.relayminer.service.type</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"ClusterIP"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--telemetry--logs--level">shannon.relayminer.telemetry.logs.level</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"info"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--tolerations">shannon.relayminer.tolerations</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--volumeMounts">shannon.relayminer.volumeMounts</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--volumes">shannon.relayminer.volumes</td>
			<td>
list
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
[]
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="version">version</td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"0.1.3"
</pre>
</div>
			</td>
			<td></td>
		</tr>
	</tbody>
</table>

