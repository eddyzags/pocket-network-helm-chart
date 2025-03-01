{{/*
Expand the name of the chart.
*/}}
{{- define "pocket-network.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pocket-network.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pocket-network.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pocket-network.labels" -}}
helm.sh/chart: {{ include "pocket-network.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pocket-network.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pocket-network.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pocket-network.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pocket-network.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Parse URL.
*/}}

{{- define "pocket-network.utils.listenURLToPorts" -}}
{{- range .suppliers }}
{{- $url := .listen_url }}
{{- if not (contains "://" $url) }}
{{- fail "Invalid URL format: must contain '://'. Example: http://0.0.0.0:8545" }}{{- end }}
{{- $protocolParts := split "://" $url }}
{{- $protocol := $protocolParts._0 }}
{{- $remaining := $protocolParts._1 }}
{{- $hostParts := split "/" $remaining }}
{{- $hostPort := $hostParts._0 }}
{{- $hostAndPort := split ":" $hostPort }}
{{- $host := $hostAndPort._0 }}
{{- $port := "" }}
{{- if eq (len $hostAndPort) 2 }}
{{- $port = $hostAndPort._1 }}{{- end }}
- port: {{ $port }}
  targetPort: {{ $port }}
  protocol: TCP
  name: {{ $protocol }}{{- end }}
{{- end }}