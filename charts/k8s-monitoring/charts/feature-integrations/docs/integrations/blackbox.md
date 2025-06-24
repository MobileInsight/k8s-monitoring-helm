# blackbox

## Values

### Discovery Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| discovery.enabled | bool | `false` | Enable automatic discovery of HTTPRoute resources |
| discovery.extraRelabelRules | list | `[]` | Additional relabel rules to apply to discovered targets |
| discovery.labelSelectors | object | `{}` | Label selectors to filter HTTPRoute resources |
| discovery.module | string | `http_2xx` | Module to use for discovered HTTPRoute targets |
| discovery.namespaces | list | `[]` | The namespaces to look for HTTPRoute resources. An empty list means all namespaces will be searched |
| discovery.path | string | `""` | Additional path to append to discovered routes |
| discovery.protocol | string | `https` | Protocol to use for discovered routes (http or https) |

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.config | string | `"modules:\n  http_2xx:\n    prober: http\n    timeout: 5s\n    http:\n      valid_http_versions: [\"HTTP/1.1\", \"HTTP/2.0\"]\n      valid_status_codes: []\n      method: GET\n"` | Blackbox configuration. |
| exporter.module | string | `http_2xx` | Module to use for probing. |
| exporter.targets | list | `[]` | Targets to probe. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/blackbox"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Blackbox prober instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection from Blackbox prober. |

### Metric Processing Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.maxCacheSize | string | `100000` | Sets the max_cache_size for prometheus.relabel component. This should be at least 2x-5x your largest scrape target or samples appended rate. ([docs](https://grafana.com/docs/alloy/latest/reference/components/prometheus.relabel/#arguments)) Overrides global.maxCacheSize |
| metrics.tuning.excludeMetrics | list | `[]` | Metrics to drop. Can use regular expressions. |
| metrics.tuning.includeMetrics | list | `[]` | Metrics to keep. Can use regular expressions. |

### Scrape Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |
