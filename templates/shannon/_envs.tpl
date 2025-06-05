{{/*
This file implements several helpers function to define init containers.
*/}}

{{- define "pocket-network.shannon.envs.cosmosvisor" }}
- name: DAEMON_NAME
  value: {{ .Values.shannon.fullnode.cosmosvisor.daemon.name }}
- name: DAEMON_HOME
  value: {{ .Values.shannon.fullnode.cosmosvisor.workingDirectory | default .Values.homeDirectory }}
- name: DAEMON_ALLOW_DOWNLOAD_BINARIES
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.allowDownloadBinaries }}"
- name: UNSAFE_SKIP_BACKUP
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.unsafeSkipBackup }}"
- name: DAEMON_POLL_INTERVAL
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.pollInterval }}"
- name: DAEMON_PREUPGRADE_MAX_RETRIES
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.preupgradeMaxRetries }}"
- name: DAEMON_DOWNLOAD_MUST_HAVE_CHECKSUM
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.downloadMustHaveChecksum }}"
- name: DAEMON_RESTART_AFTER_UPGRADE
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.restartAfterUpgrade }}"
- name: DAEMON_RESTART_DELAY
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.restartDelay }}"
- name: DAEMON_SHUTDOWN_GRACE
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.shutdownGrace }}"
- name: DAEMON_DATA_BACKUP_DIR
  value: "{{ .Values.shannon.fullnode.cosmosvisor.daemon.dataBackupDir }}"
- name: COSMOVISOR_DISABLE_LOGS
  value: "{{ .Values.shannon.fullnode.cosmosvisor.disableLogs }}"
- name: COSMOVISOR_COLOR_LOGS
  value: "{{ .Values.shannon.fullnode.cosmosvisor.colorLogs }}"
- name: COSMOVISOR_TIMEFORMAT_LOGS
  value: "{{ .Values.shannon.fullnode.cosmosvisor.timeformatLogs }}"
- name: COSMOVISOR_CUSTOM_PREUPGRADE
  value: "{{ .Values.shannon.fullnode.cosmosvisor.customPreupgrade }}"
- name: COSMOVISOR_DISABLE_RECASE
  value: "{{ .Values.shannon.fullnode.cosmosvisor.disableRecase }}"
{{- end }}
