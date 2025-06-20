{{- define "integrations.elasticsearch.type.metrics" }}true{{- end }}

{{- define "integrations.elasticsearch.module.metrics" }}
declare "elasticsearch_integration" {
  argument "metrics_destinations" {
    comment = "Must be a list of metric destinations where collected metrics should be forwarded to"
  }
  {{- range $instance := $.Values.elasticsearch.instances }}
    {{- include "integrations.elasticsearch.include.metrics" (deepCopy $ | merge (dict "instance" $instance)) | nindent 2 }}
  {{- end }}
}
{{- end }}

{{- define "integrations.elasticsearch.include.metrics" }}
{{- $defaultValues := "integrations/elasticsearch-values.yaml" | .Files.Get | fromYaml }}
{{- with mergeOverwrite $defaultValues .instance (dict "type" "integration.elasticsearch") }}
{{- if and (hasKey . "secret") (eq (include "secrets.usesKubernetesSecret" .) "true") }}
  {{- include "secret.alloy" (deepCopy $ | merge (dict "object" .)) | nindent 0 }}
{{- end }}
prometheus.exporter.elasticsearch {{ include "helper.alloy_name" .name | quote }} {
  address = {{ .exporter.address | quote }}
{{- if eq (include "secrets.usesSecret" (dict "object" . "key" "exporter.auth.username")) "true" }}
  username = {{ include "secrets.read" (dict "object" . "key" "exporter.auth.username" "nonsensitive" true) }}
{{- end }}
{{- if eq (include "secrets.usesSecret" (dict "object" . "key" "exporter.auth.password")) "true" }}
  password = {{ include "secrets.read" (dict "object" . "key" "exporter.auth.password" "nonsensitive" true) }}
{{- end }}
}

{{- $metricAllowList := .metrics.tuning.includeMetrics }}
{{- $metricDenyList := .metrics.tuning.excludeMetrics }}
prometheus.scrape {{ include "helper.alloy_name" .name | quote }} {
  targets    = prometheus.exporter.elasticsearch.{{ include "helper.alloy_name" .name }}.targets
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
