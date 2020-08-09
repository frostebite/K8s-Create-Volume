#!/bin/sh -l

mkdir -p ~/.kube
echo $1 | base64 -d > ~/.kube/config
echo "Applied kubeConfig"

kubectl version

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $2
spec: 
 accessModes: 
  - ReadWriteOnce
 volumeMode: "Filesystem"
 resources: 
  requests: 
   storage: $3
EOF

sleep 5
kubectl wait --for=status=Bound pvc -l name=$2 --timeout=35s
