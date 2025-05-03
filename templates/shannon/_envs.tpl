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

{{- define "pocket-network.shannon.envs.snapshots" }}
# Base URL for snapshots
- name: POCKET_HOME
  value: {{ .Values.homeDirectory }}
- name: SNAPSHOT_BASE_URL
  value: {{ .Values.shannon.fullnode.snapshot.url | quote }}
- name: NETWORK
  value: {{ .Values.network | quote }}
- name: ARCHIVAL
  value: {{ .Values.shannon.fullnode.snapshot.archival | quote }}
- name: RESNAPSHOT
  value: {{ .Values.shannon.fullnode.snapshot.resnapshot | quote }}
- name: FORCE_DOWNLOAD
  value: {{ .Values.shannon.fullnode.snapshot.forceDownload | quote }}
- name: PRESERVE_DOWNLOADS
  value: {{ .Values.shannon.fullnode.snapshot.preserveDownloads | quote }}
- name: VERIFY_FREE_SPACE
  value: {{ .Values.shannon.fullnode.snapshot.verifyFreeSpace | quote }}
{{- end }}
