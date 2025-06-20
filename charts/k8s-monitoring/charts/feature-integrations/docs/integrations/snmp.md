# SNMP Integration

This integration uses the `prometheus.exporter.snmp` component to collect metrics from SNMP-enabled devices.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.config | string | See values | SNMP configuration with auth and modules. |
| exporter.targets | list | `[]` | List of SNMP targets to monitor. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/snmp"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this SNMP instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  snmp:
    instances:
      - name: network-devices
        exporter:
          targets:
            - 192.168.1.1  # Switch
            - 192.168.1.2  # Router
          config: |
            auths:
              public:
                community: public
                security_level: noAuthNoPriv
            modules:
              if_mib:
                walk:
                  - 1.3.6.1.2.1.2
```

## Available Metrics

- `snmp_scrape_duration_seconds` - Time taken to collect metrics
- `ifHCInOctets` - Interface input byte counters
- `ifHCOutOctets` - Interface output byte counters
- `sysUpTime` - System uptime
- Custom OID metrics based on configuration
