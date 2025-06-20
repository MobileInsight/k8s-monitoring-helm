# Memcached Integration

This integration uses the `prometheus.exporter.memcached` component to collect metrics from Memcached servers.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `""` | The address of the Memcached server. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/memcached"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Memcached instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  memcached:
    instances:
      - name: session-cache
        exporter:
          address: "memcached.cache.svc.cluster.local:11211"
```

## Available Metrics

- `memcached_up` - Could the memcached server be reached
- `memcached_uptime_seconds` - Number of seconds since the server started
- `memcached_current_bytes` - Current number of bytes used
- `memcached_current_connections` - Current number of open connections
- `memcached_current_items` - Current number of items stored
- `memcached_items_total` - Total number of items stored
