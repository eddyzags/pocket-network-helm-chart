{{/*
This file implements several helpers function to define init containers for the
Pocket Network Helm Chart.
*/}}

{{- define "pocket-network.shannon.initcontainers.relayminer.working-directory" -}}
- name: working-directory
  image: busybox
  {{- with .Values.shannon.relayminer.containersSecurityContext }}
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
  {{- with .Values.shannon.fullnode.containersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      cosmovisor init /bin/{{ .Values.shannon.fullnode.cosmosvisor.daemon.name }}
  volumeMounts:
    - name: working-directory
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
        aria2c --seed-time=0 --file-allocation=none --dir {{ .Values.workingDirectory }}/snapshot "{{ .Values.shannon.fullnode.snapshot.config.url }}" || exit 1

        tar --no-same-owner -vxf {{ .Values.workingDirectory }}/snapshot/*.tar.zst --directory {{ .Values.workingDirectory }}/data || exit 1
        {{ if and .Values.shannon.fullnode.snapshot.config.chownAsUser .Values.shannon.fullnode.snapshot.config.chownAsGroup }}
        chown -R {{ .Values.shannon.fullnode.snapshot.config.chownAsUser }}:{{ .Values.shannon.fullnode.snapshot.config.chownAsGroup}} {{ .Values.workingDirectory }}/data || exit 1
        {{- end }}

        touch "$MARKER"
      fi
  volumeMounts:
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}/snapshot
      subPath: snapshot
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}/data
      subPath: data
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
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}/snapshot
      subPath: snapshot
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}/data
      subPath: data
{{- end }}
{{- end -}}

{{- define "pocket-network.shannon.initcontainers.fullnode.cosmossdk" -}}
- name: cosmossdk
  image: "{{ .Values.shannon.fullnode.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default .Values.version }}"
  {{- with .Values.shannon.fullnode.containersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 12 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      pocketd init --home {{.Values.workingDirectory }} {{ .Values.chain }} > /dev/null 2>&1 && \
      echo genesis file initialized || \
      echo genesis file already exists. Continuing...
  volumeMounts:
    - name: working-directory
      mountPath: {{ .Values.workingDirectory }}/data
      subPath: data
{{- end -}}

{{- define "pocket-network.shannon.initcontainers.fullnode.get-genesis" -}}
- name: get-genesis
  image: busybox
  securityContext:
    runAsUser: 0
    runAsGroup: 0
  command: # Requires root privileged to create .Values.workingDirectory directory
    - "/bin/sh"
    - "-c"
    - |
      mkdir -p {{ .Values.workingDirectory }}/config
      wget -O {{ .Values.workingDirectory }}/config/genesis.json https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/refs/heads/master/shannon/{{- include "pocket-network.utils.toGenesisRef" .Values.chain -}}/genesis.json
      {{- if .Values.shannon.fullnode.podSecurityContext }}
      chown -R {{ .Values.shannon.fullnode.podSecurityContext.runAsUser }}:{{ .Values.shannon.fullnode.podSecurityContext.runAsGroup}} {{ .Values.workingDirectory }}
      {{- else if .Values.shannon.fullnode.containersSecurityContext }}
      chown -R {{ .Values.shannon.fullnode.containersSecurityContext.runAsUser }}:{{ .Values.shannon.fullnode.containersSecurityContext.runAsGroup}} {{ .Values.workingDirectory }}
      {{- end }}
  volumeMounts:
    - name: working-directory-config
      mountPath: {{ .Values.workingDirectory}}/config
{{- end -}}