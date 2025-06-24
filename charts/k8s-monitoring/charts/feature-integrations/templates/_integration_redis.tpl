{{- define "integrations.redis.validate" }}
  {{- $integration := .integration }}
  {{- $type := .type }}
  {{- if eq $type "metrics" }}
    {{- $defaultValues := "integrations/redis-values.yaml" | .Files.Get | fromYaml }}
    {{- range $idx, $instance := $integration.instances }}
      {{- $mergedValues := mergeOverwrite $defaultValues $instance }}
      {{- if empty $mergedValues.name }}
        {{- fail (printf "redis instance %d is missing the 'name' field" $idx) }}
      {{- end }}
      {{- if and $mergedValues.metrics.enabled (empty $mergedValues.exporter.address) }}
        {{- fail (printf "redis instance '%s' is missing the 'exporter.address' field" $mergedValues.name) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "secrets.list.integration.redis" }}
- exporter.auth.password
{{- end }}

{{- define "integrations.redis.type.logs" }}false{{- end }}
