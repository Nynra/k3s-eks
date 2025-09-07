{{- if .Values.enabled }}{{- if .Values.clusterStores.enabled }}
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
            name: {{ .accessSecretName | quote }}
            {{ if .accessTokenField }}
            key: {{ .accessTokenField | quote }}
            {{ else }}
            key: secret-id
            {{ end }}
            namespace: {{ $.Release.Namespace | quote }}
{{- end }}
{{- end }}
{{- end }}{{- end }}
