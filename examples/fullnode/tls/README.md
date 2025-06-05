# Demonstrate how to deploy a fullnode with Transport Layer Security (TLS) activated for the RPC server

There are certain use cases where you may need to interact with RPC clients over a trusted network to ensure data integrity and confidentiality. This also applies when operating a fullnode intended for developers, applications, regulated environments, or other services accessible via the public internet. This Helm chart supports mounting volumes for the TLS certificates from a Kubernetes Secret. Combined with the certificate issuance via cert-manager, you can specify the appropriate Kubernetes Secret to be mounted automatically, and use it for the fullnode RPC server.

## Pre-requisite
* cert-manager installed on Kubernetes.
* TLS certificate available in a Kubernetes Secret resource.

### Certificate (certificates.cert-manager.io)

This resource represents a certificate request. The cert-manager uses this input to generate private key and a CertificateRequest resource in order to obtain a signed certificate for the fullnode.

```
$> cat <<EOF>> certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: fullnode-tls-example-com
  namespace: pocket-network
  labels:
    app.pocket.network: tls-example
spec:
  secretName: fullnode-tls-example-com-tls
  secretTemplate:
    labels:
      app.pocket.network: tls-example

  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048

  duration: 2160h # 90d
  renewBefore: 360h # 15d

  isCA: false
  usages:
    - server auth
    - client auth

  subject:
    organizations:
      - node-operator

  commonName: <your-domain>
  dnsNames:
    - <your-domain>

  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
    group: cert-manager.io
EOF

?> kubectl apply -f certificate.yaml
```

Once the `Certificate` custom resources created, we have to make sure the certificate is issued by the cert-manager. You can use this command to monitor the issuance.
```
?> kubectl get certificate -n pocket-network fullnode-tls-example-com
NAME                       READY   SECRET                         AGE
fullnode-tls-example-com   True    fullnode-tls-example-com-tls   5m
```

### Values

Once the pre-requisiste are met, you can now define a Helm chart values file that creates a fullnode with `.Values.fullnode.tls.enabled=true`. We must also provide the path to the `.Values.fullnode.config.rpc.tls_cert_file` and `.Values.fullnode.config.rpc.tls_key_file` in which you want to mount the Kubernetes Secret keys.

```
  fullnode:
    enabled: true
    cosmossdk:
      config: |
        version = "0.38.10"
        proxy_app = "tcp://127.0.0.1:26658"
        moniker = "node1"
        db_backend = "goleveldb"
        db_dir = "data"
        log_level = "info"
        log_format = "plain"
        genesis_file = "config/genesis.json"
        priv_validator_key_file = "config/priv_validator_key.json"
        priv_validator_state_file = "data/priv_validator_state.json"
        priv_validator_laddr = ""
        node_key_file = "config/node_key.json"
        abci = "socket"
        filter_peers = false

        [rpc]
        laddr = "tcp://0.0.0.0:26657"
        cors_allowed_origins = ["*", ]
        cors_allowed_methods = ["HEAD", "GET", "POST", ]
        cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time", ]
        grpc_laddr = ""
        grpc_max_open_connections = 900
        unsafe = false
        max_open_connections = 900
        max_subscription_clients = 100
        max_subscriptions_per_client = 5
        experimental_subscription_buffer_size = 200
        experimental_websocket_write_buffer_size = 200
        experimental_close_on_slow_client = false
        timeout_broadcast_tx_commit = "10s"
        max_request_batch_size = 10
        max_body_bytes = 1000000
        max_header_bytes = 1048576
        tls_cert_file = "tls.crt"
        tls_key_file = "tls.key"
        pprof_laddr = ":6060"

        [p2p]
        laddr = "tcp://0.0.0.0:26656"
        external_address = ""
        seeds = "78e64eb51f040b86b8e4bed6ba8d895fa2f87839@shannon-grove-seed1.beta.poktroll.com:26656"
        persistent_peers = ""
        addr_book_file = "config/addrbook.json"
        addr_book_strict = true
        max_num_inbound_peers = 40
        max_num_outbound_peers = 10
        unconditional_peer_ids = ""
        persistent_peers_max_dial_period = "0s"
        flush_throttle_timeout = "100ms"
        max_packet_msg_payload_size = 1024
        send_rate = 5120000
        recv_rate = 5120000
        pex = true
        seed_mode = false
        private_peer_ids = ""
        allow_duplicate_ip = false
        handshake_timeout = "20s"
        dial_timeout = "3s"

        [mempool]
        type = "flood"
        recheck = true
        recheck_timeout = "1s"
        broadcast = true
        wal_dir = ""
        size = 5000
        max_txs_bytes = 1073741824
        cache_size = 10000
        keep-invalid-txs-in-cache = false
        max_tx_bytes = 1048576
        max_batch_bytes = 0
        experimental_max_gossip_connections_to_persistent_peers = 0
        experimental_max_gossip_connections_to_non_persistent_peers = 0

        [statesync]
        enable = false
        rpc_servers = ""
        trust_height = 0
        trust_hash = ""
        trust_period = "168h0m0s"
        discovery_time = "15s"
        temp_dir = ""
        chunk_request_timeout = "10s"
        chunk_fetchers = "4"

        [blocksync]
        version = "v0"

        [consensus]
        wal_file = "data/cs.wal/wal"

        timeout_propose = "5m0s"
        timeout_propose_delta = "5s"
        timeout_prevote = "10s"
        timeout_prevote_delta = "5s"
        timeout_precommit = "10s"
        timeout_precommit_delta = "5s"
        timeout_commit = "5m0s"
        double_sign_check_height = 0

        skip_timeout_commit = false

        create_empty_blocks = true
        create_empty_blocks_interval = "0s"

        peer_gossip_sleep_duration = "100ms"
        peer_query_maj23_sleep_duration = "2s"

        [storage]
        discard_abci_responses = false

        [tx_index]
        indexer = "kv"
        psql-conn = ""

        [instrumentation]
        prometheus = true
        prometheus_listen_addr = ":26660"
        max_open_connections = 3
        namespace = "cometbft"
    tls:
      enabled: true
      secret:
        key:
          name: pocket-network-shannon-fullnode-rpc-tls
          certKeyName: tls.crt
          keyKeyName: tls.key

```
> Note: Make sure to specify a path for `.Values.fullnode.cosmossdk.config.tls_cert_file` and `.Values.fullnode.cosmossdk.config.tls_key_file`. These can be any valid file paths. The Helm chart will automatically mount the contents of the corresponding Kubernetes Secret to these locations.
