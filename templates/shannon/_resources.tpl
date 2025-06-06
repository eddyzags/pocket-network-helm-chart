{{/*
This function implements request/limit object based on a given preset string
(ex: small, medium, large)
*/}}

{{- define "pocket-network.shannon.preset" -}}
{{- $presets := dict
  "small" (dict
      "requests" (dict "cpu" "1000m" "memory" "6Gi")
      "limits" (dict "cpu" "2000m" "memory" "8Gi")
  )
  "medium" (dict
      "requests" (dict "cpu" "2000m" "memory" "16Gi")
      "limits" (dict "cpu" "3000m" "memory" "18Gi")
  )
  "large" (dict
      "requests" (dict "cpu" "3000m" "memory" "12Gi")
      "limits" (dict "cpu" "4000m" "memory" "13Gi")
  )
}}
{{- if hasKey $presets .type -}}
{{- index $presets .type | toYaml -}}
{{- else -}}
{{- printf "preset keys invalid (%s). (Allowed presets: %s)" .type (join "," (keys $presets)) | fail -}}
{{- end -}}
{{- end -}}