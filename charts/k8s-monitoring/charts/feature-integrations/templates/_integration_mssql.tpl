{{- define "integrations.mssql.validate" }}
  {{- $integration := .integration }}
  {{- $type := .type }}
  {{- if eq $type "metrics" }}
    {{- $defaultValues := "integrations/mssql-values.yaml" | .Files.Get | fromYaml }}
    {{- range $idx, $instance := $integration.instances }}
      {{- $mergedValues := mergeOverwrite $defaultValues $instance }}
      {{- if empty $mergedValues.name }}
        {{- fail (printf "mssql instance %d is missing the 'name' field" $idx) }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{- define "secrets.list.integration.mssql" }}
- exporter.auth.username
- exporter.auth.password
{{- end }}

{{- define "integrations.mssql.type.logs" }}false{{- end }}
