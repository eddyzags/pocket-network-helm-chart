{{/*
This file implements several helpers function to define init containers.
*/}}

{{- define "pocket-network.shannon.envs.cosmosvisor" }}
- name: DAEMON_NAME
  value: {{ .Values.shannon.fullnode.cosmosvisor.daemon.name }}
- name: DAEMON_HOME
  value: {{ .Values.homeDirectory }}
- name: DAEMON_ALLOW_DOWNLOAD_BINARIES
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.allowDownloadBinaries }}"
- name: UNSAFE_SKIP_BACKUP
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.unsafeSkipBackup }}"
- name: DAEMON_POLL_INTERVAL
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.pollInterval }}"
- name: DAEMON_PREUPGRADE_MAX_RETRIES
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.preupgradeMaxRetries }}"
{{- end }}
