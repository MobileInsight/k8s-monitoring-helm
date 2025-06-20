{{- define "integrations.snmp.type.metrics" }}true{{- end }}

{{- define "integrations.snmp.module.metrics" }}
declare "snmp_integration" {
  argument "metrics_destinations" {
    comment = "Must be a list of metric destinations where collected metrics should be forwarded to"
  }
  {{- range $instance := $.Values.snmp.instances }}
    {{- include "integrations.snmp.include.metrics" (deepCopy $ | merge (dict "instance" $instance)) | nindent 2 }}
  {{- end }}
}
{{- end }}

{{- define "integrations.snmp.include.metrics" }}
{{- $defaultValues := "integrations/snmp-values.yaml" | .Files.Get | fromYaml }}
{{- with mergeOverwrite $defaultValues .instance (dict "type" "integration.snmp") }}
{{- if and (hasKey . "secret") (eq (include "secrets.usesKubernetesSecret" .) "true") }}
  {{- include "secret.alloy" (deepCopy $ | merge (dict "object" .)) | nindent 0 }}
{{- end }}
prometheus.exporter.snmp {{ include "helper.alloy_name" .name | quote }} {
  config_yaml = {{ .exporter.config | quote }}
  targets = {{ .exporter.targets | toJson }}
}

{{- $metricAllowList := .metrics.tuning.includeMetrics }}
{{- $metricDenyList := .metrics.tuning.excludeMetrics }}
prometheus.scrape {{ include "helper.alloy_name" .name | quote }} {
  targets    = prometheus.exporter.snmp.{{ include "helper.alloy_name" .name }}.targets
  job_name   = {{ .jobLabel | quote }}
{{- if .metrics.scrapeInterval }}
  scrape_interval = {{ .metrics.scrapeInterval | quote }}
{{- end }}
  forward_to = [prometheus.relabel.{{ include "helper.alloy_name" .name }}.receiver]
}

prometheus.relabel {{ include "helper.alloy_name" .name | quote }} {
  max_cache_size = {{ .metrics.maxCacheSize | default $.Values.global.maxCacheSize | int }}
  rule {
    target_label = "instance"
    replacement = {{ .name | quote }}
  }
{{- if $metricAllowList }}
  rule {
    source_labels = ["__name__"]
    regex = "up|scrape_samples_scraped|{{ $metricAllowList | fromYamlArray | join "|" }}"
    action = "keep"
  }
{{- end }}
{{- if $metricDenyList }}
  rule {
    source_labels = ["__name__"]
    regex = {{ $metricDenyList | join "|" | quote }}
    action = "drop"
  }
{{- end }}
  forward_to = argument.metrics_destinations.value
}
{{- end }}
{{- end }}
