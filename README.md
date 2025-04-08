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
<pre lang="tpl">
shannon.fullnode.cometbft.app: |  # This is a TOML config file.
  # For more information, see https://github.com/toml-lang/toml
 
  ###############################################################################
  ###                           Base Configuration                            ###
  ###############################################################################
 
  # The minimum gas prices a validator is willing to accept for processing a
  # transaction. A transaction's fees must meet the minimum of any denomination
  # specified in this config (e.g. 0.25token1,0.0001token2).
  minimum-gas-prices = "0.000000001upokt"
 
  # The maximum gas a query coming over rest/grpc may consume.
  # If this is set to zero, the query can consume an unbounded amount of gas.
  query-gas-limit = "0"
 
  # default: the last 362880 states are kept, pruning at 10 block intervals
  # nothing: all historic states will be saved, nothing will be deleted (i.e. archiving node)
  # everything: 2 latest states will be kept; pruning at 10 block intervals.
  # custom: allow pruning options to be manually specified through 'pruning-keep-recent', and 'pruning-interval'
  pruning = "nothing"
 
  # These are applied if and only if the pruning strategy is custom.
  pruning-keep-recent = "0"
  pruning-interval = "0"
 
  # HaltHeight contains a non-zero block height at which a node will gracefully
  # halt and shutdown that can be used to assist upgrades and testing.
  #
  # Note: Commitment of state will be attempted on the corresponding block.
  halt-height = 0
 
  # HaltTime contains a non-zero minimum block time (in Unix seconds) at which
  # a node will gracefully halt and shutdown that can be used to assist upgrades
  # and testing.
  #
  # Note: Commitment of state will be attempted on the corresponding block.
  halt-time = 0
 
  # MinRetainBlocks defines the minimum block height offset from the current
  # block being committed, such that all blocks past this offset are pruned
  # from CometBFT. It is used as part of the process of determining the
  # ResponseCommit.RetainHeight value during ABCI Commit. A value of 0 indicates
  # that no blocks should be pruned.
  #
  # This configuration value is only responsible for pruning CometBFT blocks.
  # It has no bearing on application state pruning which is determined by the
  # "pruning-*" configurations.
  #
  # Note: CometBFT block pruning is dependent on this parameter in conjunction
  # with the unbonding (safety threshold) period, state pruning and state sync
  # snapshot parameters to determine the correct minimum value of
  # ResponseCommit.RetainHeight.
  min-retain-blocks = 0
 
  # InterBlockCache enables inter-block caching.
  inter-block-cache = true
 
  # IndexEvents defines the set of events in the form {eventType}.{attributeKey},
  # which informs CometBFT what to index. If empty, all events will be indexed.
  #
  # Example:
  # ["message.sender", "message.recipient"]
  index-events = []
 
  # IavlCacheSize set the size of the iavl tree cache (in number of nodes).
  iavl-cache-size = 781250
 
  # IAVLDisableFastNode enables or disables the fast node feature of IAVL.
  # Default is false.
  iavl-disable-fastnode = false
 
  # AppDBBackend defines the database backend type to use for the application and snapshots DBs.
  # An empty string indicates that a fallback will be used.
  # The fallback is the db_backend value set in CometBFT's config.toml.
  app-db-backend = ""
 
  ###############################################################################
  ###                         Telemetry Configuration                         ###
  ###############################################################################
 
  [telemetry]
 
  # Prefixed with keys to separate services.
  service-name = ""
 
  # Enabled enables the application telemetry functionality. When enabled,
  # an in-memory sink is also enabled by default. Operators may also enabled
  # other sinks such as Prometheus.
  enabled = false
 
  # Enable prefixing gauge values with hostname.
  enable-hostname = false
 
  # Enable adding hostname to labels.
  enable-hostname-label = false
 
  # Enable adding service to labels.
  enable-service-label = false
 
  # PrometheusRetentionTime, when positive, enables a Prometheus metrics sink.
  prometheus-retention-time = "1800"
 
  # GlobalLabels defines a global set of name/value label tuples applied to all
  # metrics emitted using the wrapper functions defined in telemetry package.
  #
  # Example:
  # [["chain_id", "cosmoshub-1"]]
  global-labels = [["chain_id"], ["pocket-beta"]]
 
  # MetricsSink defines the type of metrics sink to use.
  metrics-sink = "mem"
 
  # StatsdAddr defines the address of a statsd server to send metrics to.
  # Only utilized if MetricsSink is set to "statsd" or "dogstatsd".
  statsd-addr = ""
 
  # DatadogHostname defines the hostname to use when emitting metrics to
  # Datadog. Only utilized if MetricsSink is set to "dogstatsd".
  datadog-hostname = ""
 
  ###############################################################################
  ###                           API Configuration                             ###
  ###############################################################################
 
  [api]
 
  # Enable defines if the API server should be enabled.
  enable = true
 
  # Swagger defines if swagger documentation should automatically be registered.
  swagger = false
 
  # Address defines the API server to listen on.
  address = "tcp://localhost:1317"
 
  # MaxOpenConnections defines the number of maximum open connections.
  max-open-connections = 1000
 
  # RPCReadTimeout defines the CometBFT RPC read timeout (in seconds).
  rpc-read-timeout = 10
 
  # RPCWriteTimeout defines the CometBFT RPC write timeout (in seconds).
  rpc-write-timeout = 0
 
  # RPCMaxBodyBytes defines the CometBFT maximum request body (in bytes).
  rpc-max-body-bytes = 1000000
 
  # EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
  enabled-unsafe-cors = true
 
  ###############################################################################
  ###                           gRPC Configuration                            ###
  ###############################################################################
 
  [grpc]
 
  # Enable defines if the gRPC server should be enabled.
  enable = true
 
  # Address defines the gRPC server address to bind to.
  address = "localhost:9090"
 
  # MaxRecvMsgSize defines the max message size in bytes the server can receive.
  # The default value is 10MB.
  max-recv-msg-size = "10485760"
 
  # MaxSendMsgSize defines the max message size in bytes the server can send.
  # The default value is math.MaxInt32.
  max-send-msg-size = "2147483647"
 
  # SkipCheckHeader defines if the gRPC server should bypass check header.
  skip-check-header = false
 
  ###############################################################################
  ###                        gRPC Web Configuration                           ###
  ###############################################################################
  [grpc-web]
 
  # GRPCWebEnable defines if the gRPC-web should be enabled.
  # NOTE: gRPC must also be enabled, otherwise, this configuration is a no-op.
  enable = true
 
  # Address defines the gRPC-web server address to bind to.
  address = "localhost:9091"
 
  # EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
  enable-unsafe-cors = true
 
  ###############################################################################
  ###                        State Sync Configuration                         ###
  ###############################################################################
 
  # State sync snapshots allow other nodes to rapidly join the network without replaying historical
  # blocks, instead downloading and applying a snapshot of the application state at a given height.
  [state-sync]
 
  # snapshot-interval specifies the block interval at which local state sync snapshots are
  # taken (0 to disable).
  snapshot-interval = 0
 
  # snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).
  snapshot-keep-recent = 2
 
  ###############################################################################
  ###                              State Streaming                            ###
  ###############################################################################
 
  # Streaming allows nodes to stream state to external systems.
  [streaming]
 
  # streaming.abci specifies the configuration for the ABCI Listener streaming service.
  [streaming.abci]
 
  # List of kv store keys to stream out via gRPC.
  # The store key names MUST match the module's StoreKey name.
  #
  # Example:
  # ["acc", "bank", "gov", "staking", "mint"[,...]]
  # ["*"] to expose all keys.
  keys = []
 
  # The plugin name used for streaming via gRPC.
  # Streaming is only enabled if this is set.
  # Supported plugins: abci
  plugin = ""
 
  # stop-node-on-err specifies whether to stop the node on message delivery error.
  stop-node-on-err = true
 
  ###############################################################################
  ###                         Mempool                                         ###
  ###############################################################################
 
  [mempool]
 
  # Setting max-txs to 0 will allow for a unbounded amount of transactions in the mempool.
  # Setting max_txs to negative 1 (-1) will disable transactions from being inserted into the mempool (no-op mempool).
  # Setting max_txs to a positive number (> 0) will limit the number of transactions in the mempool, by the specified amount.
  #
  # Note, this configuration only applies to SDK built-in app-side mempool
  # implementations.
  max-txs = 10000
 
  ###############################################################################
  ###                         Poktroll App Config                             ###
  ###############################################################################
 
  [poktroll]
 
    [poktroll.telemetry]
 
    cardinality-level = "medium"
 
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--client"><a href="./values.yaml#L1139">shannon.fullnode.cometbft.client</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="tpl">
shannon.fullnode.cometbft.client: |  # specifies the broadcast mode for the TxService.Broadcast RPC
  broadcast-mode = "sync"
  # name of the targeted chain to send transaction
  chain-id = "pocket-beta"
  # specifies where keys are stored
  keyring-backend = "test"
  # rpc interface for the specified chain.
  node = "tcp://node:26657"
  # client output format (json|text)
  output = "json"
 
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--fullnode--cometbft--config"><a href="./values.yaml#L382">shannon.fullnode.cometbft.config</a></td>
			<td>
tpl/string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="tpl">
shannon.fullnode.cometbft.config: |  # This is a TOML config file.
  # For more information, see https://github.com/toml-lang/toml
 
  # NOTE: Any path below can be absolute (e.g. "/var/myawesomeapp/data") or
  # relative to the home directory (e.g. "data"). The home directory is
  # "$HOME/.cometbft" by default, but could be changed via $CMTHOME env variable
  # or --home cmd flag.
 
  # The version of the CometBFT binary that created or
  # last modified the config file. Do not modify this.
  version = "0.38.10"
 
  #######################################################################
  ###                   Main Base Config Options                      ###
  #######################################################################
 
  # TCP or UNIX socket address of the ABCI application,
  # or the name of an ABCI application compiled in with the CometBFT binary
  proxy_app = "tcp://127.0.0.1:26658"
 
  # A custom human readable name for this node
  moniker = "node1"
 
  # Database backend: goleveldb | cleveldb | boltdb | rocksdb | badgerdb
  # * goleveldb (github.com/syndtr/goleveldb - most popular implementation)
  #   - pure go
  #   - stable
  # * cleveldb (uses levigo wrapper)
  #   - fast
  #   - requires gcc
  #   - use cleveldb build tag (go build -tags cleveldb)
  # * boltdb (uses etcd's fork of bolt - github.com/etcd-io/bbolt)
  #   - EXPERIMENTAL
  #   - may be faster is some use-cases (random reads - indexer)
  #   - use boltdb build tag (go build -tags boltdb)
  # * rocksdb (uses github.com/tecbot/gorocksdb)
  #   - EXPERIMENTAL
  #   - requires gcc
  #   - use rocksdb build tag (go build -tags rocksdb)
  # * badgerdb (uses github.com/dgraph-io/badger)
  #   - EXPERIMENTAL
  #   - use badgerdb build tag (go build -tags badgerdb)
  db_backend = "goleveldb"
 
  # Database directory
  db_dir = "data"
 
  # Output level for logging, including package level options
  log_level = "info"
 
  # Output format: 'plain' (colored text) or 'json'
  log_format = "plain"
 
  ##### additional base config options #####
 
  # Path to the JSON file containing the initial validator set and other meta data
  genesis_file = "config/genesis.json"
 
  # Path to the JSON file containing the private key to use as a validator in the consensus protocol
  priv_validator_key_file = "config/priv_validator_key.json"
 
  # Path to the JSON file containing the last sign state of a validator
  priv_validator_state_file = "data/priv_validator_state.json"
 
  # TCP or UNIX socket address for CometBFT to listen on for
  # connections from an external PrivValidator process
  priv_validator_laddr = ""
 
  # Path to the JSON file containing the private key to use for node authentication in the p2p protocol
  node_key_file = "config/node_key.json"
 
  # Mechanism to connect to the ABCI application: socket | grpc
  abci = "socket"
 
  # If true, query the ABCI app on connecting to a new peer
  # so the app can decide if we should keep the connection or not
  filter_peers = false
 
 
  #######################################################################
  ###                 Advanced Configuration Options                  ###
  #######################################################################
 
  #######################################################
  ###       RPC Server Configuration Options          ###
  #######################################################
  [rpc]
 
  # TCP or UNIX socket address for the RPC server to listen on
  laddr = "tcp://0.0.0.0:26657"
 
  # A list of origins a cross-domain request can be executed from
  # Default value '[]' disables cors support
  # Use '["*"]' to allow any origin
  cors_allowed_origins = ["*", ]
 
  # A list of methods the client is allowed to use with cross-domain requests
  cors_allowed_methods = ["HEAD", "GET", "POST", ]
 
  # A list of non simple headers the client is allowed to use with cross-domain requests
  cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time", ]
 
  # TCP or UNIX socket address for the gRPC server to listen on
  # NOTE: This server only supports /broadcast_tx_commit
  grpc_laddr = ""
 
  # Maximum number of simultaneous connections.
  # Does not include RPC (HTTP&WebSocket) connections. See max_open_connections
  # If you want to accept a larger number than the default, make sure
  # you increase your OS limits.
  # 0 - unlimited.
  # Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
  # 1024 - 40 - 10 - 50 = 924 = ~900
  grpc_max_open_connections = 900
 
  # Activate unsafe RPC commands like /dial_seeds and /unsafe_flush_mempool
  unsafe = false
 
  # Maximum number of simultaneous connections (including WebSocket).
  # Does not include gRPC connections. See grpc_max_open_connections
  # If you want to accept a larger number than the default, make sure
  # you increase your OS limits.
  # 0 - unlimited.
  # Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
  # 1024 - 40 - 10 - 50 = 924 = ~900
  max_open_connections = 900
 
  # Maximum number of unique clientIDs that can /subscribe
  # If you're using /broadcast_tx_commit, set to the estimated maximum number
  # of broadcast_tx_commit calls per block.
  max_subscription_clients = 100
 
  # Maximum number of unique queries a given client can /subscribe to
  # If you're using GRPC (or Local RPC client) and /broadcast_tx_commit, set to
  # the estimated # maximum number of broadcast_tx_commit calls per block.
  max_subscriptions_per_client = 5
 
  # Experimental parameter to specify the maximum number of events a node will
  # buffer, per subscription, before returning an error and closing the
  # subscription. Must be set to at least 100, but higher values will accommodate
  # higher event throughput rates (and will use more memory).
  experimental_subscription_buffer_size = 200
 
  # Experimental parameter to specify the maximum number of RPC responses that
  # can be buffered per WebSocket client. If clients cannot read from the
  # WebSocket endpoint fast enough, they will be disconnected, so increasing this
  # parameter may reduce the chances of them being disconnected (but will cause
  # the node to use more memory).
  #
  # Must be at least the same as "experimental_subscription_buffer_size",
  # otherwise connections could be dropped unnecessarily. This value should
  # ideally be somewhat higher than "experimental_subscription_buffer_size" to
  # accommodate non-subscription-related RPC responses.
  experimental_websocket_write_buffer_size = 200
 
  # If a WebSocket client cannot read fast enough, at present we may
  # silently drop events instead of generating an error or disconnecting the
  # client.
  #
  # Enabling this experimental parameter will cause the WebSocket connection to
  # be closed instead if it cannot read fast enough, allowing for greater
  # predictability in subscription behavior.
  experimental_close_on_slow_client = false
 
  # How long to wait for a tx to be committed during /broadcast_tx_commit.
  # WARNING: Using a value larger than 10s will result in increasing the
  # global HTTP write timeout, which applies to all connections and endpoints.
  # See https://github.com/tendermint/tendermint/issues/3435
  timeout_broadcast_tx_commit = "10s"
 
  # Maximum number of requests that can be sent in a batch
  # If the value is set to '0' (zero-value), then no maximum batch size will be
  # enforced for a JSON-RPC batch request.
  max_request_batch_size = 10
 
  # Maximum size of request body, in bytes
  max_body_bytes = 1000000
 
  # Maximum size of request header, in bytes
  max_header_bytes = 1048576
 
  # The path to a file containing certificate that is used to create the HTTPS server.
  # Might be either absolute path or path related to CometBFT's config directory.
  # If the certificate is signed by a certificate authority,
  # the certFile should be the concatenation of the server's certificate, any intermediates,
  # and the CA's certificate.
  # NOTE: both tls_cert_file and tls_key_file must be present for CometBFT to create HTTPS server.
  # Otherwise, HTTP server is run.
  tls_cert_file = ""
 
  # The path to a file containing matching private key that is used to create the HTTPS server.
  # Might be either absolute path or path related to CometBFT's config directory.
  # NOTE: both tls-cert-file and tls-key-file must be present for CometBFT to create HTTPS server.
  # Otherwise, HTTP server is run.
  tls_key_file = ""
 
  # pprof listen address (https://golang.org/pkg/net/http/pprof)
  pprof_laddr = "localhost:6060"
 
  #######################################################
  ###           P2P Configuration Options             ###
  #######################################################
  [p2p]
 
  # Address to listen for incoming connections
  laddr = "tcp://0.0.0.0:26656"
 
  # Address to advertise to peers for them to dial. If empty, will use the same
  # port as the laddr, and will introspect on the listener to figure out the
  # address. IP and port are required. Example: 159.89.10.97:26656
  external_address = ""
 
  # Comma separated list of seed nodes to connect to
  seeds = "78e64eb51f040b86b8e4bed6ba8d895fa2f87839@shannon-grove-seed1.beta.poktroll.com:26656"
 
  # Comma separated list of nodes to keep persistent connections to
  persistent_peers = "78e64eb51f040b86b8e4bed6ba8d895fa2f87839@shannon-grove-seed1.beta.poktroll.com:26656"
 
  # Path to address book
  addr_book_file = "config/addrbook.json"
 
  # Set true for strict address routability rules
  # Set false for private or local networks
  addr_book_strict = true
 
  # Maximum number of inbound peers
  max_num_inbound_peers = 40
 
  # Maximum number of outbound peers to connect to, excluding persistent peers
  max_num_outbound_peers = 10
 
  # List of node IDs, to which a connection will be (re)established ignoring any existing limits
  unconditional_peer_ids = ""
 
  # Maximum pause when redialing a persistent peer (if zero, exponential backoff is used)
  persistent_peers_max_dial_period = "0s"
 
  # Time to wait before flushing messages out on the connection
  flush_throttle_timeout = "100ms"
 
  # Maximum size of a message packet payload, in bytes
  max_packet_msg_payload_size = 1024
 
  # Rate at which packets can be sent, in bytes/second
  send_rate = 5120000
 
  # Rate at which packets can be received, in bytes/second
  recv_rate = 5120000
 
  # Set true to enable the peer-exchange reactor
  pex = true
 
  # Seed mode, in which node constantly crawls the network and looks for
  # peers. If another node asks it for addresses, it responds and disconnects.
  #
  # Does not work if the peer-exchange reactor is disabled.
  seed_mode = false
 
  # Comma separated list of peer IDs to keep private (will not be gossiped to other peers)
  private_peer_ids = ""
 
  # Toggle to disable guard against peers connecting from the same ip.
  allow_duplicate_ip = false
 
  # Peer connection configuration.
  handshake_timeout = "20s"
  dial_timeout = "3s"
 
  #######################################################
  ###          Mempool Configuration Options          ###
  #######################################################
  [mempool]
 
  # The type of mempool for this node to use.
  #
  #  Possible types:
  #  - "flood" : concurrent linked list mempool with flooding gossip protocol
  #  (default)
  #  - "nop"   : nop-mempool (short for no operation; the ABCI app is responsible
  #  for storing, disseminating and proposing txs). "create_empty_blocks=false" is
  #  not supported.
  type = "flood"
 
  # Recheck (default: true) defines whether CometBFT should recheck the
  # validity for all remaining transaction in the mempool after a block.
  # Since a block affects the application state, some transactions in the
  # mempool may become invalid. If this does not apply to your application,
  # you can disable rechecking.
  recheck = true
 
  # recheck_timeout is the time the application has during the rechecking process
  # to return CheckTx responses, once all requests have been sent. Responses that
  # arrive after the timeout expires are discarded. It only applies to
  # non-local ABCI clients and when recheck is enabled.
  #
  # The ideal value will strongly depend on the application. It could roughly be estimated as the
  # average size of the mempool multiplied by the average time it takes the application to validate one
  # transaction. We consider that the ABCI application runs in the same location as the CometBFT binary
  # so that the recheck duration is not affected by network delays when making requests and receiving responses.
  recheck_timeout = "1s"
 
  # Broadcast (default: true) defines whether the mempool should relay
  # transactions to other peers. Setting this to false will stop the mempool
  # from relaying transactions to other peers until they are included in a
  # block. In other words, if Broadcast is disabled, only the peer you send
  # the tx to will see it until it is included in a block.
  broadcast = true
 
  # WalPath (default: "") configures the location of the Write Ahead Log
  # (WAL) for the mempool. The WAL is disabled by default. To enable, set
  # WalPath to where you want the WAL to be written (e.g.
  # "data/mempool.wal").
  wal_dir = ""
 
  # Maximum number of transactions in the mempool
  size = 5000
 
  # Limit the total size of all txs in the mempool.
  # This only accounts for raw transactions (e.g. given 1MB transactions and
  # max_txs_bytes=5MB, mempool will only accept 5 transactions).
  max_txs_bytes = 1073741824
 
  # Size of the cache (used to filter transactions we saw earlier) in transactions
  cache_size = 10000
 
  # Do not remove invalid transactions from the cache (default: false)
  # Set to true if it's not possible for any invalid transaction to become valid
  # again in the future.
  keep-invalid-txs-in-cache = false
 
  # Maximum size of a single transaction.
  # NOTE: the max size of a tx transmitted over the network is {max_tx_bytes}.
  max_tx_bytes = 1048576
 
  # Maximum size of a batch of transactions to send to a peer
  # Including space needed by encoding (one varint per transaction).
  # XXX: Unused due to https://github.com/tendermint/tendermint/issues/5796
  max_batch_bytes = 0
 
  # Experimental parameters to limit gossiping txs to up to the specified number of peers.
  # We use two independent upper values for persistent and non-persistent peers.
  # Unconditional peers are not affected by this feature.
  # If we are connected to more than the specified number of persistent peers, only send txs to
  # ExperimentalMaxGossipConnectionsToPersistentPeers of them. If one of those
  # persistent peers disconnects, activate another persistent peer.
  # Similarly for non-persistent peers, with an upper limit of
  # ExperimentalMaxGossipConnectionsToNonPersistentPeers.
  # If set to 0, the feature is disabled for the corresponding group of peers, that is, the
  # number of active connections to that group of peers is not bounded.
  # For non-persistent peers, if enabled, a value of 10 is recommended based on experimental
  # performance results using the default P2P configuration.
  experimental_max_gossip_connections_to_persistent_peers = 0
  experimental_max_gossip_connections_to_non_persistent_peers = 0
 
  #######################################################
  ###         State Sync Configuration Options        ###
  #######################################################
  [statesync]
  # State sync rapidly bootstraps a new node by discovering, fetching, and restoring a state machine
  # snapshot from peers instead of fetching and replaying historical blocks. Requires some peers in
  # the network to take and serve state machine snapshots. State sync is not attempted if the node
  # has any local state (LastBlockHeight > 0). The node will have a truncated block history,
  # starting from the height of the snapshot.
  enable = false
 
  # RPC servers (comma-separated) for light client verification of the synced state machine and
  # retrieval of state data for node bootstrapping. Also needs a trusted height and corresponding
  # header hash obtained from a trusted source, and a period during which validators can be trusted.
  #
  # For Cosmos SDK-based chains, trust_period should usually be about 2/3 of the unbonding time (~2
  # weeks) during which they can be financially punished (slashed) for misbehavior.
  rpc_servers = ""
  trust_height = 0
  trust_hash = ""
  trust_period = "168h0m0s"
 
  # Time to spend discovering snapshots before initiating a restore.
  discovery_time = "15s"
 
  # Temporary directory for state sync snapshot chunks, defaults to the OS tempdir (typically /tmp).
  # Will create a new, randomly named directory within, and remove it when done.
  temp_dir = ""
 
  # The timeout duration before re-requesting a chunk, possibly from a different
  # peer (default: 1 minute).
  chunk_request_timeout = "10s"
 
  # The number of concurrent chunk fetchers to run (default: 1).
  chunk_fetchers = "4"
 
  #######################################################
  ###       Block Sync Configuration Options          ###
  #######################################################
  [blocksync]
 
  # Block Sync version to use:
  #
  # In v0.37, v1 and v2 of the block sync protocols were deprecated.
  # Please use v0 instead.
  #
  #   1) "v0" - the default block sync implementation
  version = "v0"
 
  #######################################################
  ###         Consensus Configuration Options         ###
  #######################################################
  [consensus]
 
  wal_file = "data/cs.wal/wal"
 
  # How long we wait for a proposal block before prevoting nil
  timeout_propose = "5m0s"
  # How much timeout_propose increases with each round
  timeout_propose_delta = "5s"
  # How long we wait after receiving +2/3 prevotes for “anything” (ie. not a single block or nil)
  timeout_prevote = "10s"
  # How much the timeout_prevote increases with each round
  timeout_prevote_delta = "5s"
  # How long we wait after receiving +2/3 precommits for “anything” (ie. not a single block or nil)
  timeout_precommit = "10s"
  # How much the timeout_precommit increases with each round
  timeout_precommit_delta = "5s"
  # How long we wait after committing a block, before starting on the new
  # height (this gives us a chance to receive some more precommits, even
  # though we already have +2/3).
  timeout_commit = "5m0s"
 
  # How many blocks to look back to check existence of the node's consensus votes before joining consensus
  # When non-zero, the node will panic upon restart
  # if the same consensus key was used to sign {double_sign_check_height} last blocks.
  # So, validators should stop the state machine, wait for some blocks, and then restart the state machine to avoid panic.
  double_sign_check_height = 0
 
  # Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)
  skip_timeout_commit = false
 
  # EmptyBlocks mode and possible interval between empty blocks
  create_empty_blocks = true
  create_empty_blocks_interval = "0s"
 
  # Reactor sleep duration parameters
  peer_gossip_sleep_duration = "100ms"
  peer_query_maj23_sleep_duration = "2s"
 
  #######################################################
  ###         Storage Configuration Options           ###
  #######################################################
  [storage]
 
  # Set to true to discard ABCI responses from the state store, which can save a
  # considerable amount of disk space. Set to false to ensure ABCI responses are
  # persisted. ABCI responses are required for /block_results RPC queries, and to
  # reindex events in the command-line tool.
  discard_abci_responses = false
 
  #######################################################
  ###   Transaction Indexer Configuration Options     ###
  #######################################################
  [tx_index]
 
  # What indexer to use for transactions
  #
  # The application will set which txs to index. In some cases a node operator will be able
  # to decide which txs to index based on configuration set in the application.
  #
  # Options:
  #   1) "null"
  #   2) "kv" (default) - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).
  # 		- When "kv" is chosen "tx.height" and "tx.hash" will always be indexed.
  #   3) "psql" - the indexer services backed by PostgreSQL.
  # When "kv" or "psql" is chosen "tx.height" and "tx.hash" will always be indexed.
  indexer = "kv"
 
  # The PostgreSQL connection configuration, the connection format:
  #   postgresql://<user>:<password>@<host>:<port>/<db>?<opts>
  psql-conn = ""
 
  #######################################################
  ###       Instrumentation Configuration Options     ###
  #######################################################
  [instrumentation]
 
  # When true, Prometheus metrics are served under /metrics on
  # PrometheusListenAddr.
  # Check out the documentation for the list of available metrics.
  prometheus = true
 
  # Address to listen for Prometheus collector(s) connections
  prometheus_listen_addr = ":26660"
 
  # Maximum number of simultaneous connections.
  # If you want to accept a larger number than the default, make sure
  # you increase your OS limits.
  # 0 - unlimited.
  max_open_connections = 3
 
  # Instrumentation namespace
  namespace = "cometbft"
 
</pre>
</div>
			</td>
			<td></td>
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
<pre lang="tpl">
shannon.relayminer.cometbft.clientConfig: |  # specifies the broadcast mode for the TxService.Broadcast RPC
  broadcast-mode = "sync"
  # name of the targeted chain to send transaction
  chain-id = "pocket-beta"
  # specifies where keys are stored
  keyring-backend = "test"
  # rpc interface for the specified chain.
  node = "tcp://node:26657"
  # client output format (json|text)
  output = "text"
 
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--default_signing_key_names[0]"><a href="./values.yaml#L79">shannon.relayminer.config.default_signing_key_names[0]</a></td>
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
			<td id="shannon--relayminer--config--metrics--addr"><a href="./values.yaml#L143">shannon.relayminer.config.metrics.addr</a></td>
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
			<td id="shannon--relayminer--config--metrics--enabled"><a href="./values.yaml#L141">shannon.relayminer.config.metrics.enabled</a></td>
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
			<td id="shannon--relayminer--config--ping--addr"><a href="./values.yaml#L157">shannon.relayminer.config.ping.addr</a></td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"localhost:8081"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--ping--enabled"><a href="./values.yaml#L155">shannon.relayminer.config.ping.enabled</a></td>
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
			<td id="shannon--relayminer--config--pocket_node--query_node_grpc_url"><a href="./values.yaml#L93">shannon.relayminer.config.pocket_node.query_node_grpc_url</a></td>
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
			<td id="shannon--relayminer--config--pocket_node--query_node_rpc_url"><a href="./values.yaml#L89">shannon.relayminer.config.pocket_node.query_node_rpc_url</a></td>
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
			<td id="shannon--relayminer--config--pocket_node--tx_node_rpc_url"><a href="./values.yaml#L97">shannon.relayminer.config.pocket_node.tx_node_rpc_url</a></td>
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
			<td id="shannon--relayminer--config--pprof--addr"><a href="./values.yaml#L150">shannon.relayminer.config.pprof.addr</a></td>
			<td>
string
</td>
			<td>
				<div style="max-width: 300px;">
<pre lang="json">
"localhost:6060"
</pre>
</div>
			</td>
			<td></td>
		</tr>
		<tr>
			<td id="shannon--relayminer--config--pprof--enabled"><a href="./values.yaml#L148">shannon.relayminer.config.pprof.enabled</a></td>
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
			<td id="shannon--relayminer--config--signing_key_name"><a href="./values.yaml#L75">shannon.relayminer.config.signing_key_name</a></td>
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
			<td id="shannon--relayminer--config--smt_store_path"><a href="./values.yaml#L81">shannon.relayminer.config.smt_store_path</a></td>
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
			<td id="shannon--relayminer--config--suppliers[0]--listen_url"><a href="./values.yaml#L136">shannon.relayminer.config.suppliers[0].listen_url</a></td>
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
			<td id="shannon--relayminer--config--suppliers[0]--service_config--backend_url"><a href="./values.yaml#L127">shannon.relayminer.config.suppliers[0].service_config.backend_url</a></td>
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
			<td id="shannon--relayminer--config--suppliers[0]--service_config--publicly_exposed_endpoints[0]"><a href="./values.yaml#L131">shannon.relayminer.config.suppliers[0].service_config.publicly_exposed_endpoints[0]</a></td>
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
			<td id="shannon--relayminer--config--suppliers[0]--service_id"><a href="./values.yaml#L120">shannon.relayminer.config.suppliers[0].service_id</a></td>
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

