# DaemonSet Mode for Metrics Collection

By default, the `alloy-metrics` collector is deployed as a StatefulSet with clustering enabled to distribute scraping work across instances. However, you can configure it to run as a DaemonSet for scenarios where you want to have one metrics collector per node.

When using DaemonSet mode:
- Clustering is automatically disabled for all features
- Each DaemonSet pod will only discover and scrape metrics from pods on its own node
- This reduces cross-node network traffic and improves performance in large clusters

## When to Use DaemonSet Mode

Consider using DaemonSet mode when:
- You want to minimize cross-node network traffic for metrics collection
- You have a large cluster where centralized scraping would be inefficient
- You need a metrics collector on every node for redundancy
- You have specific deployment requirements that mandate DaemonSet usage

## Configuration

To enable DaemonSet mode for metrics collection:

```yaml
# Set the global metrics collector mode
global:
  metricsCollector:
    mode: "daemonset"

# Configure alloy-metrics as a DaemonSet
alloy-metrics:
  enabled: true
  controller:
    type: daemonset
```

When `global.metricsCollector.mode` is set to "daemonset":
- Clustering is automatically disabled for all features
- Node filtering is automatically enabled for pod discovery
- The Alloy helm chart automatically injects the HOSTNAME environment variable

## How It Works

When `alloy-metrics` is configured as a DaemonSet:

1. **Clustering is automatically disabled** - All features detect the DaemonSet mode and disable clustering
2. **One collector per node** - A pod is deployed on each node in the cluster
3. **Node filtering is enabled** - Each pod only discovers targets on its own node using `spec.nodeName=$(HOSTNAME)`

## Benefits

With DaemonSet mode and node filtering:

1. **No Duplicate Metrics** - Each target is scraped by only one collector (the one on its node)
2. **Reduced Network Traffic** - Metrics are collected locally on each node
3. **Better Scalability** - Distributes the scraping load across all nodes
4. **Improved Reliability** - Node failures only affect metrics from that specific node

## Migration from StatefulSet to DaemonSet

To migrate from StatefulSet to DaemonSet mode:

1. Update your values file to set `controller.type: daemonset`
2. Apply the Helm upgrade - this will delete the StatefulSet and create a DaemonSet
3. Monitor your metrics to ensure all targets are being scraped correctly

Note: During the migration, there may be a brief gap in metrics collection while the StatefulSet is terminated and the DaemonSet is created.

## Example Configuration

Here's a complete example of configuring metrics collection in DaemonSet mode:

```yaml
cluster:
  name: my-cluster

global:
  metricsCollector:
    mode: "daemonset"  # Enable DaemonSet mode with node filtering

destinations:
  - name: prometheus
    type: prometheus
    url: http://prometheus:9090/api/v1/write

alloy-metrics:
  enabled: true
  controller:
    type: daemonset
  alloy:
    # Resource limits appropriate for node-local scraping
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "512Mi"

# Enable features - they will automatically use node filtering
clusterMetrics:
  enabled: true

annotationAutodiscovery:
  enabled: true

integrations:
  enabled: true
```