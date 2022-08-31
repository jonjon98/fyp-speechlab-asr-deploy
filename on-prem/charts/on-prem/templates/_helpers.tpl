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

### Namespace Definition
{{- define "on-prem.namespace" -}}
  {{ default "default" .Values.namespace }}
{{- end -}}


### Server Definitions ###
### Define server deployment assets ###
{{- define "on-prem.server.deployment.name" -}}
  {{ template "on-prem.name" . }}-server
{{- end -}}

{{- define "on-prem.server.pod.name" -}}
  {{ template "on-prem.name" . }}-server-pod
{{- end -}}

{{- define "on-prem.server.container.name" -}}
  {{ template "on-prem.name" . }}-server-container
{{- end -}}

# container deployment Image
{{- define "on-prem.server.image.repository" -}}
  {{- if .Values.server.image -}}
    {{ default "lyvt/decoding-sdk" .Values.server.image.repository }}
  {{- else -}}
    {{ default "lyvt/decoding-sdk" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.image.tag" -}}
  {{- if .Values.server.image -}}
    {{ default .Chart.AppVersion .Values.server.image.tag }}
  {{- else -}}
    {{ default .Chart.AppVersion }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.image.pullPolicy" -}}
  {{- if .Values.server.image -}}
    {{ default "Always" .Values.server.image.pullPolicy }}
  {{- else -}}
    {{ default "Always" }}
  {{- end -}}
{{- end -}}

# Server specs
{{- define "on-prem.server.replicaCount" -}}
  {{ default 1 .Values.server.replicaCount }}
{{- end -}}

# Server deployment status
{{- define "on-prem.server.status" -}}
  {{ default "{}" .Values.server.status }}
{{- end -}}

# Server container specs
{{- define "on-prem.server.containerPort" -}}
  {{ default 8010 .Values.server.containerPort }}
{{- end -}}
# no default values for args #
{{- define "on-prem.server.args" -}} 
  {{ default .Values.server.args | toYaml | nindent 12 }}
{{- end -}}

{{- define "on-prem.server.resources" -}}
  {{ default "{}" .Values.server.resources }}
{{- end -}}

# Server container restart policy
{{- define "on-prem.server.restartPolicy" -}}
  {{ default "Always" .Values.server.restartPolicy }}
{{- end -}}


### Define server deployment services ###
{{- define "on-prem.server.service.name" -}}
  {{ template "on-prem.name" . }}-server-service
{{- end -}}

# Server services ports
{{- define "on-prem.server.service.ports.name" -}}
  {{- if .Values.server.service -}}
    {{- if .Values.server.service.ports -}}
      {{ default 8010 .Values.server.service.ports.name | quote }}
    {{- else -}}
      {{ default 8010 | quote }}
    {{- end -}}
  {{- else -}}
    {{ default 8010 | quote }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.service.ports.servicePort" -}}
  {{- if .Values.server.service -}}
    {{- if .Values.server.service.ports -}}
      {{ default 8010 .Values.server.service.ports.servicePort }}
    {{- else -}}
      {{ default 8010 }}
    {{- end -}}
  {{- else -}}
    {{ default 8010 }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.service.ports.targetPort" -}}
  {{- if .Values.server.service -}}
    {{- if .Values.server.service.ports -}}
      {{ default 8010 .Values.server.service.ports.targetPort }}
    {{- else -}}
      {{ default 8010 }}
    {{- end -}}
  {{- else -}}
    {{ default 8010 }}
  {{- end -}}
{{- end -}}

# Server services status
{{- define "on-prem.server.service.status.loadBalancer" -}}
  {{- if .Values.server.service -}}
    {{- if .Values.server.service.status -}}
      {{ default "{}" .Values.server.service.status.loadBalancer }}
    {{- else -}}
      {{ default "{}" }}
    {{- end -}}
  {{- else -}}
    {{ default "{}" }}
  {{- end -}}
{{- end -}}

### Define server deployment ingress resource ###
{{- define "on-prem.server.ingress.resource.name" -}}
  {{ template "on-prem.name" . }}-server-ingress-resource
{{- end -}}

{{- define "on-prem.server.ingressResource.ingressClassName" -}}
  {{- if .Values.server.ingressResource -}}
    {{ default "nginx" .Values.server.ingressResource.ingressClassName }}
  {{- else -}}
    {{ default "nginx" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.ingressResource.host" -}}
  {{- if .Values.server.ingressResource -}}
    {{ default "asr-project.com" .Values.server.ingressResource.host }}
  {{- else -}}
    {{ default "asr-project.com" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.ingressResource.path" -}}
  {{- if .Values.server.ingressResource -}}
    {{ default "/" .Values.server.ingressResource.path }}
  {{- else -}}
    {{ default "/" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.ingressResource.pathType" -}}
  {{- if .Values.server.ingressResource -}}
    {{ default "Prefix" .Values.server.ingressResource.pathType }}
  {{- else -}}
    {{ default "Prefix" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.server.ingressResource.port" -}}
  {{- if .Values.server.ingressResource -}}
    {{ default 8010 .Values.server.ingressResource.port }}
  {{- else -}}
    {{ default 8010 }}
  {{- end -}}
{{- end -}}


### Worker Definitions ###
### Define worker deployment assets ###
{{- define "on-prem.worker.deployment.name" -}}
  {{ template "on-prem.name" . }}-worker
{{- end -}}

{{- define "on-prem.worker.pod.name" -}}
  {{ template "on-prem.name" . }}-worker-pod
{{- end -}}

{{- define "on-prem.worker.container.name" -}}
  {{ template "on-prem.name" . }}-worker-container
{{- end -}}

# container deployment Image
{{- define "on-prem.worker.image.repository" -}}
  {{- if .Values.worker.image -}}
    {{ default "lyvt/decoding-sdk" .Values.worker.image.repository }}
  {{- else -}}
    {{ default "lyvt/decoding-sdk" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.image.tag" -}}
  {{- if .Values.worker.image -}}
    {{ default .Chart.AppVersion .Values.worker.image.tag }}
  {{- else -}}
    {{ default .Chart.AppVersion }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.image.pullPolicy" -}}
  {{- if .Values.worker.image -}}
    {{ default "Always" .Values.worker.image.pullPolicy }}
  {{- else -}}
    {{ default "Always" }}
  {{- end -}}
{{- end -}}

# Worker specs
{{- define "on-prem.worker.replicaCount" -}}
  {{ default 1 .Values.worker.replicaCount }}
{{- end -}}

{{- define "on-prem.worker.strategy.type" -}}
  {{- if .Values.worker.strategy -}}
    {{ default "Recreate" .Values.worker.strategy.type }}
  {{- else -}}
    {{ default "Recreate" }}
  {{- end -}}
{{- end -}}

# Worker deployment status
{{- define "on-prem.worker.status" -}}
  {{ default "{}" .Values.worker.status }}
{{- end -}}

# Worker container specs
# no default values for args #
{{- define "on-prem.worker.args" -}} 
  {{ default .Values.worker.args | toYaml | nindent 12 }}
{{- end -}}

{{- define "on-prem.worker.env" -}} 
  {{- range $name, $item := .Values.worker.env -}}
    {{- printf "- name: %s\n" $name | nindent 12 -}}
    {{- printf "value: %s\n" $item | nindent 14 -}}
  {{- end -}}
{{- end -}}

# worker volume mounts
{{- define "on-prem.worker.volumeMount.mountPath" -}}
  {{- if .Values.worker.volumeMount -}}
    {{ default "/opt/models/" .Values.worker.volumeMount.mountPath }}
  {{- else -}}
    {{ default "/opt/models/" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.resources" -}}
  {{ default "{}" .Values.worker.resources }}
{{- end -}}

# Worker container restart policy
{{- define "on-prem.worker.restartPolicy" -}}
  {{ default "Always" .Values.worker.restartPolicy }}
{{- end -}}


### Define worker deployment Volume Mounts (PV, PVC and storageclass) ###
# Worker storage class
{{- define "on-prem.worker.storageclass.name" -}}
  {{ template "on-prem.name" . }}-worker-storageclass
{{- end -}}

{{- define "on-prem.worker.storageClass.provisioner" -}}
  {{- if .Values.worker.storageClass -}}
    {{ default "kubernetes.io/no-provisioner" .Values.worker.storageClass.provisioner }}
  {{- else -}}
    {{ default "kubernetes.io/no-provisioner" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.storageClass.volumeBindingMode" -}}
  {{- if .Values.worker.storageClass -}}
    {{ default "WaitForFirstConsumer" .Values.worker.storageClass.volumeBindingMode }}
  {{- else -}}
    {{ default "WaitForFirstConsumer" }}
  {{- end -}}
{{- end -}}

# Worker PVC
{{- define "on-prem.worker.pvc.name" -}}
  {{ template "on-prem.name" . }}-worker-pvc
{{- end -}}

{{- define "on-prem.worker.PVC.accessModes" -}}
  {{- if .Values.worker.PVC -}}
    {{ default "ReadWriteOnce" .Values.worker.PVC.accessModes }}
  {{- else -}}
    {{ default "ReadWriteOnce" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PVC.size" -}}
  {{- if .Values.worker.PVC -}}
    {{ default "100Mi" .Values.worker.PVC.size }}
  {{- else -}}
    {{ default "100Mi" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PVC.status" -}}
  {{- if .Values.worker.PVC -}}
    {{ default "{}" .Values.worker.PVC.status }}
  {{- else -}}
    {{ default "{}" }}
  {{- end -}}
{{- end -}}

# Worker PV
{{- define "on-prem.worker.pv.name" -}}
  {{ template "on-prem.name" . }}-worker-pv
{{- end -}}

{{- define "on-prem.worker.PV.accessModes" -}}
  {{- if .Values.worker.PV -}}
    {{ default "ReadWriteOnce" .Values.worker.PV.accessModes }}
  {{- else -}}
    {{ default "ReadWriteOnce" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PV.mountPath" -}}
  {{- if .Values.worker.PV -}}
    {{ default "/home/asr-user/worker1-dir/models" .Values.worker.PV.mountPath }}
  {{- else -}}
    {{ default "/home/asr-user/worker1-dir/models" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PV.size" -}}
  {{- if .Values.worker.PV -}}
    {{ default "100Mi" .Values.worker.PV.size }}
  {{- else -}}
    {{ default "100Mi" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PV.key" -}}
  {{- if .Values.worker.PV -}}
    {{ default "kubernetes.io/hostname" .Values.worker.PV.key }}
  {{- else -}}
    {{ default "kubernetes.io/hostname" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PV.operator" -}}
  {{- if .Values.worker.PV -}}
    {{ default "In" .Values.worker.PV.operator }}
  {{- else -}}
    {{ default "In" }}
  {{- end -}}
{{- end -}}

{{- define "on-prem.worker.PV.nodeName" -}}
  {{- if .Values.worker.PV -}}
    {{ default "asr-serve000001" .Values.worker.PV.nodeName }}
  {{- else -}}
    {{ default "asr-serve000001" }}
  {{- end -}}
{{- end -}}
