# StatsD Integration

This integration uses the `prometheus.exporter.statsd` component to receive and aggregate StatsD metrics.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.listenAddress | string | `"0.0.0.0:9125"` | The address to listen on for StatsD metrics. |
| exporter.mappingConfig | string | `""` | Mapping configuration for StatsD metrics. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/statsd"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this StatsD instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  statsd:
    instances:
      - name: metrics-aggregator
        exporter:
          listenAddress: "0.0.0.0:9125"
          mappingConfig: |
            mappings:
            - match: "api.*.request.count"
              name: "api_requests_total"
              labels:
                endpoint: "$1"
```

## Available Metrics

Metrics depend on what applications send to StatsD. Common patterns:
- Counters: `*_total`
- Gauges: Current values
- Timers: `*_seconds` with histogram buckets
- Histograms: Distribution metrics
