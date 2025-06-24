# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Helm charts repository for Kubernetes monitoring solutions developed by Grafana. It provides comprehensive telemetry collection (metrics, logs, traces, and profiles) from Kubernetes clusters using Grafana Alloy.

## Main Directory Structure

1. **`/charts/`** - Contains the Helm charts:
   - **`k8s-monitoring/`** - Main v2.x chart with modular feature-based architecture
   - **`k8s-monitoring-v1/`** - Legacy v1.x chart
   - **`k8s-monitoring-test/`** - Test utilities chart

2. **`/scripts/`** - Development and CI/CD scripts:
   - Linting scripts (shell, YAML, Markdown, Alloy config files)
   - Cluster setup scripts (Kind, EKS, GKE, OpenShift)
   - Documentation and schema generation
   - Test runners

3. **`/examples/`** - Usage examples for various configurations
4. **`/allowLists/`** - Metric allow lists configuration

## Technology Stack

- **Helm**: Version 3.14+ for chart templating
- **Alloy**: Grafana's telemetry collector configuration language
- **Go Templates**: For Helm chart templating
- **Testing**: Helm unittest plugin for template validation
- **Linting**: Multiple linters (actionlint, alex, markdownlint, shellcheck, yamllint)

## Common Development Commands

```bash
# Build all charts and generate documentation
make build

# Run tests
make test

# Run linters
make lint

# Specific linters
make lint-alloy      # Lint Alloy configuration files
make lint-shell      # Lint shell scripts
make lint-markdown   # Lint markdown files
make lint-terraform  # Lint terraform files
make lint-yaml       # Lint YAML files

# Install linting tools (macOS only)
make setup

# Install Node.js dependencies
yarn install

# Generate integration schemas (after adding new integrations)
make -C charts/k8s-monitoring/charts/feature-integrations build

# Run a single test file
helm unittest -f tests/specific_test.yaml charts/k8s-monitoring

# Debug Helm template generation
helm template k8s-monitoring charts/k8s-monitoring --debug

# Validate chart with dry-run
helm install k8s-monitoring charts/k8s-monitoring --dry-run --debug
```

## Chart Architecture (k8s-monitoring v2.x)

The main k8s-monitoring chart uses a modular feature-based approach:

### Feature Charts
- `feature-annotation-autodiscovery` - Discover metrics/logs via pod annotations
- `feature-application-observability` - Application-level telemetry
- `feature-auto-instrumentation` - Automatic instrumentation
- `feature-cluster-events` - Kubernetes event collection
- `feature-cluster-metrics` - Cluster and node metrics
- `feature-integrations` - Service-specific integrations (databases, message queues, etc.)
- `feature-node-logs` - System log collection
- `feature-pod-logs` - Container log collection
- `feature-profiling` - Continuous profiling
- `feature-prometheus-operator-objects` - ServiceMonitor/PodMonitor support

### Collector Architecture
Multiple Alloy instances for different telemetry types:
- Metrics collector (DaemonSet)
- Logs collector (DaemonSet)
- Profiles collector (DaemonSet)
- Cluster events collector (Deployment)
- Receiver for OTLP data (Deployment)

## Adding New Integrations

The feature-integrations chart supports all Prometheus exporters. To add a new integration:

1. **Create values file**: `integrations/<name>-values.yaml`
2. **Create templates**:
   - `_integration_<name>.tpl` - Main template with validation
   - `_integration_<name>_metrics.tpl` - Metrics collection logic
   - `_integration_<name>_logs.tpl` - (Optional) Log collection logic
3. **Add to values.yaml**: Add the integration section
4. **Update _integration_types.tpl**: Add to the types list
5. **Add tests**: Create test files in `tests/`
6. **Run `make build`**: Generate schemas and documentation

### Integration Patterns

**Service Discovery Pattern** (for Kubernetes services):
```yaml
integrations:
  myservice:
    instances:
      - name: prod
        labelSelectors:
          app.kubernetes.io/name: myservice
```

**Direct Connection Pattern** (for external services):
```yaml
integrations:
  postgres:
    instances:
      - name: main-db
        exporter:
          address: postgres.example.com:5432
          auth:
            username: monitoring
            password: secret
```

**Embedded Exporter Pattern** (runs exporter in Alloy):
```yaml
integrations:
  blackbox:
    instances:
      - name: probe
        exporter:
          targets:
            - https://example.com
          module: http_2xx
```

**HTTPRoute Discovery Pattern** (auto-discover endpoints):
```yaml
integrations:
  blackbox:
    instances:
      - name: httproute-probe
        discovery:
          enabled: true
          namespaces: ["production"]
          labelSelectors:
            gateway: public
          protocol: https
          path: /health
```

## Testing Approach

1. **Unit Tests**: Helm template validation
   - Located in `tests/` directories
   - Run with `make test` or `helm unittest`
   - Use snapshots for complex output validation

2. **Integration Tests**: Full deployment scenarios
   - Located in `tests/integration/`
   - Test various configurations and platforms
   - Include ArgoCD and Terraform deployment patterns

3. **Platform Tests**: Cloud provider specific
   - EKS, GKE, AKS, OpenShift configurations
   - Test authentication and managed service integrations

## Configuration Patterns

### Destinations
All telemetry must be sent to configured destinations:
```yaml
destinations:
  - name: prometheus
    type: prometheus
    url: http://prometheus.monitoring.svc:9090/api/v1/write
  - name: loki  
    type: loki
    url: http://loki.monitoring.svc:3100/loki/api/v1/push
```

### Metric Filtering
Control data volume with allow/deny lists:
```yaml
metrics:
  tuning:
    includeMetrics: ["metric_name_.*"]
    excludeMetrics: ["expensive_metric_.*"]
```

### Secret Management
Multiple patterns supported:
- Inline secrets (development only)
- Kubernetes secret references
- Environment variable references
- External secret operators

## Key Design Principles

1. **Ask about outcomes, not systems** - Focus on what users want to monitor
2. **Provide helpful error messages** - Guide users to correct configuration
3. **Modular architecture** - Enable only needed features
4. **Secure by default** - Never expose credentials in logs
5. **Performance conscious** - Use appropriate scrape intervals and filtering

## Debugging Tips

1. **Check generated config**: Use `helm template` to see actual Alloy configuration
2. **Validate with dry-run**: `helm install --dry-run --debug`
3. **Component logs**: Check Alloy pod logs for configuration errors
4. **Metrics validation**: Use Prometheus UI to verify metrics are being collected
5. **Integration testing**: Deploy test instances of services to validate monitoring

## Common Issues

1. **High memory usage**: Reduce `maxCacheSize` or add metric filtering
2. **Missing metrics**: Check service discovery labels and network policies
3. **Authentication errors**: Verify secret references and permissions
4. **Performance impact**: Adjust scrape intervals and enable sampling

## Development Workflow Tips

1. **Before committing**: Run `make lint` and `make test` to catch issues early
2. **Schema changes**: After modifying values structures, run `make build` to regenerate schemas
3. **Integration development**: Test with minimal configurations first, then add complexity
4. **Error messages**: Include specific field paths and example configurations in validation errors