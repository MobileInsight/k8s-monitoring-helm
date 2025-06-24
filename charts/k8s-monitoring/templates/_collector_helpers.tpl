{{/*
Helper to determine if clustering should be enabled based on the metrics collector mode.
When mode is "daemonset", clustering should be disabled.
*/}}
{{- define "collector.clustering" -}}
{{- if eq .Values.global.metricsCollector.mode "daemonset" -}}
false
{{- else -}}
true
{{- end -}}
{{- end -}}

{{/*
Helper to add node filtering for DaemonSet mode.
This adds field selectors to limit discovery to the current node.
*/}}
{{- define "collector.nodeFilter" -}}
{{- if eq .Values.global.metricsCollector.mode "daemonset" -}}
field_selectors = ["spec.nodeName=$(HOSTNAME)"]
{{- end -}}
{{- end -}}

{{/*
Helper to add node filtering to existing field selectors.
This merges node filtering with any existing field selectors.
*/}}
{{- define "collector.fieldSelectors" -}}
{{- $fieldSelectors := .fieldSelectors | default list -}}
{{- if eq .Values.global.metricsCollector.mode "daemonset" -}}
  {{- $fieldSelectors = append $fieldSelectors "spec.nodeName=$(HOSTNAME)" -}}
{{- end -}}
{{- if $fieldSelectors -}}
field_selectors = {{ $fieldSelectors | toJson }}
{{- end -}}
{{- end -}}