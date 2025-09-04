# k3s-eks

```bash
export OP_CONNECT_TOKEN="your_connect_token"
kubectl create secret -n external-secrets generic main-connect-token --from-literal=token=$OP_CONNECT_TOKEN
```
