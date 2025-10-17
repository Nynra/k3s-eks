{{- if .Values.enabled }}
{{- if .Values.networkPolicy.enabled }}
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: "{{ .Release.Name }}-network-policy"
  namespace: {{ .Release.Namespace | quote }}
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
  ingress:
    # Drop ingress traffic by default, allow only from within the namespace
    - from:
        - podSelector: {}
  egress:
    # Allow kubernetes DNS resolution
    - to:
        - namespaceSelector: {}
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - port: 53
          protocol: UDP
    # Allow all egress traffic within the namespace
    - to:
        - podSelector: {}
    # Allow HTTPS egress to specific IP (e.g., Vault server)
    {{ range .Values.networkPolicy.vaults }}
    - to:
        - ipBlock:
            cidr: {{ .ip }}
      ports:
        - port: {{ .port }}
    {{- end }}
{{- end }}
{{- end }}