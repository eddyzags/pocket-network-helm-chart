{{/*
This function implements request/limit object based on a given preset string
(ex: small, medium, large)
*/}}

{{- define "pocket-network.shannon.fullnode.preset" -}}
{{- $presets := dict
  "small" (dict
      "requests" (dict "cpu" "500m" "memory" "16Gi")
      "limits" (dict "cpu" "1000m" "memory" "20Gi")
  )
  "medium" (dict
      "requests" (dict "cpu" "1500m" "memory" "20Gi")
      "limits" (dict "cpu" "2000m" "memory" "30Gi")
  )
  "large" (dict
      "requests" (dict "cpu" "3000m" "memory" "40Gi")
      "limits" (dict "cpu" "4000m" "memory" "45Gi")
  )
}}
{{- if hasKey $presets .type -}}
{{- index $presets .type | toYaml -}}
{{- else -}}
{{- printf "preset keys invalid (%s). (Allowed presets: %s)" .type (join "," (keys $presets)) | fail -}}
{{- end -}}
{{- end -}}

{{- define "pocket-network.shannon.relayminer.preset" -}}
{{- $presets := dict
  "small" (dict
      "requests" (dict "cpu" "1000m" "memory" "8Gi")
      "limits" (dict "cpu" "2000m" "memory" "14Gi")
  )
  "medium" (dict
      "requests" (dict "cpu" "2000m" "memory" "16Gi")
      "limits" (dict "cpu" "3000m" "memory" "20Gi")
  )
  "large" (dict
      "requests" (dict "cpu" "3000m" "memory" "32Gi")
      "limits" (dict "cpu" "4000m" "memory" "40Gi")
  )
}}
{{- if hasKey $presets .type -}}
{{- index $presets .type | toYaml -}}
{{- else -}}
{{- printf "preset keys invalid (%s). (Allowed presets: %s)" .type (join "," (keys $presets)) | fail -}}
{{- end -}}
{{- end -}}