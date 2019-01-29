#!/bin/bash

ZONE=$1
NAMESPACE=$2

echo $ZONE
echo "set zone"
gcloud config set compute/zone $ZONE

echo "Creating certificates and keys"
echo "create first key"
openssl genrsa -out $NAMESPACE-ingress-1.key 2048

echo "first certificate signing request"
openssl req -new -key $NAMESPACE-ingress-1.key -out $NAMESPACE-ingress-1.csr \
    -subj "/CN=personio.de"

echo "create  first certificate"
openssl x509 -req -days 365 -in $NAMESPACE-ingress-1.csr -signkey $NAMESPACE-ingress-1.key \
    -out $NAMESPACE-ingress-1.crt

echo "Create a Secret that holds certificate and key:"
kubectl -n $NAMESPACE create secret tls my-first-secret \
  --cert $NAMESPACE-ingress-1.crt --key $NAMESPACE-ingress-1.key 

rm -f $NAMESPACE-ingress-1.crt
rm -f $NAMESPACE-ingress-1.csr
rm -f $NAMESPACE-ingress-1.key
