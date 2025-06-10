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

{{- define "pocket-network.shannon.initcontainers.get-snapshot" -}}
- name: get-snapshot
{{- if eq .Values.shannon.fullnode.snapshot.type "ariac" }}
  image: debian:bullseye-slim
  securityContext: # Requires root privileged to execute package manager (apt).
    runAsUser: 0
    runAsGroup: 0
  command:
    - "/bin/sh"
    - "-c"
    - |
      apt update && apt install -y aria2 \
          zstd \
          tar

      MARKER="{{ .Values.homeDirectory }}/snapshot/.{{ replace "/" "_" .Values.shannon.fullnode.snapshot.config.url }}"

      mkdir -p {{ .Values.homeDirectory }}/snapshot

      if [ -f "$MARKER" ]; then
        echo "Snapshot already downloaded. ({{ .Values.shannon.fullnode.snapshot.config.url }})"
      else
        echo "Removing existing snapshot..."
        rm -r {{ .Values.homeDirectory }}/snapshot/* > /dev/null 2>&1

        echo "Downloading snapshot..."
        aria2c --seed-time=0 --file-allocation=none --dir {{ .Values.homeDirectory }}/snapshot "{{ .Values.shannon.fullnode.snapshot.config.url }}"

        tar --no-same-owner -vxf {{ .Values.homeDirectory }}/snapshot/*.tar.zst --directory {{ .Values.homeDirectory }}/data
        {{ if and .Values.shannon.fullnode.snapshot.config.chownAsUser .Values.shannon.fullnode.snapshot.config.chownAsGroup }}
        chown -R {{ .Values.shannon.fullnode.snapshot.config.chownAsUser }}:{{ .Values.shannon.fullnode.snapshot.config.chownAsGroup}} {{ .Values.homeDirectory }}/data
        {{- end }}

        touch "$MARKER"
      fi
  volumeMounts:
    - name: home-config
      mountPath: {{ .Values.homeDirectory }}
{{- else if eq .Values.shannon.fullnode.snapshot.type "custom" }}
  image: "{{ .Values.shannon.fullnode.snapshot.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default "latest" }}"
  {{- if .Values.shannon.fullnode.snapshot.securityContext }}
  securityContext:
    {{- toYaml .Values.shannon.fullnode.snapshot.securityContext | nindent 4 }}
  {{- end }}
  {{- if .Values.shannon.fullnode.snapshot.resources }}
  resources:
    {{- toYaml .Values.shannon.fullnode.snapshot.resources | nindent 4 }}
  {{- end }}
  env:
    - name: POCKETD_WORKING_DIRECTORY
      value: {{ .Values.homeDirectory }}
  command:
    {{- toYaml .Values.shannon.fullnode.snapshot.command | nindent 4 }}
  volumeMounts:
    - name: home-config
      mountPath: {{ .Values.homeDirectory }}
{{- end }}
{{- end }}