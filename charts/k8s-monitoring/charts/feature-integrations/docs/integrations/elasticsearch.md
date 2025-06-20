# Elasticsearch Integration

This integration uses the `prometheus.exporter.elasticsearch` component to collect metrics from Elasticsearch clusters.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `""` | The address of the Elasticsearch server. |
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
| jobLabel | string | `"integration/elasticsearch"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Elasticsearch instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  elasticsearch:
    instances:
      - name: search-cluster
        exporter:
          address: "http://elasticsearch.elastic.svc.cluster.local:9200"
          auth:
            username: elastic
            password: changeme
```

## Available Metrics

- `elasticsearch_cluster_health_status` - Cluster health status
- `elasticsearch_cluster_health_number_of_nodes` - Number of nodes in the cluster
- `elasticsearch_cluster_health_active_shards` - Number of active shards
- `elasticsearch_indices_docs_count` - Count of documents
- `elasticsearch_jvm_memory_used_bytes` - JVM memory usage
