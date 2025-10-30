{{/*
Expand the name of the chart.
*/}}
{{- define "valkey.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "valkey.fullname" -}}
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
{{- define "valkey.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "valkey.labels" -}}
helm.sh/chart: {{ include "valkey.chart" . }}
{{ include "valkey.selectorLabels" . }}
{{- if or .Values.image.tag .Chart.AppVersion }}
app.kubernetes.io/version: {{ mustRegexReplaceAllLiteral "@sha.*" .Values.image.tag "" | default .Chart.AppVersion | trunc 63 | trimSuffix "-" | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "valkey.selectorLabels" -}}
app.kubernetes.io/name: {{ include "valkey.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "valkey.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "valkey.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate deployment mode settings
Ensure replica count meets requirements for the selected mode
*/}}
{{- define "valkey.validateMode" -}}
{{- $replicaCount := .Values.replicaCount | int -}}
{{- if eq .Values.config.mode "sentinel" -}}
  {{- if lt $replicaCount 3 -}}
    {{- fail (printf "ERROR: Sentinel mode requires at least 3 replicas for high availability. Current replicaCount is %d. Please set replicaCount to at least 3." $replicaCount) -}}
  {{- end -}}
  {{- $quorum := .Values.sentinel.quorum | int -}}
  {{- if lt $quorum 2 -}}
    {{- fail (printf "ERROR: Sentinel quorum must be at least 2 for meaningful consensus. Current quorum is %d. Please set sentinel.quorum to at least 2." $quorum) -}}
  {{- end -}}
  {{- if gt $quorum $replicaCount -}}
    {{- fail (printf "ERROR: Sentinel quorum (%d) cannot exceed the number of replicas (%d). Quorum must be <= replicaCount. Please adjust sentinel.quorum or increase replicaCount." $quorum $replicaCount) -}}
  {{- end -}}
{{- else if eq .Values.config.mode "standalone" -}}
  {{- if lt $replicaCount 1 -}}
    {{- fail (printf "ERROR: Standalone mode requires at least 1 replica. Current replicaCount is %d. Please set replicaCount to at least 1." $replicaCount) -}}
  {{- end -}}
{{- else -}}
  {{- fail (printf "ERROR: Invalid deployment mode '%s'. Must be either 'sentinel' or 'standalone'." .Values.config.mode) -}}
{{- end -}}
{{- end -}}

{{/*
Validate authentication configuration
*/}}
{{- define "valkey.validateAuth" -}}
{{- if .Values.auth.enabled -}}
  {{- $hasSimplePassword := .Values.auth.acl.password -}}
  {{- $hasAdvancedPassword := or .Values.auth.acl.defaultUserPassword .Values.auth.acl.sentinelUserPassword -}}
  {{- $hasSecret := .Values.auth.acl.existingSecret -}}
  {{- $hasConfig := .Values.auth.acl.config -}}
  {{- if and (not $hasSimplePassword) (not $hasAdvancedPassword) (not $hasSecret) (not $hasConfig) -}}
    {{- fail "ERROR: When auth.enabled is true, you must provide either auth.acl.password, auth.acl.defaultUserPassword/sentinelUserPassword, auth.acl.existingSecret, or auth.acl.config." -}}
  {{- end -}}
  {{- if $hasSecret -}}
    {{- if not .Values.auth.acl.existingSecretDefaultUserKey -}}
      {{- fail "ERROR: When auth.acl.existingSecret is set, you must also provide auth.acl.existingSecretDefaultUserKey." -}}
    {{- end -}}
    {{- if not .Values.auth.acl.existingSecretSentinelUserKey -}}
      {{- fail "ERROR: When auth.acl.existingSecret is set, you must also provide auth.acl.existingSecretSentinelUserKey." -}}
    {{- end -}}
  {{- end -}}
  {{- if and (eq .Values.config.mode "sentinel") (not $hasSimplePassword) (not .Values.auth.acl.sentinelUserPassword) (not $hasSecret) (not $hasConfig) -}}
    {{- fail "ERROR: Sentinel mode with ACL authentication requires either auth.acl.password or auth.acl.sentinelUserPassword to be set for Sentinel to authenticate." -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Construct the image name with tag fallback to Chart.AppVersion
*/}}
{{- define "valkey.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end -}}
