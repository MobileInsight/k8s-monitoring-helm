{{- define "integrations.blackbox.type.metrics" }}true{{- end }}

{{- define "integrations.blackbox.module.metrics" }}
declare "blackbox_integration" {
  argument "metrics_destinations" {
    comment = "Must be a list of metric destinations where collected metrics should be forwarded to"
  }
  {{- range $instance := $.Values.blackbox.instances }}
    {{- include "integrations.blackbox.include.metrics" (deepCopy $ | merge (dict "instance" $instance)) | nindent 2 }}
  {{- end }}
}
{{- end }}

{{- define "integrations.blackbox.include.metrics" }}
{{- $defaultValues := "integrations/blackbox-values.yaml" | .Files.Get | fromYaml }}
{{- with mergeOverwrite $defaultValues .instance (dict "type" "integration.blackbox") }}
{{- if and (hasKey . "secret") (eq (include "secrets.usesKubernetesSecret" .) "true") }}
  {{- include "secret.alloy" (deepCopy $ | merge (dict "object" .)) | nindent 0 }}
{{- end }}

// Create blackbox exporter
prometheus.exporter.blackbox {{ include "helper.alloy_name" .name | quote }} {
  config_yaml = {{ .exporter.config | quote }}
}

{{- if .discovery.enabled }}
// Discover HTTPRoute resources
discovery.kubernetes "httproutes_{{ include "helper.alloy_name" .name }}" {
  role = "httproute"
{{- if .discovery.namespaces }}
  namespaces {
    names = {{ .discovery.namespaces | toJson }}
  }
{{- end }}
{{- if .discovery.labelSelectors }}
  selectors {
    role = "httproute"
  {{- range $label, $value := .discovery.labelSelectors }}
    {{- if kindIs "slice" $value }}
    label = {{ printf "%s in (%s)" $label (join "," $value) | quote }}
    {{- else }}
    label = {{ printf "%s=%s" $label $value | quote }}
    {{- end }}
  {{- end }}
  }
{{- end }}
}

// Process discovered HTTPRoutes
discovery.relabel "httproutes_{{ include "helper.alloy_name" .name }}" {
  targets = discovery.kubernetes.httproutes_{{ include "helper.alloy_name" .name }}.targets
  
  // Keep only targets that have hostnames defined
  rule {
    source_labels = ["__meta_kubernetes_httproute_spec_hostnames"]
    regex = "\\[\\]"
    action = "drop"
  }
  
  // Extract hostnames array
  rule {
    source_labels = ["__meta_kubernetes_httproute_spec_hostnames"]
    regex = "\\[([^\\]]+)\\]"
    target_label = "__tmp_hostnames"
  }
  
  // Extract first hostname and create target URL
  // TODO: To support multiple hostnames per HTTPRoute, consider using multiple discovery instances
  rule {
    source_labels = ["__tmp_hostnames"]
    regex = "([^,\\s]+)"
    target_label = "__param_target"
    replacement = "{{ .discovery.protocol }}://${1}{{ .discovery.path }}"
  }
  
  // Set module
  rule {
    target_label = "__param_module"
    replacement = {{ .discovery.module | quote }}
  }
  
  // Set address to blackbox exporter
  rule {
    target_label = "__address__"
    replacement = "127.0.0.1:9115"
  }
  
  // Add metadata labels
  rule {
    source_labels = ["__meta_kubernetes_httproute_namespace"]
    target_label = "namespace"
  }
  
  rule {
    source_labels = ["__meta_kubernetes_httproute_name"]
    target_label = "httproute"
  }
  
  // Add target label for clarity
  rule {
    source_labels = ["__param_target"]
    target_label = "target"
  }
  
  {{- range .discovery.extraRelabelRules }}
  {{- if not .rule }}
  rule {
    {{- toYaml . | nindent 4 }}
  }
  {{- else }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- end }}
}
{{- end }}

// Static targets configuration
prometheus.relabel "static_targets_{{ include "helper.alloy_name" .name }}" {
  {{- if .exporter.targets }}
  targets = [
    {{- range $target := .exporter.targets }}
    {
      __address__ = "127.0.0.1:9115",
      __param_target = {{ $target | quote }},
      __param_module = {{ $.exporter.module | quote }},
      target = {{ $target | quote }},
    },
    {{- end }}
  ]
  {{- else }}
  targets = []
  {{- end }}
}

{{- $metricAllowList := .metrics.tuning.includeMetrics }}
{{- $metricDenyList := .metrics.tuning.excludeMetrics }}

// Scrape metrics from blackbox exporter
prometheus.scrape {{ include "helper.alloy_name" .name | quote }} {
  targets = concat(
    prometheus.exporter.blackbox.{{ include "helper.alloy_name" .name }}.targets,
    prometheus.relabel.static_targets_{{ include "helper.alloy_name" .name }}.output,
    {{- if .discovery.enabled }}
    discovery.relabel.httproutes_{{ include "helper.alloy_name" .name }}.output,
    {{- end }}
  )
  job_name = {{ .jobLabel | quote }}
{{- if .metrics.scrapeInterval }}
  scrape_interval = {{ .metrics.scrapeInterval | quote }}
{{- end }}
  params = {
    module = [{{ .exporter.module | quote }}],
  }
  forward_to = [prometheus.relabel.{{ include "helper.alloy_name" .name }}.receiver]
}

prometheus.relabel {{ include "helper.alloy_name" .name | quote }} {
  max_cache_size = {{ .metrics.maxCacheSize | default $.Values.global.maxCacheSize | int }}
  
  // Set instance label if not present
  rule {
    source_labels = ["instance"]
    regex = "^$|127\\.0\\.0\\.1:9115"
    target_label = "instance"
    replacement = {{ .name | quote }}
  }
  
  // Keep the target label for visibility
  rule {
    source_labels = ["target"]
    target_label = "target"
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