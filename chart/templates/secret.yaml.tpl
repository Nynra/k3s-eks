{{- if .Values.enabled }}{{- if .Values.externalSecrets.enabled }}
{{- range .Values.externalSecrets.secrets }}
{{- if .enabled }}
{{- $remoteSecretName := .remoteName }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .name }}
  namespace: {{ $.Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  refreshInterval: {{ .refreshInterval | default "1h" | quote }}
  secretStoreRef:
    kind: {{ .storeType | default "SecretStore" | quote }}
    name: {{ .storeName | quote }}
  {{ if $.Values.allowReflection }}{{ if .reflection }}
  {{ if .reflection.enabled }}
  target:
    creationPolicy: Owner
    template:
      engineVersion: v2
      metadata:
        annotations:
          reflector.v1.k8s.emberstack.com/reflection-allowed: {{ .reflection.enabled | quote }}
          reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces: {{ .reflection.allowedNamespaces | quote }}
          reflector.v1.k8s.emberstack.com/reflection-auto-enabled: {{ .reflection.allowAutoReflection | quote }}
          reflector.v1.k8s.emberstack.com/reflection-auto-namespaces: {{ .reflection.autoReflectionNamespaces | quote }}
  {{ end }}
  {{ end }}{{ end }}
  data:
    {{- range .fieldMappings}}
    - secretKey: {{ .secretKey | quote }}
      remoteRef:
        key: {{ $remoteSecretName | quote }}
        {{- if .remoteField }}
        property: {{ .remoteField | quote }}
        {{- end }}
        decodingStrategy: None
        metadataPolicy: Fetch
    {{- end }}
---
{{- end }}
{{- end }}
{{- end }}{{- end }}