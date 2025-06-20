# Redis Integration

This integration uses the `prometheus.exporter.redis` component to collect metrics from Redis servers.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `""` | The address of the Redis server. |
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
| jobLabel | string | `"integration/redis"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Redis instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  redis:
    instances:
      - name: cache-redis
        exporter:
          address: "redis.cache.svc.cluster.local:6379"
          auth:
            password: redis-password
```

## Available Metrics

- `redis_up` - Whether Redis is up
- `redis_connected_clients` - Number of client connections
- `redis_used_memory_bytes` - Total memory usage
- `redis_commands_processed_total` - Total number of commands processed
- `redis_keyspace_hits_total` - Number of successful key lookups
- `redis_keyspace_misses_total` - Number of failed key lookups
