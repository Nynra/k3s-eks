{{- if .Values.enabled }}{{- if .Values.scopedStores.enabled }}
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
        tokenSecretRef:
          name: {{ .accessToken.secretName | quote }}
          {{- if .accessTokenField }}
          key: {{ .accessTokenField | quote }}
          {{- else }}
          key: token
          {{- end }}
{{- end }}
{{- end }}{{- end }}
