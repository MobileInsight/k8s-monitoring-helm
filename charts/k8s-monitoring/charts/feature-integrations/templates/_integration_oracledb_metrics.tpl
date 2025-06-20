{{- define "integrations.oracledb.type.metrics" }}true{{- end }}

{{- define "integrations.oracledb.module.metrics" }}
declare "oracledb_integration" {
  argument "metrics_destinations" {
    comment = "Must be a list of metric destinations where collected metrics should be forwarded to"
  }
  {{- range $instance := $.Values.oracledb.instances }}
    {{- include "integrations.oracledb.include.metrics" (deepCopy $ | merge (dict "instance" $instance)) | nindent 2 }}
  {{- end }}
}
{{- end }}

{{- define "integrations.oracledb.include.metrics" }}
{{- $defaultValues := "integrations/oracledb-values.yaml" | .Files.Get | fromYaml }}
{{- with mergeOverwrite $defaultValues .instance (dict "type" "integration.oracledb") }}
{{- if and (hasKey . "secret") (eq (include "secrets.usesKubernetesSecret" .) "true") }}
  {{- include "secret.alloy" (deepCopy $ | merge (dict "object" .)) | nindent 0 }}
{{- end }}
prometheus.exporter.oracledb {{ include "helper.alloy_name" .name | quote }} {
  connection_string = string.format("oracle://%s:%s@%s",
    {{ include "secrets.read" (dict "object" . "key" "exporter.auth.username" "nonsensitive" true) }},
    {{ include "secrets.read" (dict "object" . "key" "exporter.auth.password" "nonsensitive" true) }},
    {{ .exporter.address | quote }}
  )
}

{{- $metricAllowList := .metrics.tuning.includeMetrics }}
{{- $metricDenyList := .metrics.tuning.excludeMetrics }}
prometheus.scrape {{ include "helper.alloy_name" .name | quote }} {
  targets    = prometheus.exporter.oracledb.{{ include "helper.alloy_name" .name }}.targets
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
