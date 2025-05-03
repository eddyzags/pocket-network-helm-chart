{{/*
This file implements several helpers function to define init containers.
*/}}

{{- define "pocket-network.shannon.initcontainers.cosmossdk" -}}
- name: cosmossdk
  image: "{{ .Values.shannon.fullnode.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default .Values.version }}"
  {{- with .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      pocketd init --home {{.Values.homeDirectory }} {{ .Values.network }} > /dev/null 2>&1 && \
      echo genesis file initialized || \
      echo genesis file already exists. Continuing...
  volumeMounts:
    - name: data
      mountPath: {{ .Values.homeDirectory }}
{{- end }}

{{- define "pocket-network.shannon.initcontainers.get-genesis" -}}
- name: get-genesis
  image: busybox
  {{- with .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      wget -O {{ .Values.homeDirectory }}/config/genesis.json https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/refs/heads/master/shannon/{{ .Values.network}}/genesis.json
  volumeMounts:
    - name: data
      mountPath: {{ .Values.homeDirectory }}
{{- end }}

{{- define "pocket-network.shannon.initcontainers.cosmosvisor" -}}
- name: cosmosvisor
  image: "{{ .Values.shannon.fullnode.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default .Values.version }}"
  {{- with .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      cosmovisor init /bin/{{ .Values.shannon.fullnode.cosmosvisor.daemon.name }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.homeDirectory }}
  env:
  {{- include "pocket-network.shannon.envs.cosmosvisor" . | nindent 2 }}
{{- end }}

{{- define "pocket-network.shannon.initcontainers.permissions" -}}
- name: permissions
  image: "{{ .Values.shannon.fullnode.image.repository }}:{{ .Values.shannon.fullnode.image.tag | default .Values.version }}"
  {{- with .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  command:
    - "/bin/sh"
    - "-c"
    - |
      {{- if and .Values.shannon.fullnode.podSecurityContext .Values.shannon.fullnode.podSecurityContext.runAsUser .Values.shannon.fullnode.podSecurityContext.runAsGroup }}
      chown -R {{ .Values.shannon.fullnode.podSecurityContext.runAsUser }}:{{ .Values.shannon.fullnode.podSecurityContext.runAsGroup }} {{ .Values.homeDirectory }}
      {{- else if and .Values.shannon.fullnode.containersSecurityContext .Values.shannon.fullnode.containersSecurityContext.runAsUser .Values.shannon.fullnode.containersSecurityContext.runAsGroup }}
      chown -R {{ .Values.shannon.fullnode.containersSecurityContext.runAsUser }}:{{ .Values.shannon.fullnode.containersSecurityContext.runAsGroup }} {{ .Values.homeDirectory }}
      {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.homeDirectory }}
  env:
  {{- include "pocket-network.shannon.envs.cosmosvisor" . | nindent 2 }}
{{- end }}

{{- define "pocket-network.shannon.initcontainers.snapshots" -}}
- name: get-snapshot
  image: "{{ .Values.shannon.fullnode.snapshot.image.repository }}:{{ .Values.shannon.fullnode.snapshot.image.tag | default "latest" }}"
  env:
  {{- include "pocket-network.shannon.envs.snapshots" . | nindent 2 }}
  {{- if .Values.shannon.fullnode.snapshot.customCommand.enabled }}
  command: {{ toYaml .Values.shannon.fullnode.snapshot.customCommand.command | nindent 12 }}
  {{- with .Values.shannon.fullnode.initContainersSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.homeDirectory }}
  {{- else if .Values.shannon.fullnode.snapshot.customScript.enabled }}
  command:
    - /bin/sh
    - -c
    - |
      set -x
      set -e
      id
      mkdir -p {{ .Values.homeDirectory }}/bin
      cp /tmp/custom-script.sh {{ .Values.homeDirectory}}/bin/custom-script.sh
      chmod +x {{ .Values.homeDirectory}}/bin/custom-script.sh
      {{ .Values.homeDirectory}}/bin/custom-script.sh
  volumeMounts:
    - name: snapshot-script
      mountPath: /tmp/custom-script.sh
      subPath: custom-script.sh
    # Other mount points
    - name: data
      mountPath: {{ .Values.homeDirectory }}
  {{- else }}
  command:
    - /bin/sh
    - -c
    - |
      set -e
      echo "running as: $(id)"
      mkdir -p {{ .Values.homeDirectory }}/bin
      scriptPath={{ .Values.homeDirectory }}/bin/get-snapshot.sh
      fileUrl={{ .Values.shannon.fullnode.snapshot.scriptUrl | quote }}
      rm -rf "$scriptPath"
      # download snapshot shell script
      curl -sSL $fileUrl -o "$scriptPath"
      chmod +x "$scriptPath"
      "$scriptPath"
  volumeMounts:
    - name: data
      mountPath: {{ .Values.homeDirectory }}
  {{- end }}
{{- end }}
