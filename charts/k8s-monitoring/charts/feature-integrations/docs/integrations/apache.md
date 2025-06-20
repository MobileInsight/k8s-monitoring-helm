# Apache Integration

This integration uses the `prometheus.exporter.apache` component to collect metrics from Apache HTTP Server instances.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.scrapeURI | string | `"http://localhost/server-status?auto"` | The URL of the Apache status page. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/apache"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Apache instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection from Apache. |

### Metric Processing Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.maxCacheSize | string | `100000` | Sets the max_cache_size for prometheus.relabel component. Overrides global.maxCacheSize |
| metrics.tuning.excludeMetrics | list | `[]` | Metrics to drop. Can use regular expressions. |
| metrics.tuning.includeMetrics | list | `[]` | Metrics to keep. Can use regular expressions. |

### Scrape Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Configuration

To enable Apache monitoring, ensure that `mod_status` is enabled and accessible:

```apache
<Location "/server-status">
    SetHandler server-status
    Require host localhost
</Location>
```

## Enabling

```yaml
integrations:
  apache:
    instances:
      - name: webserver
        exporter:
          scrapeURI: "http://apache.default.svc.cluster.local/server-status?auto"
```

## Available Metrics

- `apache_accesses_total` - Total number of accesses
- `apache_sent_kilobytes_total` - Total kilobytes sent
- `apache_uptime_seconds_total` - Current uptime in seconds
- `apache_workers` - Apache worker statuses
- `apache_scoreboard` - Apache scoreboard statuses
- `apache_connections` - Apache connection statuses
