{{- define "integrations.dnsmasq.validate" }}
  {{- $integration := .integration }}
  {{- $type := .type }}
  {{- if eq $type "metrics" }}
    {{- $defaultValues := "integrations/dnsmasq-values.yaml" | .Files.Get | fromYaml }}
    {{- range $idx, $instance := $integration.instances }}
      {{- $mergedValues := mergeOverwrite $defaultValues $instance }}
      {{- if empty $mergedValues.name }}
        {{- fail (printf "dnsmasq instance %d is missing the 'name' field" $idx) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "integrations.dnsmasq.type.logs" }}false{{- end }}
