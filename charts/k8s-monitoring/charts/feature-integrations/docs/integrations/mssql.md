# Microsoft SQL Server Integration

This integration uses the `prometheus.exporter.mssql` component to collect metrics from Microsoft SQL Server.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `""` | The address of the MSSQL server. |
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
| jobLabel | string | `"integration/mssql"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this MSSQL instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  mssql:
    instances:
      - name: production-db
        exporter:
          address: "mssql.database.svc.cluster.local:1433"
          auth:
            username: sa
            password: StrongPassword123!
```

## Available Metrics

- `mssql_up` - Whether MSSQL is up
- `mssql_connections` - Number of active connections
- `mssql_deadlocks_total` - Total number of deadlocks
- `mssql_user_errors_total` - Total number of user errors
- `mssql_batch_requests_total` - Total number of batch requests
