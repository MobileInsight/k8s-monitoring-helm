<!--
(NOTE: Do not edit README.md directly. It is a generated file!)
(      To make changes, please modify README.md.gotmpl and run `helm-docs`)
-->

# feature-integrations

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)
Service integrations

The Integrations feature builds in configuration for many common applications and services.

The current integrations that are available from this feature are:

| Integration | Description | Data Types | Docs |
| --- | --- | --- | --- |
| [Grafana Alloy](https://grafana.com/docs/alloy) | Telemetry data collector | Metrics | [Alloy doc](./docs/integrations/alloy.md) |
| [Apache](https://httpd.apache.org/) | Apache HTTP Server | Metrics | [Apache doc](./docs/integrations/apache.md) |
| [Blackbox](https://github.com/prometheus/blackbox_exporter) | Endpoint prober (HTTP, TCP, DNS, etc.) | Metrics | [Blackbox doc](./docs/integrations/blackbox.md) |
| [cAdvisor](https://github.com/google/cadvisor) | Container resource usage and performance | Metrics | [cAdvisor doc](./docs/integrations/cadvisor.md) |
| [cert-manager](https://cert-manager.io/) | x.509 certificate management for Kubernetes | Metrics | [Cert manager doc](./docs/integrations/cert-manager.md) |
| [Consul](https://www.consul.io/) | Service mesh and service discovery | Metrics | [Consul doc](./docs/integrations/consul.md) |
| [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) | DNS and DHCP server | Metrics | [dnsmasq doc](./docs/integrations/dnsmasq.md) |
| [Elasticsearch](https://www.elastic.co/elasticsearch/) | Search and analytics engine | Metrics | [Elasticsearch doc](./docs/integrations/elasticsearch.md) |
| [etcd](https://etcd.io/) | Distributed key-value store | Metrics | [etcd doc](./docs/integrations/etcd.md) |
| [Grafana](https://grafana.com/) | Observability platform | Metrics, Logs | [Grafana doc](./docs/integrations/grafana.md) |
| [Kafka](https://kafka.apache.org/) | Distributed event streaming platform | Metrics | [Kafka doc](./docs/integrations/kafka.md) |
| [Loki](https://grafana.com/oss/loki/) | Log aggregation system | Metrics, Logs | [Loki doc](./docs/integrations/loki.md) |
| [Memcached](https://memcached.org/) | Distributed memory caching system | Metrics | [Memcached doc](./docs/integrations/memcached.md) |
| [Mimir](https://grafana.com/oss/mimir/) | Scalable metrics backend | Metrics, Logs | [Mimir doc](./docs/integrations/mimir.md) |
| [MongoDB](https://www.mongodb.com/) | NoSQL database | Metrics | [MongoDB doc](./docs/integrations/mongodb.md) |
| [Microsoft SQL Server](https://www.microsoft.com/sql-server/) | Relational database | Metrics | [MSSQL doc](./docs/integrations/mssql.md) |
| [MySQL](https://www.mysql.com/) | Relational database | Metrics, Logs | [MySQL doc](./docs/integrations/mysql.md) |
| [Oracle Database](https://www.oracle.com/database/) | Relational database | Metrics | [OracleDB doc](./docs/integrations/oracledb.md) |
| [PostgreSQL](https://www.postgresql.org/) | Relational database | Metrics | [PostgreSQL doc](./docs/integrations/postgres.md) |
| [Redis](https://redis.io/) | In-memory data structure store | Metrics | [Redis doc](./docs/integrations/redis.md) |
| [SNMP](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol) | Network device monitoring | Metrics | [SNMP doc](./docs/integrations/snmp.md) |
| [Squid](http://www.squid-cache.org/) | Caching proxy server | Metrics | [Squid doc](./docs/integrations/squid.md) |
| [StatsD](https://github.com/statsd/statsd) | Metrics aggregation daemon | Metrics | [StatsD doc](./docs/integrations/statsd.md) |
| [Tempo](https://grafana.com/oss/tempo/) | Distributed tracing backend | Metrics, Logs | [Tempo doc](./docs/integrations/tempo.md) |

## Usage

To enable an integration, create an instance of it with any configuration to aid in service discovery. For example:

```yaml
cert-manager:
  instances:
    - name: cert-manager
      namespace: kube-system
      labelSelectors:
        app.kubernetes.io/name: cert-manager
```

You can specify multiple instances of the same integration to match multiple instances of that service. For example:

```yaml
alloy:
  instances:
    - name: alloy-metrics
      labelSelectors:
        app.kubernetes.io/name: alloy-metrics
    - name: alloy-receivers
      labelSelectors:
        app.kubernetes.io/name: alloy-receivers
```

For all possible values for a specific integration, refer to the previous table for the link to the integration documentation.

## Testing

This chart contains unit tests to verify the generated configuration. The hidden value `deployAsConfigMap` will render
the generated configuration into a ConfigMap object. While this ConfigMap is not used during regular operation, you can
use it to show the outcome of a given values file.

The unit tests use this ConfigMap to create an object with the configuration that can be asserted against. To run the
tests, use `helm test`.

Be sure perform actual integration testing in a live environment in the main [k8s-monitoring](../..) chart.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| petewall | <pete.wall@grafana.com> |  |
<!-- markdownlint-disable no-bare-urls -->
<!-- markdownlint-disable list-marker-space -->
## Source Code

* <https://github.com/grafana/k8s-monitoring-helm/tree/main/charts/k8s-monitoring/charts/feature-integrations>
<!-- markdownlint-enable list-marker-space -->
<!-- markdownlint-enable no-bare-urls -->

## Values

### Integration: Alloy

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alloy | object | `{"instances":[]}` | Scrape metrics/logs from Grafana Alloy |

### Integration: cert-manager

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cert-manager | object | `{"instances":[]}` | Scrape metrics/logs from cert-manager |

### Integration: etcd

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| etcd | object | `{"instances":[]}` | Scrape metrics/logs from etcd |

### General settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | Full name override |
| nameOverride | string | `""` | Name override |

### Global Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.alloyModules.branch | string | `"main"` | If using git, the branch of the git repository to use. |
| global.alloyModules.source | string | `"git"` | The source of the Alloy modules. The valid options are "configMap" or "git" |
| global.maxCacheSize | int | `100000` | Sets the max_cache_size for every prometheus.relabel component. ([docs](https://grafana.com/docs/alloy/latest/reference/components/prometheus/prometheus.relabel/#arguments)) This should be at least 2x-5x your largest scrape target or samples appended rate. |
| global.scrapeInterval | string | `"60s"` | How frequently to scrape metrics. |

### Integration: Grafana

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| grafana | object | `{"instances":[]}` | Scrape metrics/logs from Grafana |

### Integration: Loki

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| loki | object | `{"instances":[]}` | Scrape metrics/logs from Loki |

### Integration: Mimir

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| mimir | object | `{"instances":[]}` | Scrape metrics/logs from Mimir |

### Integration: MySQL

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| mysql | object | `{"instances":[]}` | Scrape metrics/logs from MySQL |

### Integration: Apache

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apache | object | `{"instances":[]}` | Scrape metrics from Apache HTTP Server |

### Integration: Blackbox

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| blackbox | object | `{"instances":[]}` | Probe endpoints with Blackbox exporter |

### Integration: cAdvisor

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cadvisor | object | `{"instances":[]}` | Scrape container metrics from cAdvisor |

### Integration: Consul

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| consul | object | `{"instances":[]}` | Scrape metrics from HashiCorp Consul |

### Integration: dnsmasq

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| dnsmasq | object | `{"instances":[]}` | Scrape metrics from dnsmasq |

### Integration: Elasticsearch

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| elasticsearch | object | `{"instances":[]}` | Scrape metrics from Elasticsearch |

### Integration: Kafka

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kafka | object | `{"instances":[]}` | Scrape metrics from Apache Kafka |

### Integration: Memcached

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| memcached | object | `{"instances":[]}` | Scrape metrics from Memcached |

### Integration: MongoDB

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| mongodb | object | `{"instances":[]}` | Scrape metrics from MongoDB |

### Integration: MSSQL

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| mssql | object | `{"instances":[]}` | Scrape metrics from Microsoft SQL Server |

### Integration: OracleDB

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| oracledb | object | `{"instances":[]}` | Scrape metrics from Oracle Database |

### Integration: PostgreSQL

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| postgres | object | `{"instances":[]}` | Scrape metrics from PostgreSQL |

### Integration: Redis

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| redis | object | `{"instances":[]}` | Scrape metrics from Redis |

### Integration: SNMP

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| snmp | object | `{"instances":[]}` | Scrape metrics from SNMP devices |

### Integration: Squid

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| squid | object | `{"instances":[]}` | Scrape metrics from Squid proxy |

### Integration: StatsD

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| statsd | object | `{"instances":[]}` | Collect StatsD metrics |

### Node Labels

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nodeLabels.availabilityZone | bool | `false` | Whether or not to add the availability\_zone label |
| nodeLabels.instanceType | bool | `false` | Whether or not to add the instance\_type label |
| nodeLabels.nodeArchitecture | bool | `false` | Whether or not to add the node architecture label |
| nodeLabels.nodeOS | bool | `false` | Whether or not to add the os label |
| nodeLabels.nodePool | bool | `false` | Whether or not to attach the nodepool label |
| nodeLabels.nodeRole | bool | `false` | Whether or not to add the node\_role label |
| nodeLabels.region | bool | `false` | Whether or not to add the region label |

### Integration: Tempo

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| tempo | object | `{"instances":[]}` | Scrape metrics/logs from Tempo |

## Contributing

To contribute integrations to this feature, you must create or modify a few files:

*   `values.yaml` - The main feature chart's values file. Add a section for your integration. It must contain an
    `instance` array and any settings that apply to every instance of the integration. For example:

    ```yaml
    <slug>:
      instances: []
      globalSetting: value
    ```

*   `integrations/<slug>-values.yaml` - The values that will be used for each instance. This must include `name` to
    differentiate it from other instances and any other settings that are specific to that instance. For example:

    ```yaml
    name: ""
    labelSelectors:
      app.kubernetes.io/name: my-service
    protocol: http
    ...
    ```

*   `templates/_integration<=_<slug>.tpl` - The file that contains template functions that build the configuration to
    discover, gather, process, and deliver the telemetry data. This file is required to implement the following template functions:
    *   `integrations.<slug>.type.metrics` - Returns true if this integration scrapes metrics.
    *   `integrations.<slug>.type.logs` - Returns true if this integration gathers logs.
    *   `integrations.<slug>.module` - Returns the configuration that is included once if this integration is used. This
        is typically the module definition.
    *   `integrations.<slug>.include.metrics` - Returns the configuration that is included for each instance of the
        integration that scrapes metrics.
    *   `integrations.<slug>.include.logs` - Returns the configuration that is included for each instance of the
        integration that gathers logs.
    *   `integrations.<slug>.exclude.logs` - Returns a rule that can be used by other Log-gathering features to ensure
        that logs that are gathered from this integration are not collected twice. Typically the inverse of a rule in
        the `integrations.<slug>.include.logs` function.
    *   `default-allow-lists/<slug>.yaml` - If the integration scrapes metrics, a common pattern is to provide a list of
        metrics that should be allowed. This reduces the amount of metrics delivered to a useful minimal set.

*   When testing changes to this chart, from `/charts/k8s-monitoring` run `rm -rf Chart.lock && make build` to force the chart to be rebuilt.
