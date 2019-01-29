#!/bin/bash

ZONE=$1
echo "set zone"
gcloud config set compute/zone $ZONE 

echo "create Service account for Titter"
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

echo "get HELM"
curl -o get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
chmod +x get_helm.sh
./get_helm.sh

chmod "remove installer"
rm -f get_helm.sh

echo "Helm init"
helm init --service-account tiller
kubectl get deployments -n kube-system

echo
echo "---------------------------------------------------"
echo "Wait 20 seconds"
sleep 20
echo "Deploy NGINX Ingress Controller"
helm install --name nginx-ingress stable/nginx-ingress
echo
echo "Wait 10 seconds"
sleep 10
kubectl get service nginx-ingress-controller



