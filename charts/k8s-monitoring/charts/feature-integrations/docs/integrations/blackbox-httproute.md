# Blackbox Exporter with HTTPRoute Discovery

The Blackbox integration now supports automatic discovery of HTTPRoute resources to monitor endpoints defined in your Gateway API configuration.

## HTTPRoute Discovery Configuration

To enable HTTPRoute discovery, configure the `discovery` section in your blackbox instance:

```yaml
blackbox:
  instances:
    - name: httproute-monitor
      exporter:
        config: |
          modules:
            http_2xx:
              prober: http
              timeout: 5s
              http:
                valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
                valid_status_codes: []
                method: GET
      discovery:
        enabled: true
        namespaces: []  # Empty means all namespaces
        labelSelectors:
          gateway: production
        protocol: https
        path: /health
        module: http_2xx
```

### Configuration Options

- **`discovery.enabled`**: Enable/disable HTTPRoute discovery
- **`discovery.namespaces`**: List of namespaces to search (empty = all namespaces)
- **`discovery.labelSelectors`**: Filter HTTPRoutes by labels
- **`discovery.protocol`**: Protocol to use for probing (http/https)
- **`discovery.path`**: Additional path to append to discovered hostnames
- **`discovery.module`**: Blackbox module to use for discovered targets
- **`discovery.extraRelabelRules`**: Additional relabel rules for discovered targets

## Examples

### Basic HTTPRoute Discovery

Monitor all HTTPRoutes in specific namespaces:

```yaml
blackbox:
  instances:
    - name: api-monitor
      discovery:
        enabled: true
        namespaces:
          - production
          - staging
        protocol: https
        module: http_2xx
```

### Filtering by Labels

Only monitor HTTPRoutes with specific labels:

```yaml
blackbox:
  instances:
    - name: public-api-monitor
      discovery:
        enabled: true
        labelSelectors:
          exposure: public
          monitoring: enabled
        protocol: https
        path: /api/health
```

### Combined Static and Discovered Targets

Use both static targets and HTTPRoute discovery:

```yaml
blackbox:
  instances:
    - name: combined-monitor
      exporter:
        targets:
          # Static targets
          - https://legacy-api.example.com/health
          - https://external-service.com/status
        module: http_2xx
      discovery:
        enabled: true
        namespaces:
          - production
        protocol: https
        module: http_2xx
```

### Custom Relabeling Rules

Add custom labels or modify discovered targets:

```yaml
blackbox:
  instances:
    - name: custom-monitor
      discovery:
        enabled: true
        extraRelabelRules:
          # Add environment label from namespace
          - source_labels: ["__meta_kubernetes_namespace_labels_environment"]
            target_label: "environment"
          # Skip HTTPRoutes marked as no-monitor
          - source_labels: ["__meta_kubernetes_httproute_labels_monitoring"]
            regex: "false"
            action: drop
          # Add custom path based on HTTPRoute annotation
          - source_labels: ["__param_target", "__meta_kubernetes_httproute_annotations_monitoring_path"]
            regex: "(.*);(.+)"
            target_label: "__param_target"
            replacement: "${1}${2}"
```

## How It Works

1. **Discovery**: The integration uses Kubernetes service discovery to find HTTPRoute resources
2. **Hostname Extraction**: Extracts hostnames from the HTTPRoute spec
3. **Target Creation**: Creates probe targets using the configured protocol and path
4. **Relabeling**: Applies relabel rules to add metadata and filter targets
5. **Probing**: The blackbox exporter probes each discovered target

## Limitations

- Currently only the first hostname from each HTTPRoute is used for probing
- HTTPRoutes without hostnames are automatically skipped
- Dynamic module selection per HTTPRoute is not supported (all use the same module)

## Monitoring HTTPRoute Health

Example Prometheus queries for HTTPRoute monitoring:

```promql
# Check HTTPRoute endpoint availability
probe_success{job="integration/blackbox", httproute!=""}

# Alert on HTTPRoute endpoint failures
probe_success{job="integration/blackbox", httproute!=""} == 0

# Response time by HTTPRoute
probe_duration_seconds{job="integration/blackbox", httproute!=""}
```

## Best Practices

1. **Use specific namespaces**: Limit discovery to relevant namespaces to reduce noise
2. **Label your HTTPRoutes**: Use labels to control which routes are monitored
3. **Set appropriate timeouts**: Configure blackbox module timeouts based on expected response times
4. **Monitor the right endpoints**: Use the `path` option to probe health check endpoints
5. **Use extraRelabelRules**: Add metadata labels for better observability