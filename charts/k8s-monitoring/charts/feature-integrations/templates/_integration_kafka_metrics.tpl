{{- define "integrations.kafka.type.metrics" }}true{{- end }}

{{- define "integrations.kafka.module.metrics" }}
declare "kafka_integration" {
  argument "metrics_destinations" {
    comment = "Must be a list of metric destinations where collected metrics should be forwarded to"
  }
  {{- range $instance := $.Values.kafka.instances }}
    {{- include "integrations.kafka.include.metrics" (deepCopy $ | merge (dict "instance" $instance)) | nindent 2 }}
  {{- end }}
}
{{- end }}

{{- define "integrations.kafka.include.metrics" }}
{{- $defaultValues := "integrations/kafka-values.yaml" | .Files.Get | fromYaml }}
{{- with mergeOverwrite $defaultValues .instance (dict "type" "integration.kafka") }}
{{- if and (hasKey . "secret") (eq (include "secrets.usesKubernetesSecret" .) "true") }}
  {{- include "secret.alloy" (deepCopy $ | merge (dict "object" .)) | nindent 0 }}
{{- end }}
prometheus.exporter.kafka {{ include "helper.alloy_name" .name | quote }} {
  kafka_uris = [{{ .exporter.address | quote }}]
{{- if eq (include "secrets.usesSecret" (dict "object" . "key" "exporter.auth.username")) "true" }}
  sasl_username = {{ include "secrets.read" (dict "object" . "key" "exporter.auth.username" "nonsensitive" true) }}
{{- end }}
{{- if eq (include "secrets.usesSecret" (dict "object" . "key" "exporter.auth.password")) "true" }}
  sasl_password = {{ include "secrets.read" (dict "object" . "key" "exporter.auth.password" "nonsensitive" true) }}
{{- end }}
}

{{- $metricAllowList := .metrics.tuning.includeMetrics }}
{{- $metricDenyList := .metrics.tuning.excludeMetrics }}
prometheus.scrape {{ include "helper.alloy_name" .name | quote }} {
  targets    = prometheus.exporter.kafka.{{ include "helper.alloy_name" .name }}.targets
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
