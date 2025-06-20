# Consul Integration

This integration uses the `prometheus.exporter.consul` component to collect metrics from HashiCorp Consul.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.server | string | `"http://localhost:8500"` | Consul server address. |
| exporter.datacenter | string | `""` | Consul datacenter. |
| exporter.allowStale | bool | `true` | Allow stale Consul results. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/consul"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Consul instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  consul:
    instances:
      - name: service-discovery
        exporter:
          server: "http://consul.system.svc.cluster.local:8500"
          datacenter: "dc1"
```

## Available Metrics

- `consul_up` - Was the last Consul query successful
- `consul_raft_leader` - Does Raft cluster have a leader
- `consul_serf_lan_members` - Number of LAN members in the cluster
- `consul_catalog_services` - Number of services registered
- `consul_health_node_status` - Node health status
