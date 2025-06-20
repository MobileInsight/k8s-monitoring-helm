# Blackbox Integration

This integration uses the `prometheus.exporter.blackbox` component to probe endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.config | string | See values file | Blackbox configuration with probe modules. |
| exporter.module | string | `"http_2xx"` | Default module to use for probing. |
| exporter.targets | list | `[]` | List of targets to probe. |

### Discovery Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| discovery.enabled | bool | `false` | Enable automatic discovery of HTTPRoute resources |
| discovery.namespaces | list | `[]` | The namespaces to look for HTTPRoute resources. |
| discovery.labelSelectors | object | `{}` | Label selectors to filter HTTPRoute resources |
| discovery.module | string | `"http_2xx"` | Module to use for discovered HTTPRoute targets |
| discovery.protocol | string | `"https"` | Protocol to use for discovered routes |
| discovery.path | string | `""` | Additional path to append to discovered routes |
| discovery.extraRelabelRules | list | `[]` | Additional relabel rules to apply to discovered targets |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/blackbox"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Blackbox instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

### Basic endpoint monitoring:

```yaml
integrations:
  blackbox:
    instances:
      - name: website-monitor
        exporter:
          targets:
            - https://example.com
            - https://api.example.com/health
```

### With HTTPRoute discovery:

```yaml
integrations:
  blackbox:
    instances:
      - name: httproute-monitor
        discovery:
          enabled: true
          namespaces: ["production"]
          protocol: https
          path: /health
```

## Available Metrics

- `probe_success` - Displays whether or not the probe was a success
- `probe_duration_seconds` - Returns how long the probe took to complete in seconds
- `probe_http_status_code` - Response HTTP status code
- `probe_http_duration_seconds` - Duration of HTTP request phases
- `probe_ssl_earliest_cert_expiry` - Returns earliest SSL cert expiry date
