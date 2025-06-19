{{/*
This file implements several helpers function to define init containers for the
Pocket Network Helm Chart.
*/}}

{{- define "pocket-network.shannon.initcontainers.relayminer.working-directory" -}}
- name: working-directory
  image: busybox
  {{- with .Values.shannon.relayminer.initContainersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 12 }}
  {{- end }}
  command:
    - sh
    - -c
    - |
      mkdir -p {{ .Values.workingDirectory }}/config
      mkdir -p {{ .Values.workingDirectory }}/keyring-test
  volumeMounts:
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}
{{- end }}

{{- define "pocket-network.shannon.initcontainers.fullnode.cosmosvisor" -}}
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
      mountPath: {{ .Values.workingDirectory }}
  env:
  {{- include "pocket-network.shannon.envs.cosmosvisor" . | nindent 2 }}
{{- end -}}

{{- define "pocket-network.shannon.initcontainers.fullnode.get-snapshot" -}}
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

      MARKER="{{ .Values.workingDirectory }}/snapshot/.{{ replace "/" "_" .Values.shannon.fullnode.snapshot.config.url }}"

      mkdir -p {{ .Values.workingDirectory }}/snapshot

      if [ -f "$MARKER" ]; then
        echo "Snapshot already downloaded. ({{ .Values.shannon.fullnode.snapshot.config.url }})"
      else
        echo "Removing existing snapshot..."
        rm -r {{ .Values.workingDirectory }}/snapshot/* > /dev/null 2>&1

        echo "Downloading snapshot..."
        aria2c --seed-time=0 --file-allocation=none --dir {{ .Values.workingDirectory }}/snapshot "{{ .Values.shannon.fullnode.snapshot.config.url }}"

        tar --no-same-owner -vxf {{ .Values.workingDirectory }}/snapshot/*.tar.zst --directory {{ .Values.workingDirectory }}/data
        {{ if and .Values.shannon.fullnode.snapshot.config.chownAsUser .Values.shannon.fullnode.snapshot.config.chownAsGroup }}
        chown -R {{ .Values.shannon.fullnode.snapshot.config.chownAsUser }}:{{ .Values.shannon.fullnode.snapshot.config.chownAsGroup}} {{ .Values.workingDirectory }}/data
        {{- end }}

        touch "$MARKER"
      fi
  volumeMounts:
    - name: home-config
      mountPath: {{ .Values.workingDirectory }}
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
      value: {{ .Values.workingDirectory }}
  command:
    {{- toYaml .Values.shannon.fullnode.snapshot.command | nindent 4 }}
  volumeMounts:
    - name: home-config
      mountPath: {{ .Values.workingDirectory }}
{{- end }}
{{- end -}}

{{- define "pocket-network.shannon.initcontainers.fullnode.cosmossdk" -}}
- name: cosmossdk
  image: "{{ .Values.shannon.fullnode.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default .Values.version }}"
  {{- if .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml .Values.shannon.fullnode.initContainersSecurityContext | nindent 12 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      pocketd init --home {{.Values.workingDirectory }} {{ .Values.network }} > /dev/null 2>&1 && \
      echo genesis file initialized || \
      echo genesis file already exists. Continuing...
  volumeMounts:
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}
{{- end -}}

{{- define "pocket-network.shannon.initcontainers.fullnode.get-genesis" -}}
- name: get-genesis
  image: busybox
  {{- if .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml .Values.shannon.fullnode.initContainersSecurityContext | nindent 12 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      wget -O {{ .Values.workingDirectory }}/config/genesis.json https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/refs/heads/master/shannon/{{ .Values.network}}/genesis.json
  volumeMounts:
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}
{{- end -}}