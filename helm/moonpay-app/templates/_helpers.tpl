{{- define "moonpay-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "moonpay-app.fullname" -}}
{{- if .Values.pr.enabled }}
{{- printf "%s-pr-%s" (include "moonpay-app.name" .) (.Values.pr.number | toString) | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "moonpay-app.name" . | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "moonpay-app.selectorLabels" -}}
app: moonpay
{{- if .Values.pr.enabled }}
pr: {{ .Values.pr.number | toString | quote }}
{{- end }}
{{- end }}

{{- define "moonpay-app.labels" -}}
{{ include "moonpay-app.selectorLabels" . }}
app.kubernetes.io/name: {{ include "moonpay-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
