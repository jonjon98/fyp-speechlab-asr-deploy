{{/*
Expand the name of the chart.
*/}}
{{- define "on-prem.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

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
  {{ default "lyvt/decoding-sdk" .Values.server.image.repository }}
{{- end -}}

{{- define "on-prem.server.image.tag" -}}
  {{ default .Chart.AppVersion .Values.server.image.tag }}
{{- end -}}

{{- define "on-prem.server.image.pullPolicy" -}}
  {{ default "Always" .Values.server.image.pullPolicy }}
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
  {{ default 8010 .Values.server.service.ports.name | quote }}
{{- end -}}

{{- define "on-prem.server.service.ports.servicePort" -}}
  {{ default 8010 .Values.server.service.ports.servicePort }}
{{- end -}}

{{- define "on-prem.server.service.ports.targetPort" -}}
  {{ default 8010 .Values.server.service.ports.targetPort }}
{{- end -}}

# Server services status
{{- define "on-prem.server.service.status.loadBalancer" -}}
  {{ default "{}" .Values.server.service.status.loadBalancer }}
{{- end -}}

### Define server deployment ingress resource ###
{{- define "on-prem.server.ingress.resource.name" -}}
  {{ template "on-prem.name" . }}-server-ingress-resource
{{- end -}}

{{- define "on-prem.server.ingressResource.ingressClassName" -}}
  {{ default "nginx" .Values.server.ingressResource.ingressClassName }}
{{- end -}}

{{- define "on-prem.server.ingressResource.host" -}}
  {{ default "asr-project.com" .Values.server.ingressResource.host }}
{{- end -}}

{{- define "on-prem.server.ingressResource.path" -}}
  {{ default "/" .Values.server.ingressResource.path }}
{{- end -}}

{{- define "on-prem.server.ingressResource.pathType" -}}
  {{ default "Prefix" .Values.server.ingressResource.pathType }}
{{- end -}}

{{- define "on-prem.server.ingressResource.port" -}}
  {{ default 8010 .Values.server.ingressResource.port }}
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
  {{ default "lyvt/decoding-sdk" .Values.worker.image.repository }}
{{- end -}}

{{- define "on-prem.worker.image.tag" -}}
  {{ default .Chart.AppVersion .Values.worker.image.tag }}
{{- end -}}

{{- define "on-prem.worker.image.pullPolicy" -}}
  {{ default "Always" .Values.worker.image.pullPolicy }}
{{- end -}}

# Worker specs
{{- define "on-prem.worker.replicaCount" -}}
  {{ default 1 .Values.worker.replicaCount }}
{{- end -}}

{{- define "on-prem.worker.strategy.type" -}}
  {{ default "Recreate" .Values.worker.strategy.type }}
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
    {{ default "/opt/models/" .Values.worker.volumeMount.mountPath }}
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
  {{ default "kubernetes.io/no-provisioner" .Values.worker.storageClass.provisioner }}
{{- end -}}

{{- define "on-prem.worker.storageClass.volumeBindingMode" -}}
  {{ default "WaitForFirstConsumer" .Values.worker.storageClass.volumeBindingMode }}
{{- end -}}

# Worker PVC
{{- define "on-prem.worker.pvc.name" -}}
  {{ template "on-prem.name" . }}-worker-pvc
{{- end -}}

{{- define "on-prem.worker.PVC.accessModes" -}}
  {{ default "ReadWriteOnce" .Values.worker.PVC.accessModes }}
{{- end -}}

{{- define "on-prem.worker.PVC.size" -}}
  {{ default "100Mi" .Values.worker.PVC.size }}
{{- end -}}

{{- define "on-prem.worker.PVC.status" -}}
  {{ default "{}" .Values.worker.PVC.status }}
{{- end -}}

# Worker PV
{{- define "on-prem.worker.pv.name" -}}
  {{ template "on-prem.name" . }}-worker-pv
{{- end -}}

{{- define "on-prem.worker.PV.accessModes" -}}
  {{ default "ReadWriteOnce" .Values.worker.PV.accessModes }}
{{- end -}}

{{- define "on-prem.worker.PV.mountPath" -}}
  {{ default "/home/asr-user/worker1-dir/models" .Values.worker.PV.mountPath }}
{{- end -}}

{{- define "on-prem.worker.PV.size" -}}
  {{ default "100Mi" .Values.worker.PV.size }}
{{- end -}}

{{- define "on-prem.worker.PV.key" -}}
  {{ default "kubernetes.io/hostname" .Values.worker.PV.key }}
{{- end -}}

{{- define "on-prem.worker.PV.operator" -}}
  {{ default "In" .Values.worker.PV.operator }}
{{- end -}}

{{- define "on-prem.worker.PV.nodeName" -}}
  {{ default "asr-serve000001" .Values.worker.PV.nodeName }}
{{- end -}}
