{{ if .Values.enabled }}

{{ if .Values.clusterStores.enabled }}
{{ range .Values.clusterStores.stores }}
{{ if .accessSecret.reflectedSecret.enabled }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .accessSecret.secretName }}
  namespace: {{ $.Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"
    reflector.v1.k8s.emberstack.com/reflects: "{{ .accessSecret.reflectedSecret.originNamespace }}/{{ .accessSecret.reflectedSecret.originSecretName }}"
{{ end }}
{{ end }}
{{ end }}

{{ if .Values.scopedStores.enabled }}
{{ range .Values.scopedStores.stores }}
{{ if .accessSecret.reflectedSecret.enabled }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .accessSecret.secretName }}
  namespace: {{ $.Release.Namespace | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"
    reflector.v1.k8s.emberstack.com/reflects: "{{ .accessSecret.reflectedSecret.originNamespace }}/{{ .accessSecret.reflectedSecret.originSecretName }}"
{{ end }}
{{ end }}
{{ end }}

{{ end }}