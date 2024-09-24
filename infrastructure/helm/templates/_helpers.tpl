{{- define "sales-api.labels" -}}
app.kubernetes.io/name: {{ include "sales-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: {{ .Values.env | default "application" }}
{{- end -}}

{{- define "sales-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sales-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "sales-api.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "sales-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{ .Values.fullnameOverride }}
{{- else }}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}
{{- end -}}

{{- define "sales-api.chart" -}}
{{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}
