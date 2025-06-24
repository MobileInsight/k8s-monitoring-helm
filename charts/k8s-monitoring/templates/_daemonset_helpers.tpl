{{/* Helper to determine if we should use DaemonSet node filtering */}}
{{- define "alloy-metrics.useDaemonSetFiltering" }}
{{- if eq (include "alloy-metrics.isDaemonSet" .) "true" }}true{{- else }}false{{- end }}
{{- end }}

{{/* Helper to add node filtering to discovery.kubernetes when in DaemonSet mode */}}
{{- define "alloy-metrics.nodeFilter" }}
{{- if eq (include "alloy-metrics.useDaemonSetFiltering" .) "true" }}
    field = "spec.nodeName=" + sys.env("HOSTNAME")
{{- end }}
{{- end }}

{{/* Helper to determine clustering value based on controller type */}}
{{- define "alloy-metrics.clustering" }}
{{- if eq (include "alloy-metrics.isDaemonSet" .) "true" }}false{{- else }}true{{- end }}
{{- end }}