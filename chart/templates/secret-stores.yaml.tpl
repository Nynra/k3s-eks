{{- if .Values.enabled }}
{{- if .Values.clusterStores.enabled }}
{{- range .Values.clusterStores.stores }}
{{- if .enabled }}
---
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: {{ .name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  provider:
    vault:
      server: {{ .server | quote }}
      path: {{ .path | quote }}
      version: "v2"
      auth:
        appRole:
          path: {{ .appRolePath | default "approle" | quote }}
          roleId: {{ .roleId | quote }}
          secretRef:
            name: {{ .accessSecret.secretName | quote }}
            {{ if .accessSecret.tokenField }}
            key: {{ .accessSecret.tokenField | quote }}
            {{ else }}
            key: secret-id
            {{ end }}
            namespace: {{ $.Release.Namespace | quote }}
{{- end }}
{{- end }}
{{- end }}

{{- if .Values.scopedStores.enabled }}
{{- range .Values.scopedStores.stores }}
{{- if .enabled }}
---
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: {{ .name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  provider:
    vault:
      server: {{ .server | quote }}
      path: {{ .path | quote }}
      version: "v2"
      auth:
        appRole:
          path: {{ .appRolePath | default "approle" | quote }}
          roleId: {{ .roleId | quote }}
          secretRef:
            name: {{ .accessSecret.secretName | quote }}
            {{- if .accessSecret.tokenField }}
            key: {{ .accessSecret.tokenField | quote }}
            {{- else }}
            key: secret-id
            {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- end }}
