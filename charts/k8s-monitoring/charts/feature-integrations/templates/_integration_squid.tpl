{{- define "integrations.squid.validate" }}
  {{- $integration := .integration }}
  {{- $type := .type }}
  {{- if eq $type "metrics" }}
    {{- $defaultValues := "integrations/squid-values.yaml" | .Files.Get | fromYaml }}
    {{- range $idx, $instance := $integration.instances }}
      {{- $mergedValues := mergeOverwrite $defaultValues $instance }}
      {{- if empty $mergedValues.name }}
        {{- fail (printf "squid instance %d is missing the 'name' field" $idx) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "integrations.squid.type.logs" }}false{{- end }}
