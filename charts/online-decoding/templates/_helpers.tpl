{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "livestreamdecoding.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "livestreamdecoding.fullname" -}}
{{- if $.Values.fullnameOverride -}}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default $.Chart.Name $.Values.nameOverride -}}
{{- if contains $name $.Release.Name -}}
{{- $.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "livestreamdecoding.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "livestreamdecoding.labels" -}}
helm.sh/chart: {{ template "livestreamdecoding.chart" . }}
{{ include "livestreamdecoding.selectorLabels" . }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "livestreamdecoding.selectorLabels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "livestreamdecoding.serviceAccountName" -}}
{{- if $.Values.serviceAccounts.livestreamdecoding.create -}}
    {{ default (include "livestreamdecoding.fullname" .) }}
{{- else -}}
    {{ default "default" $.Values.serviceAccounts.livestreamdecoding.name }}
{{- end -}}
{{- end -}}


{{/*
Define the livestreamdecoding.namespace template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "livestreamdecoding.namespace" -}}
{{- if $.Values.namespace -}}
{{ printf "namespace: %s" $.Values.namespace }}
{{- else -}}
{{ printf "namespace: %s" $.Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Get KubeVersion removing pre-release information.
*/}}
{{- define "stt.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version (regexFind "v[0-9]+\\.[0-9]+\\.[0-9]+" .Capabilities.KubeVersion.Version) -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for rbac.
*/}}
{{- define "rbac.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" }}
{{- print "rbac.authorization.k8s.io/v1" -}}
{{- else -}}
{{- print "rbac.authorization.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "livestreamdecoding.networkPolicy.apiVersion" -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for podsecuritypolicy.
*/}}
{{- define "livestreamdecoding.podSecurityPolicy.apiVersion" -}}
{{- print "policy/v1beta1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "livestreamdecoding.deployment.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for daemonset.
*/}}
{{- define "livestreamdecoding.daemonset.apiVersion" -}}
{{- print "apps/v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for service.
*/}}
{{- define "livestreamdecoding.service.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for PersistentVolumeClaim.
*/}}
{{- define "livestreamdecoding.pvc.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ConfigMap.
*/}}
{{- define "livestreamdecoding.configmap.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for Secret.
*/}}
{{- define "livestreamdecoding.secret.apiVersion" -}}
{{- print "v1" -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "ingress.isStable" -}}
  {{- eq (include "ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "ingress.supportsIngressClassName" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "stt.kubeVersion" .))) -}}
{{- end -}}
{{/*
Return if ingress supports pathType.
*/}}
{{- define "ingress.supportsPathType" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "stt.kubeVersion" .))) -}}
{{- end -}}


{{/*
Define name for livestreamdecoding components
*/}}
{{- define "livestreamdecoding.master.fullname" -}}
{{ template "livestreamdecoding.name" . }}-master
{{- end -}}
{{- define "livestreamdecoding.worker.fullname" -}}
{{ template "livestreamdecoding.name" . }}-worker
{{- end -}}
{{- define "livestreamdecoding.hwworker.fullname" -}}
{{ template "livestreamdecoding.name" . }}-hotword-decoder
{{- end -}}
{{- define "livestreamdecoding.sdkworker.fullname" -}}
{{ template "livestreamdecoding.name" . }}-sdk-decoder
{{- end -}}
{{- define "livestreamdecoding.twilioconnector.fullname" -}}
{{ template "livestreamdecoding.name" . }}-twilioconnector
{{- end -}}


{{/*
Create unified labels for livestreamdecoding components
*/}}
{{- define "livestreamdecoding.common.matchLabels" -}}
{{ include "livestreamdecoding.selectorLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.common.metaLabels" -}}
{{ include "livestreamdecoding.labels" . }}
{{- end -}}



{{- define "livestreamdecoding.master.labels" -}}
{{ include "livestreamdecoding.common.metaLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.master.matchLabels" -}}
{{- printf "%s: %s" "component" "master" | trunc 63 | trimSuffix "-" }}
{{ include "livestreamdecoding.common.matchLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.worker.labels" -}}
{{ include "livestreamdecoding.common.metaLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.worker.matchLabels" -}}
{{- printf "%s: %s" "component" "worker" | trunc 63 | trimSuffix "-" }}
{{ include "livestreamdecoding.common.matchLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.hwworker.labels" -}}
{{ include "livestreamdecoding.common.metaLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.hwworker.matchLabels" -}}
{{- printf "%s: %s" "component" "hotword-worker" | trunc 63 | trimSuffix "-" }}
{{ include "livestreamdecoding.common.matchLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.sdkworker.labels" -}}
{{ include "livestreamdecoding.common.metaLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.sdkworker.matchLabels" -}}
{{- printf "%s: %s" "component" "sdk-worker" | trunc 63 | trimSuffix "-" }}
{{ include "livestreamdecoding.common.matchLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.twilioconnector.labels" -}}
{{ include "livestreamdecoding.common.metaLabels" . }}
{{- end -}}

{{- define "livestreamdecoding.twilioconnector.matchLabels" -}}
{{- printf "%s: %s" "component" "twilioconnector" | trunc 63 | trimSuffix "-" }}
{{ include "livestreamdecoding.common.matchLabels" . }}
{{- end -}}

