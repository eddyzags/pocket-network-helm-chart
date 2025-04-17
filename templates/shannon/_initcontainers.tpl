{{/*
This file implements several helpers function to define init containers.
*/}}

{{- define "pocket-network.shannon.initcontainers.cosmosvisor" -}}
- name: cosmosvisor
  image: "{{ .Values.shannon.fullnode.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default .Values.version }}"
  {{- if .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml .Values.shannon.fullnode.initContainersSecurityContext | nindent 4 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      cosmovisor init /bin/{{ .Values.shannon.fullnode.cosmosvisor.daemon.name }}
  volumeMounts:
    - name: home-config
      mountPath: {{ .Values.homeDirectory }}
  env:
  {{- include "pocket-network.shannon.envs.cosmosvisor" . | nindent 2 }}
{{- end }}
