# Oracle Database Integration

This integration uses the `prometheus.exporter.oracledb` component to collect metrics from Oracle databases.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `""` | The address of the Oracle database server. |
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
| jobLabel | string | `"integration/oracledb"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Oracle instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  oracledb:
    instances:
      - name: enterprise-db
        exporter:
          address: "oracle.database.svc.cluster.local:1521/ORCL"
          auth:
            username: monitoring
            password: monitoring123
```

## Available Metrics

- `oracledb_up` - Whether the Oracle database is up
- `oracledb_sessions_active` - Number of active sessions
- `oracledb_process_count` - Number of processes
- `oracledb_tablespace_bytes` - Tablespace size
- `oracledb_wait_time_seconds` - Wait time statistics
