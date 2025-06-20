# MongoDB Integration

This integration uses the `prometheus.exporter.mongodb` component to collect metrics from MongoDB databases.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.uri | string | `""` | MongoDB URI connection string. If provided, takes precedence. |
| exporter.address | string | `""` | The address of the MongoDB server. |
| exporter.auth.username | string | `""` | The username for authentication. |
| exporter.auth.password | string | `""` | The password for authentication. |

### Secret

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secret.create | bool | `true` | Whether to create a secret to store credentials. |
| secret.embed | bool | `false` | If true, embed credentials directly into configuration. |
| secret.name | string | `""` | The name of the secret to create. |
| secret.namespace | string | `""` | The namespace for the secret. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/mongodb"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this MongoDB instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  mongodb:
    instances:
      - name: app-database
        exporter:
          address: "mongodb.database.svc.cluster.local:27017"
          auth:
            username: monitoring
            password: monitoring-password
```

Or with URI:

```yaml
integrations:
  mongodb:
    instances:
      - name: app-database
        exporter:
          uri: "mongodb://user:pass@mongodb.database.svc.cluster.local:27017/admin"
```

## Available Metrics

- `mongodb_up` - Whether MongoDB is up
- `mongodb_instance_uptime_seconds` - Instance uptime
- `mongodb_connections` - Number of connections
- `mongodb_memory` - Memory usage statistics
- `mongodb_mongod_wiredtiger_cache_bytes` - WiredTiger cache usage
