# DaemonSet Mode Implementation Summary

This document summarizes the implementation of DaemonSet mode support for the alloy-metrics collector.

## Overview

DaemonSet mode allows the alloy-metrics collector to be deployed with one pod per node, where each pod only scrapes metrics from its own node. This reduces cross-node network traffic and improves scalability in large clusters.

## Implementation Details

### 1. Global Configuration

Added a new global configuration option in `values.yaml`:

```yaml
global:
  metricsCollector:
    mode: "statefulset"  # or "daemonset"
```

### 2. Helper Templates

Created helper templates in `templates/_collector_helpers.tpl`:
- `collector.clustering` - Returns false when mode is "daemonset", true otherwise
- `collector.nodeFilter` - Adds node filtering when in DaemonSet mode
- `collector.fieldSelectors` - Helper for field selectors with node filtering

### 3. Updated Components

#### Annotation Autodiscovery
- Updated `_pods.alloy.tpl` to add node filtering in discovery
- Updated `_module.alloy.tpl` to disable clustering

#### Cluster Metrics (14 templates)
- Updated all cluster metrics templates to use dynamic clustering:
  - `_api_server.alloy.tpl`
  - `_cadvisor.alloy.tpl`
  - `_kepler.alloy.tpl`
  - `_kube_controller_manager.alloy.tpl`
  - `_kube_dns.alloy.tpl`
  - `_kube_proxy.alloy.tpl`
  - `_kube_scheduler.alloy.tpl`
  - `_kube_state_metrics.alloy.tpl`
  - `_kubelet.alloy.tpl`
  - `_kubelet_probes.alloy.tpl`
  - `_kubelet_resource.alloy.tpl`
  - `_node_exporter.alloy.tpl`
  - `_opencost.alloy.tpl`
  - `_windows_exporter.alloy.tpl`

#### Integrations (7 templates with pod discovery)
- Updated all integration templates with pod discovery to add node filtering:
  - `_integration_alloy.tpl`
  - `_integration_cert-manager.tpl`
  - `_integration_etcd.tpl`
  - `_integration_grafana_metrics.tpl`
  - `_integration_loki_metrics.tpl`
  - `_integration_mimir_metrics.tpl`
  - `_integration_tempo_metrics.tpl`

#### Self Reporting
- Updated `_feature_self_reporting.tpl` to disable clustering in DaemonSet mode

### 4. How It Works

When `global.metricsCollector.mode` is set to "daemonset":

1. **Clustering is disabled** - All prometheus.scrape components have `clustering.enabled = false`
2. **Node filtering is enabled** - All pod discovery adds `field = "spec.nodeName=$(HOSTNAME)"`
3. **HOSTNAME is injected** - The Alloy helm chart automatically injects HOSTNAME env var when deployed as DaemonSet

### 5. Configuration Example

```yaml
# Enable DaemonSet mode
global:
  metricsCollector:
    mode: "daemonset"

# Configure alloy-metrics as DaemonSet
alloy-metrics:
  enabled: true
  controller:
    type: daemonset

# Enable features - they will automatically adapt
clusterMetrics:
  enabled: true

annotationAutodiscovery:
  enabled: true
```

### 6. Benefits

- **No duplicate metrics** - Each pod is scraped by only one collector
- **Reduced network traffic** - Metrics stay on the same node
- **Better scalability** - Load is distributed across all nodes
- **Improved reliability** - Node failures only affect that node's metrics

### 7. Testing

Created comprehensive documentation and test values to verify:
- Clustering is disabled when mode is "daemonset"
- Node filtering is applied to pod discoveries
- All features work correctly in DaemonSet mode