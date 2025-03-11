# Helm Chart package for Pocket Network

Pocket Network is permissionless decentralized physical infrastructure (DePin) protocol that incentivizes and coordinates a network of node operators to provide open data access to anyone. This repository bootstraps a Pocket Network deployment on a Kubernetes cluster using the Helm package manager.

[Overview of Pocket Network](https://pocket.network/)

## TL;DR
```shell
?> helm install release-1 https://github.com/eddyzags/pocket-network-helm-charts
```
## Introduction

## Prerequisites
* Kubernetes 1.23+
* Helm 3.9.0+

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

| Name            | Description                                    | Value |
|-----------------|------------------------------------------------|-------|
| `protocol`      | decentralized framework to access network      | ""    |
| `network`       | different stage of the protocol testing phase  | ""    |
| `version`       | Semantic versionning of the poktrolld software | ""    |
| `homeDirectory` | poktrolld working directory                    | ""    |

### Shannon parameters
| Name                                | Description                                                               | Value |
|-------------------------------------|---------------------------------------------------------------------------|-------|
| `shannon.relayminer.chainId`        | unique identifier within the Cosmos ecosystem                             | ""    |
| `shannon.relayminer.grpcInsecure`   | activate gRPC over insecure channels for querying state in the Cosmos SDK | ""    |
| `shannon.relayminer.gasAdjustment`  | adjustement factor to be multiplied by the gas estimation                 | ""    |
| TODO(eddyzags): add every arguments |                                                                           |       |

### Morse parameters
| Name | Description | Value |
|------|-------------|-------|
|      |             |       |

## Troubleshooting

## Upgrading
