# Helm Chart package for Pocket Network

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Pocket Network is permissionless decentralized physical infrastructure (DePin) protocol that incentivizes and coordinates a network of node operators to provide open data access to anyone. This repository bootstraps a Pocket Network deployment on a Kubernetes cluster using the Helm package manager.

[Overview of Pocket Network](https://pocket.network/)

## TL;DR
```shell
?> helm install release-1 https://github.com/eddyzags/pocket-network-helm-charts
```

## Introduction

## Prerequisites

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
			<td id="homeDirectory"><a href="./values.yaml#L24">homeDirectory</a></td>
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
			<td id="network"><a href="./values.yaml#L13">network</a></td>
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
			<td id="protocol"><a href="./values.yaml#L7">protocol</a></td>
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
			<td id="shannon--fullnode--affinity"><a href="./values.yaml#L1338">shannon.fullnode.affinity</a></td>
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
			<td id="shannon--fullnode--cometbft--app"><a href="./values.yaml#L883">shannon.fullnode.cometbft.app</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"# This is a TOML config file.\n# For more information, see https://github.com/toml-lang/toml\n\n###############################################################################\n###                           Base Configuration                            ###\n###############################################################################\n\n# The minimum gas prices a validator is willing to accept for processing a\n# transaction. A transaction's fees must meet the minimum of any denomination\n# specified in this config (e.g. 0.25token1,0.0001token2).\nminimum-gas-prices = \"0.000000001upokt\"\n\n# The maximum gas a query coming over rest/grpc may consume.\n# If this is set to zero, the query can consume an unbounded amount of gas.\nquery-gas-limit = \"0\"\n\n# default: the last 362880 states are kept, pruning at 10 block intervals\n# nothing: all historic states will be saved, nothing will be deleted (i.e. archiving node)\n# everything: 2 latest states will be kept; pruning at 10 block intervals.\n# custom: allow pruning options to be manually specified through 'pruning-keep-recent', and 'pruning-interval'\npruning = \"nothing\"\n\n# These are applied if and only if the pruning strategy is custom.\npruning-keep-recent = \"0\"\npruning-interval = \"0\"\n\n# HaltHeight contains a non-zero block height at which a node will gracefully\n# halt and shutdown that can be used to assist upgrades and testing.\n#\n# Note: Commitment of state will be attempted on the corresponding block.\nhalt-height = 0\n\n# HaltTime contains a non-zero minimum block time (in Unix seconds) at which\n# a node will gracefully halt and shutdown that can be used to assist upgrades\n# and testing.\n#\n# Note: Commitment of state will be attempted on the corresponding block.\nhalt-time = 0\n\n# MinRetainBlocks defines the minimum block height offset from the current\n# block being committed, such that all blocks past this offset are pruned\n# from CometBFT. It is used as part of the process of determining the\n# ResponseCommit.RetainHeight value during ABCI Commit. A value of 0 indicates\n# that no blocks should be pruned.\n#\n# This configuration value is only responsible for pruning CometBFT blocks.\n# It has no bearing on application state pruning which is determined by the\n# \"pruning-*\" configurations.\n#\n# Note: CometBFT block pruning is dependent on this parameter in conjunction\n# with the unbonding (safety threshold) period, state pruning and state sync\n# snapshot parameters to determine the correct minimum value of\n# ResponseCommit.RetainHeight.\nmin-retain-blocks = 0\n\n# InterBlockCache enables inter-block caching.\ninter-block-cache = true\n\n# IndexEvents defines the set of events in the form {eventType}.{attributeKey},\n# which informs CometBFT what to index. If empty, all events will be indexed.\n#\n# Example:\n# [\"message.sender\", \"message.recipient\"]\nindex-events = []\n\n# IavlCacheSize set the size of the iavl tree cache (in number of nodes).\niavl-cache-size = 781250\n\n# IAVLDisableFastNode enables or disables the fast node feature of IAVL.\n# Default is false.\niavl-disable-fastnode = false\n\n# AppDBBackend defines the database backend type to use for the application and snapshots DBs.\n# An empty string indicates that a fallback will be used.\n# The fallback is the db_backend value set in CometBFT's config.toml.\napp-db-backend = \"\"\n\n###############################################################################\n###                         Telemetry Configuration                         ###\n###############################################################################\n\n[telemetry]\n\n# Prefixed with keys to separate services.\nservice-name = \"\"\n\n# Enabled enables the application telemetry functionality. When enabled,\n# an in-memory sink is also enabled by default. Operators may also enabled\n# other sinks such as Prometheus.\nenabled = false\n\n# Enable prefixing gauge values with hostname.\nenable-hostname = false\n\n# Enable adding hostname to labels.\nenable-hostname-label = false\n\n# Enable adding service to labels.\nenable-service-label = false\n\n# PrometheusRetentionTime, when positive, enables a Prometheus metrics sink.\nprometheus-retention-time = \"1800\"\n\n# GlobalLabels defines a global set of name/value label tuples applied to all\n# metrics emitted using the wrapper functions defined in telemetry package.\n#\n# Example:\n# [[\"chain_id\", \"cosmoshub-1\"]]\nglobal-labels = [[\"chain_id\"], [\"pocket-beta\"]]\n\n# MetricsSink defines the type of metrics sink to use.\nmetrics-sink = \"mem\"\n\n# StatsdAddr defines the address of a statsd server to send metrics to.\n# Only utilized if MetricsSink is set to \"statsd\" or \"dogstatsd\".\nstatsd-addr = \"\"\n\n# DatadogHostname defines the hostname to use when emitting metrics to\n# Datadog. Only utilized if MetricsSink is set to \"dogstatsd\".\ndatadog-hostname = \"\"\n\n###############################################################################\n###                           API Configuration                             ###\n###############################################################################\n\n[api]\n\n# Enable defines if the API server should be enabled.\nenable = true\n\n# Swagger defines if swagger documentation should automatically be registered.\nswagger = false\n\n# Address defines the API server to listen on.\naddress = \"tcp://localhost:1317\"\n\n# MaxOpenConnections defines the number of maximum open connections.\nmax-open-connections = 1000\n\n# RPCReadTimeout defines the CometBFT RPC read timeout (in seconds).\nrpc-read-timeout = 10\n\n# RPCWriteTimeout defines the CometBFT RPC write timeout (in seconds).\nrpc-write-timeout = 0\n\n# RPCMaxBodyBytes defines the CometBFT maximum request body (in bytes).\nrpc-max-body-bytes = 1000000\n\n# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).\nenabled-unsafe-cors = true\n\n###############################################################################\n###                           gRPC Configuration                            ###\n###############################################################################\n\n[grpc]\n\n# Enable defines if the gRPC server should be enabled.\nenable = true\n\n# Address defines the gRPC server address to bind to.\naddress = \"localhost:9090\"\n\n# MaxRecvMsgSize defines the max message size in bytes the server can receive.\n# The default value is 10MB.\nmax-recv-msg-size = \"10485760\"\n\n# MaxSendMsgSize defines the max message size in bytes the server can send.\n# The default value is math.MaxInt32.\nmax-send-msg-size = \"2147483647\"\n\n# SkipCheckHeader defines if the gRPC server should bypass check header.\nskip-check-header = false\n\n###############################################################################\n###                        gRPC Web Configuration                           ###\n###############################################################################\n[grpc-web]\n\n# GRPCWebEnable defines if the gRPC-web should be enabled.\n# NOTE: gRPC must also be enabled, otherwise, this configuration is a no-op.\nenable = true\n\n# Address defines the gRPC-web server address to bind to.\naddress = \"localhost:9091\"\n\n# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).\nenable-unsafe-cors = true\n\n###############################################################################\n###                        State Sync Configuration                         ###\n###############################################################################\n\n# State sync snapshots allow other nodes to rapidly join the network without replaying historical\n# blocks, instead downloading and applying a snapshot of the application state at a given height.\n[state-sync]\n\n# snapshot-interval specifies the block interval at which local state sync snapshots are\n# taken (0 to disable).\nsnapshot-interval = 0\n\n# snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).\nsnapshot-keep-recent = 2\n\n###############################################################################\n###                              State Streaming                            ###\n###############################################################################\n\n# Streaming allows nodes to stream state to external systems.\n[streaming]\n\n# streaming.abci specifies the configuration for the ABCI Listener streaming service.\n[streaming.abci]\n\n# List of kv store keys to stream out via gRPC.\n# The store key names MUST match the module's StoreKey name.\n#\n# Example:\n# [\"acc\", \"bank\", \"gov\", \"staking\", \"mint\"[,...]]\n# [\"*\"] to expose all keys.\nkeys = []\n\n# The plugin name used for streaming via gRPC.\n# Streaming is only enabled if this is set.\n# Supported plugins: abci\nplugin = \"\"\n\n# stop-node-on-err specifies whether to stop the node on message delivery error.\nstop-node-on-err = true\n\n###############################################################################\n###                         Mempool                                         ###\n###############################################################################\n\n[mempool]\n\n# Setting max-txs to 0 will allow for a unbounded amount of transactions in the mempool.\n# Setting max_txs to negative 1 (-1) will disable transactions from being inserted into the mempool (no-op mempool).\n# Setting max_txs to a positive number (\u003e 0) will limit the number of transactions in the mempool, by the specified amount.\n#\n# Note, this configuration only applies to SDK built-in app-side mempool\n# implementations.\nmax-txs = 10000\n\n###############################################################################\n###                         Poktroll App Config                             ###\n###############################################################################\n\n[poktroll]\n\n  [poktroll.telemetry]\n\n  cardinality-level = \"medium\"\n"
</pre>
</div>
			</td>
			<td> @description ""</td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--client"><a href="./values.yaml#L1139">shannon.fullnode.cometbft.client</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"# specifies the broadcast mode for the TxService.Broadcast RPC\nbroadcast-mode = \"sync\"\n# name of the targeted chain to send transaction\nchain-id = \"pocket-beta\"\n# specifies where keys are stored\nkeyring-backend = \"test\"\n# rpc interface for the specified chain.\nnode = \"tcp://node:26657\"\n# client output format (json|text)\noutput = \"json\"\n"
</pre>
</div>
			</td>
			<td> @description ""</td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--config"><a href="./values.yaml#L382">shannon.fullnode.cometbft.config</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"# This is a TOML config file.\n# For more information, see https://github.com/toml-lang/toml\n\n# NOTE: Any path below can be absolute (e.g. \"/var/myawesomeapp/data\") or\n# relative to the home directory (e.g. \"data\"). The home directory is\n# \"$HOME/.cometbft\" by default, but could be changed via $CMTHOME env variable\n# or --home cmd flag.\n\n# The version of the CometBFT binary that created or\n# last modified the config file. Do not modify this.\nversion = \"0.38.10\"\n\n#######################################################################\n###                   Main Base Config Options                      ###\n#######################################################################\n\n# TCP or UNIX socket address of the ABCI application,\n# or the name of an ABCI application compiled in with the CometBFT binary\nproxy_app = \"tcp://127.0.0.1:26658\"\n\n# A custom human readable name for this node\nmoniker = \"node1\"\n\n# Database backend: goleveldb | cleveldb | boltdb | rocksdb | badgerdb\n# * goleveldb (github.com/syndtr/goleveldb - most popular implementation)\n#   - pure go\n#   - stable\n# * cleveldb (uses levigo wrapper)\n#   - fast\n#   - requires gcc\n#   - use cleveldb build tag (go build -tags cleveldb)\n# * boltdb (uses etcd's fork of bolt - github.com/etcd-io/bbolt)\n#   - EXPERIMENTAL\n#   - may be faster is some use-cases (random reads - indexer)\n#   - use boltdb build tag (go build -tags boltdb)\n# * rocksdb (uses github.com/tecbot/gorocksdb)\n#   - EXPERIMENTAL\n#   - requires gcc\n#   - use rocksdb build tag (go build -tags rocksdb)\n# * badgerdb (uses github.com/dgraph-io/badger)\n#   - EXPERIMENTAL\n#   - use badgerdb build tag (go build -tags badgerdb)\ndb_backend = \"goleveldb\"\n\n# Database directory\ndb_dir = \"data\"\n\n# Output level for logging, including package level options\nlog_level = \"info\"\n\n# Output format: 'plain' (colored text) or 'json'\nlog_format = \"plain\"\n\n##### additional base config options #####\n\n# Path to the JSON file containing the initial validator set and other meta data\ngenesis_file = \"config/genesis.json\"\n\n# Path to the JSON file containing the private key to use as a validator in the consensus protocol\npriv_validator_key_file = \"config/priv_validator_key.json\"\n\n# Path to the JSON file containing the last sign state of a validator\npriv_validator_state_file = \"data/priv_validator_state.json\"\n\n# TCP or UNIX socket address for CometBFT to listen on for\n# connections from an external PrivValidator process\npriv_validator_laddr = \"\"\n\n# Path to the JSON file containing the private key to use for node authentication in the p2p protocol\nnode_key_file = \"config/node_key.json\"\n\n# Mechanism to connect to the ABCI application: socket | grpc\nabci = \"socket\"\n\n# If true, query the ABCI app on connecting to a new peer\n# so the app can decide if we should keep the connection or not\nfilter_peers = false\n\n\n#######################################################################\n###                 Advanced Configuration Options                  ###\n#######################################################################\n\n#######################################################\n###       RPC Server Configuration Options          ###\n#######################################################\n[rpc]\n\n# TCP or UNIX socket address for the RPC server to listen on\nladdr = \"tcp://0.0.0.0:26657\"\n\n# A list of origins a cross-domain request can be executed from\n# Default value '[]' disables cors support\n# Use '[\"*\"]' to allow any origin\ncors_allowed_origins = [\"*\", ]\n\n# A list of methods the client is allowed to use with cross-domain requests\ncors_allowed_methods = [\"HEAD\", \"GET\", \"POST\", ]\n\n# A list of non simple headers the client is allowed to use with cross-domain requests\ncors_allowed_headers = [\"Origin\", \"Accept\", \"Content-Type\", \"X-Requested-With\", \"X-Server-Time\", ]\n\n# TCP or UNIX socket address for the gRPC server to listen on\n# NOTE: This server only supports /broadcast_tx_commit\ngrpc_laddr = \"\"\n\n# Maximum number of simultaneous connections.\n# Does not include RPC (HTTP\u0026WebSocket) connections. See max_open_connections\n# If you want to accept a larger number than the default, make sure\n# you increase your OS limits.\n# 0 - unlimited.\n# Should be \u003c {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}\n# 1024 - 40 - 10 - 50 = 924 = ~900\ngrpc_max_open_connections = 900\n\n# Activate unsafe RPC commands like /dial_seeds and /unsafe_flush_mempool\nunsafe = false\n\n# Maximum number of simultaneous connections (including WebSocket).\n# Does not include gRPC connections. See grpc_max_open_connections\n# If you want to accept a larger number than the default, make sure\n# you increase your OS limits.\n# 0 - unlimited.\n# Should be \u003c {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}\n# 1024 - 40 - 10 - 50 = 924 = ~900\nmax_open_connections = 900\n\n# Maximum number of unique clientIDs that can /subscribe\n# If you're using /broadcast_tx_commit, set to the estimated maximum number\n# of broadcast_tx_commit calls per block.\nmax_subscription_clients = 100\n\n# Maximum number of unique queries a given client can /subscribe to\n# If you're using GRPC (or Local RPC client) and /broadcast_tx_commit, set to\n# the estimated # maximum number of broadcast_tx_commit calls per block.\nmax_subscriptions_per_client = 5\n\n# Experimental parameter to specify the maximum number of events a node will\n# buffer, per subscription, before returning an error and closing the\n# subscription. Must be set to at least 100, but higher values will accommodate\n# higher event throughput rates (and will use more memory).\nexperimental_subscription_buffer_size = 200\n\n# Experimental parameter to specify the maximum number of RPC responses that\n# can be buffered per WebSocket client. If clients cannot read from the\n# WebSocket endpoint fast enough, they will be disconnected, so increasing this\n# parameter may reduce the chances of them being disconnected (but will cause\n# the node to use more memory).\n#\n# Must be at least the same as \"experimental_subscription_buffer_size\",\n# otherwise connections could be dropped unnecessarily. This value should\n# ideally be somewhat higher than \"experimental_subscription_buffer_size\" to\n# accommodate non-subscription-related RPC responses.\nexperimental_websocket_write_buffer_size = 200\n\n# If a WebSocket client cannot read fast enough, at present we may\n# silently drop events instead of generating an error or disconnecting the\n# client.\n#\n# Enabling this experimental parameter will cause the WebSocket connection to\n# be closed instead if it cannot read fast enough, allowing for greater\n# predictability in subscription behavior.\nexperimental_close_on_slow_client = false\n\n# How long to wait for a tx to be committed during /broadcast_tx_commit.\n# WARNING: Using a value larger than 10s will result in increasing the\n# global HTTP write timeout, which applies to all connections and endpoints.\n# See https://github.com/tendermint/tendermint/issues/3435\ntimeout_broadcast_tx_commit = \"10s\"\n\n# Maximum number of requests that can be sent in a batch\n# If the value is set to '0' (zero-value), then no maximum batch size will be\n# enforced for a JSON-RPC batch request.\nmax_request_batch_size = 10\n\n# Maximum size of request body, in bytes\nmax_body_bytes = 1000000\n\n# Maximum size of request header, in bytes\nmax_header_bytes = 1048576\n\n# The path to a file containing certificate that is used to create the HTTPS server.\n# Might be either absolute path or path related to CometBFT's config directory.\n# If the certificate is signed by a certificate authority,\n# the certFile should be the concatenation of the server's certificate, any intermediates,\n# and the CA's certificate.\n# NOTE: both tls_cert_file and tls_key_file must be present for CometBFT to create HTTPS server.\n# Otherwise, HTTP server is run.\ntls_cert_file = \"\"\n\n# The path to a file containing matching private key that is used to create the HTTPS server.\n# Might be either absolute path or path related to CometBFT's config directory.\n# NOTE: both tls-cert-file and tls-key-file must be present for CometBFT to create HTTPS server.\n# Otherwise, HTTP server is run.\ntls_key_file = \"\"\n\n# pprof listen address (https://golang.org/pkg/net/http/pprof)\npprof_laddr = \"localhost:6060\"\n\n#######################################################\n###           P2P Configuration Options             ###\n#######################################################\n[p2p]\n\n# Address to listen for incoming connections\nladdr = \"tcp://0.0.0.0:26656\"\n\n# Address to advertise to peers for them to dial. If empty, will use the same\n# port as the laddr, and will introspect on the listener to figure out the\n# address. IP and port are required. Example: 159.89.10.97:26656\nexternal_address = \"\"\n\n# Comma separated list of seed nodes to connect to\nseeds = \"78e64eb51f040b86b8e4bed6ba8d895fa2f87839@shannon-grove-seed1.beta.poktroll.com:26656\"\n\n# Comma separated list of nodes to keep persistent connections to\npersistent_peers = \"78e64eb51f040b86b8e4bed6ba8d895fa2f87839@shannon-grove-seed1.beta.poktroll.com:26656\"\n\n# Path to address book\naddr_book_file = \"config/addrbook.json\"\n\n# Set true for strict address routability rules\n# Set false for private or local networks\naddr_book_strict = true\n\n# Maximum number of inbound peers\nmax_num_inbound_peers = 40\n\n# Maximum number of outbound peers to connect to, excluding persistent peers\nmax_num_outbound_peers = 10\n\n# List of node IDs, to which a connection will be (re)established ignoring any existing limits\nunconditional_peer_ids = \"\"\n\n# Maximum pause when redialing a persistent peer (if zero, exponential backoff is used)\npersistent_peers_max_dial_period = \"0s\"\n\n# Time to wait before flushing messages out on the connection\nflush_throttle_timeout = \"100ms\"\n\n# Maximum size of a message packet payload, in bytes\nmax_packet_msg_payload_size = 1024\n\n# Rate at which packets can be sent, in bytes/second\nsend_rate = 5120000\n\n# Rate at which packets can be received, in bytes/second\nrecv_rate = 5120000\n\n# Set true to enable the peer-exchange reactor\npex = true\n\n# Seed mode, in which node constantly crawls the network and looks for\n# peers. If another node asks it for addresses, it responds and disconnects.\n#\n# Does not work if the peer-exchange reactor is disabled.\nseed_mode = false\n\n# Comma separated list of peer IDs to keep private (will not be gossiped to other peers)\nprivate_peer_ids = \"\"\n\n# Toggle to disable guard against peers connecting from the same ip.\nallow_duplicate_ip = false\n\n# Peer connection configuration.\nhandshake_timeout = \"20s\"\ndial_timeout = \"3s\"\n\n#######################################################\n###          Mempool Configuration Options          ###\n#######################################################\n[mempool]\n\n# The type of mempool for this node to use.\n#\n#  Possible types:\n#  - \"flood\" : concurrent linked list mempool with flooding gossip protocol\n#  (default)\n#  - \"nop\"   : nop-mempool (short for no operation; the ABCI app is responsible\n#  for storing, disseminating and proposing txs). \"create_empty_blocks=false\" is\n#  not supported.\ntype = \"flood\"\n\n# Recheck (default: true) defines whether CometBFT should recheck the\n# validity for all remaining transaction in the mempool after a block.\n# Since a block affects the application state, some transactions in the\n# mempool may become invalid. If this does not apply to your application,\n# you can disable rechecking.\nrecheck = true\n\n# recheck_timeout is the time the application has during the rechecking process\n# to return CheckTx responses, once all requests have been sent. Responses that \n# arrive after the timeout expires are discarded. It only applies to \n# non-local ABCI clients and when recheck is enabled.\n#\n# The ideal value will strongly depend on the application. It could roughly be estimated as the\n# average size of the mempool multiplied by the average time it takes the application to validate one\n# transaction. We consider that the ABCI application runs in the same location as the CometBFT binary\n# so that the recheck duration is not affected by network delays when making requests and receiving responses.\nrecheck_timeout = \"1s\"\n\n# Broadcast (default: true) defines whether the mempool should relay\n# transactions to other peers. Setting this to false will stop the mempool\n# from relaying transactions to other peers until they are included in a\n# block. In other words, if Broadcast is disabled, only the peer you send\n# the tx to will see it until it is included in a block.\nbroadcast = true\n\n# WalPath (default: \"\") configures the location of the Write Ahead Log\n# (WAL) for the mempool. The WAL is disabled by default. To enable, set\n# WalPath to where you want the WAL to be written (e.g.\n# \"data/mempool.wal\").\nwal_dir = \"\"\n\n# Maximum number of transactions in the mempool\nsize = 5000\n\n# Limit the total size of all txs in the mempool.\n# This only accounts for raw transactions (e.g. given 1MB transactions and\n# max_txs_bytes=5MB, mempool will only accept 5 transactions).\nmax_txs_bytes = 1073741824\n\n# Size of the cache (used to filter transactions we saw earlier) in transactions\ncache_size = 10000\n\n# Do not remove invalid transactions from the cache (default: false)\n# Set to true if it's not possible for any invalid transaction to become valid\n# again in the future.\nkeep-invalid-txs-in-cache = false\n\n# Maximum size of a single transaction.\n# NOTE: the max size of a tx transmitted over the network is {max_tx_bytes}.\nmax_tx_bytes = 1048576\n\n# Maximum size of a batch of transactions to send to a peer\n# Including space needed by encoding (one varint per transaction).\n# XXX: Unused due to https://github.com/tendermint/tendermint/issues/5796\nmax_batch_bytes = 0\n\n# Experimental parameters to limit gossiping txs to up to the specified number of peers.\n# We use two independent upper values for persistent and non-persistent peers.\n# Unconditional peers are not affected by this feature.\n# If we are connected to more than the specified number of persistent peers, only send txs to\n# ExperimentalMaxGossipConnectionsToPersistentPeers of them. If one of those\n# persistent peers disconnects, activate another persistent peer.\n# Similarly for non-persistent peers, with an upper limit of\n# ExperimentalMaxGossipConnectionsToNonPersistentPeers.\n# If set to 0, the feature is disabled for the corresponding group of peers, that is, the\n# number of active connections to that group of peers is not bounded.\n# For non-persistent peers, if enabled, a value of 10 is recommended based on experimental\n# performance results using the default P2P configuration.\nexperimental_max_gossip_connections_to_persistent_peers = 0\nexperimental_max_gossip_connections_to_non_persistent_peers = 0\n\n#######################################################\n###         State Sync Configuration Options        ###\n#######################################################\n[statesync]\n# State sync rapidly bootstraps a new node by discovering, fetching, and restoring a state machine\n# snapshot from peers instead of fetching and replaying historical blocks. Requires some peers in\n# the network to take and serve state machine snapshots. State sync is not attempted if the node\n# has any local state (LastBlockHeight \u003e 0). The node will have a truncated block history,\n# starting from the height of the snapshot.\nenable = false\n\n# RPC servers (comma-separated) for light client verification of the synced state machine and\n# retrieval of state data for node bootstrapping. Also needs a trusted height and corresponding\n# header hash obtained from a trusted source, and a period during which validators can be trusted.\n#\n# For Cosmos SDK-based chains, trust_period should usually be about 2/3 of the unbonding time (~2\n# weeks) during which they can be financially punished (slashed) for misbehavior.\nrpc_servers = \"\"\ntrust_height = 0\ntrust_hash = \"\"\ntrust_period = \"168h0m0s\"\n\n# Time to spend discovering snapshots before initiating a restore.\ndiscovery_time = \"15s\"\n\n# Temporary directory for state sync snapshot chunks, defaults to the OS tempdir (typically /tmp).\n# Will create a new, randomly named directory within, and remove it when done.\ntemp_dir = \"\"\n\n# The timeout duration before re-requesting a chunk, possibly from a different\n# peer (default: 1 minute).\nchunk_request_timeout = \"10s\"\n\n# The number of concurrent chunk fetchers to run (default: 1).\nchunk_fetchers = \"4\"\n\n#######################################################\n###       Block Sync Configuration Options          ###\n#######################################################\n[blocksync]\n\n# Block Sync version to use:\n#\n# In v0.37, v1 and v2 of the block sync protocols were deprecated.\n# Please use v0 instead.\n#\n#   1) \"v0\" - the default block sync implementation\nversion = \"v0\"\n\n#######################################################\n###         Consensus Configuration Options         ###\n#######################################################\n[consensus]\n\nwal_file = \"data/cs.wal/wal\"\n\n# How long we wait for a proposal block before prevoting nil\ntimeout_propose = \"5m0s\"\n# How much timeout_propose increases with each round\ntimeout_propose_delta = \"5s\"\n# How long we wait after receiving +2/3 prevotes for “anything” (ie. not a single block or nil)\ntimeout_prevote = \"10s\"\n# How much the timeout_prevote increases with each round\ntimeout_prevote_delta = \"5s\"\n# How long we wait after receiving +2/3 precommits for “anything” (ie. not a single block or nil)\ntimeout_precommit = \"10s\"\n# How much the timeout_precommit increases with each round\ntimeout_precommit_delta = \"5s\"\n# How long we wait after committing a block, before starting on the new\n# height (this gives us a chance to receive some more precommits, even\n# though we already have +2/3).\ntimeout_commit = \"5m0s\"\n\n# How many blocks to look back to check existence of the node's consensus votes before joining consensus\n# When non-zero, the node will panic upon restart\n# if the same consensus key was used to sign {double_sign_check_height} last blocks.\n# So, validators should stop the state machine, wait for some blocks, and then restart the state machine to avoid panic.\ndouble_sign_check_height = 0\n\n# Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)\nskip_timeout_commit = false\n\n# EmptyBlocks mode and possible interval between empty blocks\ncreate_empty_blocks = true\ncreate_empty_blocks_interval = \"0s\"\n\n# Reactor sleep duration parameters\npeer_gossip_sleep_duration = \"100ms\"\npeer_query_maj23_sleep_duration = \"2s\"\n\n#######################################################\n###         Storage Configuration Options           ###\n#######################################################\n[storage]\n\n# Set to true to discard ABCI responses from the state store, which can save a\n# considerable amount of disk space. Set to false to ensure ABCI responses are\n# persisted. ABCI responses are required for /block_results RPC queries, and to\n# reindex events in the command-line tool.\ndiscard_abci_responses = false\n\n#######################################################\n###   Transaction Indexer Configuration Options     ###\n#######################################################\n[tx_index]\n\n# What indexer to use for transactions\n#\n# The application will set which txs to index. In some cases a node operator will be able\n# to decide which txs to index based on configuration set in the application.\n#\n# Options:\n#   1) \"null\"\n#   2) \"kv\" (default) - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).\n# \t\t- When \"kv\" is chosen \"tx.height\" and \"tx.hash\" will always be indexed.\n#   3) \"psql\" - the indexer services backed by PostgreSQL.\n# When \"kv\" or \"psql\" is chosen \"tx.height\" and \"tx.hash\" will always be indexed.\nindexer = \"kv\"\n\n# The PostgreSQL connection configuration, the connection format:\n#   postgresql://\u003cuser\u003e:\u003cpassword\u003e@\u003chost\u003e:\u003cport\u003e/\u003cdb\u003e?\u003copts\u003e\npsql-conn = \"\"\n\n#######################################################\n###       Instrumentation Configuration Options     ###\n#######################################################\n[instrumentation]\n\n# When true, Prometheus metrics are served under /metrics on\n# PrometheusListenAddr.\n# Check out the documentation for the list of available metrics.\nprometheus = true\n\n# Address to listen for Prometheus collector(s) connections\nprometheus_listen_addr = \":26660\"\n\n# Maximum number of simultaneous connections.\n# If you want to accept a larger number than the default, make sure\n# you increase your OS limits.\n# 0 - unlimited.\nmax_open_connections = 3\n\n# Instrumentation namespace\nnamespace = \"cometbft\"\n"
</pre>
</div>
			</td>
			<td> @description ""</td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--secret--key--name"><a href="./values.yaml#L1157">shannon.fullnode.cometbft.secret.key.name</a></td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-release-1-shannon"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--secret--key--nodeKeyName"><a href="./values.yaml#L1158">shannon.fullnode.cometbft.secret.key.nodeKeyName</a></td>
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
			<td id="shannon--fullnode--cometbft--secret--key--privValidatorKeyName"><a href="./values.yaml#L1161">shannon.fullnode.cometbft.secret.key.privValidatorKeyName</a></td>
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
			<td id="shannon--fullnode--cometbft--secret--type"><a href="./values.yaml#L1154">shannon.fullnode.cometbft.secret.type</a></td>
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
			<td id="shannon--fullnode--cometbft--volumes--config--key--appKeyName"><a href="./values.yaml#L379">shannon.fullnode.cometbft.volumes.config.key.appKeyName</a></td>
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
			<td id="shannon--fullnode--cometbft--volumes--config--key--clientKeyName"><a href="./values.yaml#L378">shannon.fullnode.cometbft.volumes.config.key.clientKeyName</a></td>
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
			<td id="shannon--fullnode--cometbft--volumes--config--key--configKeyName"><a href="./values.yaml#L377">shannon.fullnode.cometbft.volumes.config.key.configKeyName</a></td>
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
			<td id="shannon--fullnode--cometbft--volumes--config--key--name"><a href="./values.yaml#L376">shannon.fullnode.cometbft.volumes.config.key.name</a></td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-release-1-shannon"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--volumes--enabled"><a href="./values.yaml#L372">shannon.fullnode.cometbft.volumes.enabled</a></td>
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
			<td id="shannon--fullnode--cometbft--volumes--type"><a href="./values.yaml#L373">shannon.fullnode.cometbft.volumes.type</a></td>
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
			<td id="shannon--fullnode--containersSecurityContext"><a href="./values.yaml#L1333">shannon.fullnode.containersSecurityContext</a></td>
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
			<td id="shannon--fullnode--enabled"><a href="./values.yaml#L369">shannon.fullnode.enabled</a></td>
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
			<td id="shannon--fullnode--image--repository"><a href="./values.yaml#L1167">shannon.fullnode.image.repository</a></td>
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
			<td id="shannon--fullnode--image--tag"><a href="./values.yaml#L1170">shannon.fullnode.image.tag</a></td>
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
			<td id="shannon--fullnode--imagePullSecrets"><a href="./values.yaml#L1173">shannon.fullnode.imagePullSecrets</a></td>
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
			<td id="shannon--fullnode--ingress--annotations"><a href="./values.yaml#L1192">shannon.fullnode.ingress.annotations</a></td>
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
			<td id="shannon--fullnode--ingress--className"><a href="./values.yaml#L1189">shannon.fullnode.ingress.className</a></td>
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
			<td id="shannon--fullnode--ingress--enabled"><a href="./values.yaml#L1187">shannon.fullnode.ingress.enabled</a></td>
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
			<td id="shannon--fullnode--ingress--hosts"><a href="./values.yaml#L1215">shannon.fullnode.ingress.hosts</a></td>
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
			<td id="shannon--fullnode--ingress--tls"><a href="./values.yaml#L1202">shannon.fullnode.ingress.tls</a></td>
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
			<td id="shannon--fullnode--initContainersSecurityContext--runAsGroup"><a href="./values.yaml#L1321">shannon.fullnode.initContainersSecurityContext.runAsGroup</a></td>
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
			<td id="shannon--fullnode--initContainersSecurityContext--runAsUser"><a href="./values.yaml#L1320">shannon.fullnode.initContainersSecurityContext.runAsUser</a></td>
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
			<td id="shannon--fullnode--livenessProbe--enabled"><a href="./values.yaml#L1256">shannon.fullnode.livenessProbe.enabled</a></td>
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
			<td id="shannon--fullnode--livenessProbe--failureThreshold"><a href="./values.yaml#L1266">shannon.fullnode.livenessProbe.failureThreshold</a></td>
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
			<td id="shannon--fullnode--livenessProbe--initialDelaySeconds"><a href="./values.yaml#L1259">shannon.fullnode.livenessProbe.initialDelaySeconds</a></td>
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
			<td id="shannon--fullnode--livenessProbe--periodSeconds"><a href="./values.yaml#L1261">shannon.fullnode.livenessProbe.periodSeconds</a></td>
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
			<td id="shannon--fullnode--livenessProbe--successThreshold"><a href="./values.yaml#L1268">shannon.fullnode.livenessProbe.successThreshold</a></td>
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
			<td id="shannon--fullnode--livenessProbe--timeoutSeconds"><a href="./values.yaml#L1264">shannon.fullnode.livenessProbe.timeoutSeconds</a></td>
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
			<td id="shannon--fullnode--nodeSelector"><a href="./values.yaml#L1336">shannon.fullnode.nodeSelector</a></td>
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
			<td id="shannon--fullnode--podAnnotations"><a href="./values.yaml#L1300">shannon.fullnode.podAnnotations</a></td>
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
			<td id="shannon--fullnode--podSecurityContext"><a href="./values.yaml#L1309">shannon.fullnode.podSecurityContext</a></td>
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
			<td id="shannon--fullnode--resources--preset--enabled"><a href="./values.yaml#L1276">shannon.fullnode.resources.preset.enabled</a></td>
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
			<td id="shannon--fullnode--resources--preset--name"><a href="./values.yaml#L1278">shannon.fullnode.resources.preset.name</a></td>
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
			<td id="shannon--fullnode--resources--values--limits--cpu"><a href="./values.yaml#L1291">shannon.fullnode.resources.values.limits.cpu</a></td>
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
			<td id="shannon--fullnode--resources--values--limits--memory"><a href="./values.yaml#L1293">shannon.fullnode.resources.values.limits.memory</a></td>
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
			<td id="shannon--fullnode--resources--values--requests--cpu"><a href="./values.yaml#L1285">shannon.fullnode.resources.values.requests.cpu</a></td>
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
			<td id="shannon--fullnode--resources--values--requests--memory"><a href="./values.yaml#L1287">shannon.fullnode.resources.values.requests.memory</a></td>
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
			<td id="shannon--fullnode--service--type"><a href="./values.yaml#L1180">shannon.fullnode.service.type</a></td>
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
			<td id="shannon--fullnode--storage--data--enabled"><a href="./values.yaml#L1220">shannon.fullnode.storage.data.enabled</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--accessModes[0]"><a href="./values.yaml#L1227">shannon.fullnode.storage.data.volumeClaimTemplate.accessModes[0]</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--annotations"><a href="./values.yaml#L1225">shannon.fullnode.storage.data.volumeClaimTemplate.annotations</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--resources--limits--storage"><a href="./values.yaml#L1241">shannon.fullnode.storage.data.volumeClaimTemplate.resources.limits.storage</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--resources--requests--storage"><a href="./values.yaml#L1239">shannon.fullnode.storage.data.volumeClaimTemplate.resources.requests.storage</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--selector--matchLabels--"app--pocket--network""><a href="./values.yaml#L1233">shannon.fullnode.storage.data.volumeClaimTemplate.selector.matchLabels."app.pocket.network"</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--storageClassName"><a href="./values.yaml#L1229">shannon.fullnode.storage.data.volumeClaimTemplate.storageClassName</a></td>
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
			<td id="shannon--fullnode--storage--data--volumeClaimTemplate--volumeMode"><a href="./values.yaml#L1235">shannon.fullnode.storage.data.volumeClaimTemplate.volumeMode</a></td>
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
			<td id="shannon--fullnode--tolerations"><a href="./values.yaml#L1340">shannon.fullnode.tolerations</a></td>
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
			<td id="shannon--fullnode--volumeMounts"><a href="./values.yaml#L1251">shannon.fullnode.volumeMounts</a></td>
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
			<td id="shannon--fullnode--volumes"><a href="./values.yaml#L1243">shannon.fullnode.volumes</a></td>
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
			<td id="shannon--relayminer--affinity"><a href="./values.yaml#L364">shannon.relayminer.affinity</a></td>
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
			<td id="shannon--relayminer--autoscaling--enabled"><a href="./values.yaml#L308">shannon.relayminer.autoscaling.enabled</a></td>
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
			<td id="shannon--relayminer--autoscaling--maxReplicas"><a href="./values.yaml#L313">shannon.relayminer.autoscaling.maxReplicas</a></td>
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
			<td id="shannon--relayminer--autoscaling--minReplicas"><a href="./values.yaml#L310">shannon.relayminer.autoscaling.minReplicas</a></td>
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
			<td id="shannon--relayminer--autoscaling--targetCPUUtilizationPercentage"><a href="./values.yaml#L316">shannon.relayminer.autoscaling.targetCPUUtilizationPercentage</a></td>
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
			<td id="shannon--relayminer--autoscaling--targetMemoryUtilizationPercentage"><a href="./values.yaml#L319">shannon.relayminer.autoscaling.targetMemoryUtilizationPercentage</a></td>
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
			<td id="shannon--relayminer--cometbft--clientConfig"><a href="./values.yaml#L161">shannon.relayminer.cometbft.clientConfig</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"# specifies the broadcast mode for the TxService.Broadcast RPC\nbroadcast-mode = \"sync\"\n# name of the targeted chain to send transaction\nchain-id = \"pocket-beta\"\n# specifies where keys are stored\nkeyring-backend = \"test\"\n# rpc interface for the specified chain.\nnode = \"tcp://node:26657\"\n# client output format (json|text)\noutput = \"text\"\n"
</pre>
</div>
			</td>
			<td> @description ""</td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config"><a href="./values.yaml#L74">shannon.relayminer.config</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
{
  "default_signing_key_names": [
    "supplier1"
  ],
  "metrics": {
    "addr": ":9090",
    "enabled": true
  },
  "ping": {
    "addr": "localhost:8081",
    "enabled": true
  },
  "pocket_node": {
    "query_node_grpc_url": "tcp://node:9090",
    "query_node_rpc_url": "tcp://node:26657",
    "tx_node_rpc_url": "tcp://node:26657"
  },
  "pprof": {
    "addr": "localhost:6060",
    "enabled": true
  },
  "signing_key_name": "supplier1",
  "smt_store_path": "/.pocket/smt",
  "suppliers": [
    {
      "listen_url": "http://0.0.0.0:8545",
      "service_config": {
        "backend_url": "http://anvil:8547/",
        "publicly_exposed_endpoints": [
          "relayminer1"
        ]
      },
      "service_id": "anvil"
    }
  ]
}
</pre>
</div>
			</td>
			<td> @description ""</td>
		</tr>
		<tr>
			<td id="shannon--relayminer--containersSecurityContext"><a href="./values.yaml#L359">shannon.relayminer.containersSecurityContext</a></td>
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
			<td id="shannon--relayminer--development--delve--acceptMulticlient"><a href="./values.yaml#L199">shannon.relayminer.development.delve.acceptMulticlient</a></td>
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
			<td id="shannon--relayminer--development--delve--addr"><a href="./values.yaml#L192">shannon.relayminer.development.delve.addr</a></td>
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
			<td id="shannon--relayminer--development--delve--apiVersion"><a href="./values.yaml#L196">shannon.relayminer.development.delve.apiVersion</a></td>
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
			<td id="shannon--relayminer--development--delve--enabled"><a href="./values.yaml#L190">shannon.relayminer.development.delve.enabled</a></td>
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
			<td id="shannon--relayminer--development--delve--headless"><a href="./values.yaml#L194">shannon.relayminer.development.delve.headless</a></td>
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
			<td id="shannon--relayminer--enabled"><a href="./values.yaml#L35">shannon.relayminer.enabled</a></td>
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
			<td id="shannon--relayminer--gasAdjustment"><a href="./values.yaml#L44">shannon.relayminer.gasAdjustment</a></td>
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
			<td id="shannon--relayminer--gasPrices"><a href="./values.yaml#L48">shannon.relayminer.gasPrices</a></td>
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
			<td id="shannon--relayminer--grpcInsecure"><a href="./values.yaml#L39">shannon.relayminer.grpcInsecure</a></td>
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
			<td id="shannon--relayminer--image--pullPolicy"><a href="./values.yaml#L207">shannon.relayminer.image.pullPolicy</a></td>
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
			<td id="shannon--relayminer--image--repository"><a href="./values.yaml#L205">shannon.relayminer.image.repository</a></td>
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
			<td id="shannon--relayminer--image--tag"><a href="./values.yaml#L210">shannon.relayminer.image.tag</a></td>
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
			<td id="shannon--relayminer--imagePullSecrets"><a href="./values.yaml#L215">shannon.relayminer.imagePullSecrets</a></td>
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
			<td id="shannon--relayminer--ingress--annotations"><a href="./values.yaml#L264">shannon.relayminer.ingress.annotations</a></td>
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
			<td id="shannon--relayminer--ingress--className"><a href="./values.yaml#L261">shannon.relayminer.ingress.className</a></td>
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
			<td id="shannon--relayminer--ingress--enabled"><a href="./values.yaml#L259">shannon.relayminer.ingress.enabled</a></td>
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
			<td id="shannon--relayminer--ingress--hosts"><a href="./values.yaml#L287">shannon.relayminer.ingress.hosts</a></td>
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
			<td id="shannon--relayminer--ingress--tls"><a href="./values.yaml#L274">shannon.relayminer.ingress.tls</a></td>
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
			<td id="shannon--relayminer--initContainersSecurityContext--runAsGroup"><a href="./values.yaml#L347">shannon.relayminer.initContainersSecurityContext.runAsGroup</a></td>
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
			<td id="shannon--relayminer--initContainersSecurityContext--runAsUser"><a href="./values.yaml#L346">shannon.relayminer.initContainersSecurityContext.runAsUser</a></td>
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
			<td id="shannon--relayminer--keyringBackend"><a href="./values.yaml#L52">shannon.relayminer.keyringBackend</a></td>
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
			<td id="shannon--relayminer--livenessProbe--ping--enabled"><a href="./values.yaml#L299">shannon.relayminer.livenessProbe.ping.enabled</a></td>
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
			<td id="shannon--relayminer--livenessProbe--ping--initialDelaySeconds"><a href="./values.yaml#L302">shannon.relayminer.livenessProbe.ping.initialDelaySeconds</a></td>
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
			<td id="shannon--relayminer--livenessProbe--ping--periodSeconds"><a href="./values.yaml#L304">shannon.relayminer.livenessProbe.ping.periodSeconds</a></td>
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
			<td id="shannon--relayminer--logs--level"><a href="./values.yaml#L58">shannon.relayminer.logs.level</a></td>
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
			<td id="shannon--relayminer--nodeSelector"><a href="./values.yaml#L362">shannon.relayminer.nodeSelector</a></td>
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
			<td id="shannon--relayminer--podAnnotations"><a href="./values.yaml#L326">shannon.relayminer.podAnnotations</a></td>
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
			<td id="shannon--relayminer--podSecurityContext"><a href="./values.yaml#L335">shannon.relayminer.podSecurityContext</a></td>
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
			<td id="shannon--relayminer--prometheus--serviceMonitor--enabled"><a href="./values.yaml#L179">shannon.relayminer.prometheus.serviceMonitor.enabled</a></td>
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
			<td id="shannon--relayminer--replicas"><a href="./values.yaml#L212">shannon.relayminer.replicas</a></td>
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
			<td id="shannon--relayminer--resources--limits--cpu"><a href="./values.yaml#L234">shannon.relayminer.resources.limits.cpu</a></td>
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
			<td id="shannon--relayminer--resources--limits--memory"><a href="./values.yaml#L236">shannon.relayminer.resources.limits.memory</a></td>
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
			<td id="shannon--relayminer--resources--preset--enabled"><a href="./values.yaml#L222">shannon.relayminer.resources.preset.enabled</a></td>
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
			<td id="shannon--relayminer--resources--preset--name"><a href="./values.yaml#L224">shannon.relayminer.resources.preset.name</a></td>
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
			<td id="shannon--relayminer--resources--requests--cpu"><a href="./values.yaml#L228">shannon.relayminer.resources.requests.cpu</a></td>
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
			<td id="shannon--relayminer--resources--requests--memory"><a href="./values.yaml#L230">shannon.relayminer.resources.requests.memory</a></td>
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
			<td id="shannon--relayminer--secret--key--keyName"><a href="./values.yaml#L67">shannon.relayminer.secret.key.keyName</a></td>
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
			<td id="shannon--relayminer--secret--key--name"><a href="./values.yaml#L66">shannon.relayminer.secret.key.name</a></td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"pocket-network-release-1-shannon-relayminer"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--secret--type"><a href="./values.yaml#L63">shannon.relayminer.secret.type</a></td>
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
			<td id="shannon--relayminer--service--type"><a href="./values.yaml#L243">shannon.relayminer.service.type</a></td>
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
			<td id="shannon--relayminer--tolerations"><a href="./values.yaml#L366">shannon.relayminer.tolerations</a></td>
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
			<td id="shannon--relayminer--volumeMounts"><a href="./values.yaml#L252">shannon.relayminer.volumeMounts</a></td>
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
			<td id="shannon--relayminer--volumes"><a href="./values.yaml#L245">shannon.relayminer.volumes</a></td>
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
			<td id="version"><a href="./values.yaml#L19">version</a></td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"0.1.1"
</pre>
</div>
			</td>
			<td></td>
		</tr>
	</tbody>
</table>

