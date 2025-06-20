{{- define "integrations.cadvisor.validate" }}
  {{- $integration := .integration }}
  {{- $type := .type }}
  {{- if eq $type "metrics" }}
    {{- $defaultValues := "integrations/cadvisor-values.yaml" | .Files.Get | fromYaml }}
    {{- range $idx, $instance := $integration.instances }}
      {{- $mergedValues := mergeOverwrite $defaultValues $instance }}
      {{- if empty $mergedValues.name }}
        {{- fail (printf "cadvisor instance %d is missing the 'name' field" $idx) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "integrations.cadvisor.type.logs" }}false{{- end }}
