# PostgreSQL Integration

The PostgreSQL integration uses the `prometheus.exporter.postgres` component to collect metrics from PostgreSQL databases.

## Configuration

To enable PostgreSQL monitoring, add configuration to your values file:

```yaml
postgres:
  instances:
    - name: my-postgres
      exporter:
        address: postgres.database.svc.cluster.local:5432
        auth:
          username: monitoring
          password: monitoring-password
```

### Connection Options

The PostgreSQL exporter supports authentication through username/password:

```yaml
postgres:
  instances:
    - name: my-postgres
      exporter:
        # Connection string components
        address: postgres.database.svc.cluster.local:5432
        auth:
          username: monitoring
          password: monitoring-password
```

### Using Kubernetes Secrets

You can reference existing Kubernetes secrets for credentials:

```yaml
postgres:
  instances:
    - name: my-postgres
      exporter:
        address: postgres.database.svc.cluster.local:5432
        auth:
          usernameKey: postgres-user
          passwordKey: postgres-password
      secret:
        create: false
        name: postgres-credentials
        namespace: database
```

### Metric Filtering

Control which metrics are collected:

```yaml
postgres:
  instances:
    - name: my-postgres
      metrics:
        scrapeInterval: 30s
        tuning:
          includeMetrics:
            - pg_database_.*
            - pg_stat_.*
            - pg_replication_.*
          excludeMetrics:
            - pg_stat_bgwriter
```

## Available Metrics

The PostgreSQL exporter provides metrics including:

- Database size and statistics (`pg_database_*`)
- Table statistics (`pg_stat_user_tables_*`)
- Index statistics (`pg_stat_user_indexes_*`)
- Replication metrics (`pg_replication_*`)
- Connection metrics (`pg_stat_activity_*`)
- Lock statistics (`pg_locks_*`)

## Dashboards and Alerts

Compatible Grafana dashboards:
- [PostgreSQL Database](https://grafana.com/grafana/dashboards/9628)
- [PostgreSQL Statistics](https://grafana.com/grafana/dashboards/455)

## Troubleshooting

### Common Issues

1. **Authentication failures**: Ensure the monitoring user has the necessary permissions:
   ```sql
   CREATE USER monitoring WITH PASSWORD 'monitoring-password';
   GRANT pg_monitor TO monitoring;
   ```

2. **Connection timeouts**: Check that the PostgreSQL service is accessible from the monitoring namespace.

3. **Missing metrics**: Some metrics require specific PostgreSQL extensions or permissions.