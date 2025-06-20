{{- define "integrations.consul.validate" }}
  {{- $integration := .integration }}
  {{- $type := .type }}
  {{- if eq $type "metrics" }}
    {{- $defaultValues := "integrations/consul-values.yaml" | .Files.Get | fromYaml }}
    {{- range $idx, $instance := $integration.instances }}
      {{- $mergedValues := mergeOverwrite $defaultValues $instance }}
      {{- if empty $mergedValues.name }}
        {{- fail (printf "consul instance %d is missing the 'name' field" $idx) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "integrations.consul.type.logs" }}false{{- end }}
