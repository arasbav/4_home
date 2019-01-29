#!/bin/bash

ZONE='europe-west1-b'

gce_zone(){
    gcloud config set compute/zone $1
}

gce_zone $ZONE

echo "delete k8s cluester"
gcloud container clusters delete "gke-mongodb-personio-api-cluster"

echo "deete disks"
for i in 1 2 3; do
  gcloud compute disks delete pd-hdd-disk-${i} \
  --zone europe-west1-b 
done
