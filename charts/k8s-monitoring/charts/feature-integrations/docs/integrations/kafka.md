# Kafka Integration

This integration uses the `prometheus.exporter.kafka` component to collect metrics from Apache Kafka.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `""` | The address of the Kafka server. |
| exporter.auth.username | string | `""` | SASL username for authentication. |
| exporter.auth.password | string | `""` | SASL password for authentication. |

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
| jobLabel | string | `"integration/kafka"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this Kafka instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  kafka:
    instances:
      - name: event-bus
        exporter:
          address: "kafka.messaging.svc.cluster.local:9092"
          auth:
            username: kafka-user
            password: kafka-password
```

## Available Metrics

- `kafka_topic_partitions` - Number of partitions for a topic
- `kafka_topic_partition_current_offset` - Current offset of a partition
- `kafka_topic_partition_oldest_offset` - Oldest offset of a partition
- `kafka_consumer_group_lag` - Consumer group lag
- `kafka_broker_info` - Broker information
