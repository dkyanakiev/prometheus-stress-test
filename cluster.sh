#!/bin/bash
 
read -p "Enter operation build/delete/creds : " oper
 
if [ $oper = "build" ]
then
    gcloud container clusters create $1 --no-enable-cloud-monitoring --zone europe-west1-c --disk-size=50gb --disk-type=pd-standard --machine-type=e2-standard-2 --num-nodes=2 --project $2
elif [ $oper = "delete" ]
then
    gcloud container clusters delete $1 --zone europe-west1-c --project $2
elif [ $oper = "creds" ]
then
    gcloud container clusters get-credentials $1 --zone europe-west1-c --project $2
fi
