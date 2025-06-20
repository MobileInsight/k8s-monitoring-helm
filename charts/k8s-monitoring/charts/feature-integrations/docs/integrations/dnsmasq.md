# dnsmasq Integration

This integration uses the `prometheus.exporter.dnsmasq` component to collect metrics from dnsmasq DNS/DHCP server.

## Values

### Exporter Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.address | string | `"localhost:53"` | The address of the dnsmasq server. |
| exporter.leasesPath | string | `"/var/lib/misc/dnsmasq.leases"` | Path to dnsmasq leases file. |

### General Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| jobLabel | string | `"integration/dnsmasq"` | The value of the job label for scraped metrics |
| name | string | `""` | Name for this dnsmasq instance. |

### Metrics Settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| metrics.enabled | bool | `true` | Whether to enable metrics collection. |
| metrics.scrapeInterval | string | `60s` | How frequently to scrape metrics. |

## Enabling

```yaml
integrations:
  dnsmasq:
    instances:
      - name: dns-server
        exporter:
          address: "dnsmasq.kube-system.svc.cluster.local:53"
          leasesPath: "/var/lib/dnsmasq/dnsmasq.leases"
```

## Available Metrics

- `dnsmasq_leases` - Number of DHCP leases
- `dnsmasq_cachesize` - Cache size
- `dnsmasq_hits` - DNS cache hits
- `dnsmasq_misses` - DNS cache misses
