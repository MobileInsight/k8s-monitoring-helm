# Squid Integration

This integration uses the `prometheus.exporter.squid` component to collect metrics from Squid proxy servers.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `"http://localhost:3128/squid-internal-mgr/counters"` | Squid server address. |
| exporter.username | string | `""` | Squid manager username. |
| exporter.password | string | `""` | Squid manager password. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/squid"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Squid instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  squid:
    instances:
      - name: proxy-server
        exporter:
          address: "http://squid.proxy.svc.cluster.local:3128/squid-internal-mgr/counters"
          username: manager
          password: manager-password
```

## Available Metrics

- `squid_up` - Whether Squid is up
- `squid_client_http_requests_total` - Total number of HTTP requests
- `squid_client_http_hits_total` - Total number of cache hits
- `squid_client_http_errors_total` - Total number of HTTP errors
- `squid_server_all_kbytes_in_total` - Total KB received from servers
- `squid_server_all_kbytes_out_total` - Total KB sent to servers
