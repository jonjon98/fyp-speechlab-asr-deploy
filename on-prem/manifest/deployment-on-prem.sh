#!/bin/bash

if [ "$1" = 'up' ]; then
    echo "Applying ASR project from K8s cluster"
    
    kubectl apply -f decoding-sdk-server-service.yaml
    kubectl apply -f decoding-sdk-server-deployment.yaml
    kubectl apply -f decoding-sdk-worker-storageclass.yaml
    kubectl apply -f decoding-sdk-worker-persistentvolume.yaml
    kubectl apply -f decoding-sdk-worker-claim0-persistentvolumeclaim.yaml
    kubectl apply -f decoding-sdk-worker-deployment.yaml

elif  [ "$1" = 'down' ]; then
    echo "Removing ASR project from K8s cluster"

    kubectl delete -f decoding-sdk-server-deployment.yaml
    kubectl delete -f decoding-sdk-server-service.yaml
    kubectl delete -f decoding-sdk-worker-deployment.yaml
    kubectl delete -f decoding-sdk-worker-claim0-persistentvolumeclaim.yaml
    kubectl delete -f decoding-sdk-worker-persistentvolume.yaml
    kubectl delete -f decoding-sdk-worker-storageclass.yaml

elif  [ "$1" = 'help' ]; then
    echo "Usage ./deployment-on-prem.sh <up/down/help>"
    echo "  up: applies ASR projec to K8s cluster"
    echo "  down: removes ASR project from K8s cluster"
    echo "  help: displays this menu"
    exit

else
    echo "Not a vaild flag"
    echo "Usage ./build.sh <up/down/scale/help>"
    exit

fi