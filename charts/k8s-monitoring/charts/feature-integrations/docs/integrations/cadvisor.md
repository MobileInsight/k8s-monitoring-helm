# cAdvisor Integration

This integration uses the `prometheus.exporter.cadvisor` component to collect container metrics from cAdvisor.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `"http://localhost:8080/metrics"` | The address to scrape cAdvisor metrics from. |
| exporter.dockerRoot | string | `"/var/lib/docker"` | Docker root directory. |
| exporter.containerdEndpoint | string | `""` | Containerd endpoint. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/cadvisor"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this cAdvisor instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  cadvisor:
    instances:
      - name: container-metrics
        exporter:
          address: "http://cadvisor.monitoring.svc.cluster.local:8080/metrics"
```

## Available Metrics

- `container_cpu_usage_seconds_total` - Cumulative cpu time consumed
- `container_memory_usage_bytes` - Current memory usage
- `container_network_receive_bytes_total` - Cumulative count of bytes received
- `container_network_transmit_bytes_total` - Cumulative count of bytes transmitted
- `container_fs_usage_bytes` - Number of bytes that are consumed by the container on this filesystem
