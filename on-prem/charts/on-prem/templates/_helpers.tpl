{{/*
Expand the name of the chart.
*/}}
{{- define "on-prem.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "on-prem.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "on-prem.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "on-prem.labels" -}}
helm.sh/chart: {{ include "on-prem.chart" . }}
{{ include "on-prem.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "on-prem.selectorLabels" -}}
app.kubernetes.io/name: {{ include "on-prem.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "on-prem.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "on-prem.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
### Server Definations ###
*/}}
{{/*
### Define server deployment assets ###
*/}}
{{- define "on-prem.server.deployment.name" -}}
  {{ template "on-prem.name" . }}-server
{{- end -}}

{{- define "on-prem.server.pod.name" -}}
  {{ template "on-prem.name" . }}-server-pod
{{- end -}}

{{- define "on-prem.server.container.name" -}}
  {{ template "on-prem.name" . }}-server-container
{{- end -}}

{{/*
### Define server deployment services ###
*/}}
{{- define "on-prem.server.service.name" -}}
  {{ template "on-prem.name" . }}-server-service
{{- end -}}

{{/*
### Define server deployment ingress resource ###
*/}}
{{- define "on-prem.server.ingress.resource.name" -}}
  {{ template "on-prem.name" . }}-server-ingress-resource
{{- end -}}

{{/*
### Worker Definations ###
*/}}
{{/*
### Define worker deployment assets ###
*/}}
{{- define "on-prem.worker.deployment.name" -}}
  {{ template "on-prem.name" . }}-worker
{{- end -}}

{{- define "on-prem.worker.pod.name" -}}
  {{ template "on-prem.name" . }}-worker-pod
{{- end -}}

{{- define "on-prem.worker.container.name" -}}
  {{ template "on-prem.name" . }}-worker-container
{{- end -}}

{{/*
### Define worker deployment Volume Mounts (PV, PVC and storageclass) ###
*/}}

{{- define "on-prem.worker.storageclass.name" -}}
  {{ template "on-prem.name" . }}-worker-storageclass
{{- end -}}

{{- define "on-prem.worker.pvc.name" -}}
  {{ template "on-prem.name" . }}-worker-pvc
{{- end -}}

{{- define "on-prem.worker.pv.name" -}}
  {{ template "on-prem.name" . }}-worker-pv
{{- end -}}

