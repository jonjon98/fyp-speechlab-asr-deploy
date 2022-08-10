#!/bin/bash

if [ "$1" = 'project' ]; then
    if [ "$2" = 'up' ]; then
        echo "Applying ASR project from K8s cluster"

        kubectl apply -f services/decoding-sdk-server-service.yaml
        kubectl apply -f deployments/decoding-sdk-server-deployment.yaml
        kubectl apply -f volumes/decoding-sdk-worker-storageclass.yaml
        kubectl apply -f volumes/decoding-sdk-worker-persistentvolume.yaml
        kubectl apply -f volumes/decoding-sdk-worker-claim0-persistentvolumeclaim.yaml
        kubectl apply -f deployments/decoding-sdk-worker-deployment.yaml
    
    elif  [ "$2" = 'down' ]; then
        echo "Removing ASR project from K8s cluster"

        kubectl delete -f deployments/decoding-sdk-server-deployment.yaml
        kubectl delete -f services/decoding-sdk-server-service.yaml
        kubectl delete -f deployments/decoding-sdk-worker-deployment.yaml
        kubectl delete -f volumes/decoding-sdk-worker-claim0-persistentvolumeclaim.yaml
        kubectl delete -f volumes/decoding-sdk-worker-persistentvolume.yaml
        kubectl delete -f volumes/decoding-sdk-worker-storageclass.yaml

    fi

elif  [ "$1" = 'ingress-controller' ]; then
    if [ "$2" = 'up' ]; then
        echo "Applying ASR Ingress Controller from K8s cluster"

        kubectl apply -f ingress/ingress-nginx-controller.yaml

    elif  [ "$2" = 'down' ]; then
        echo "Removing ASR Ingress Controller from K8s cluster"

        kubectl delete -f ingress/ingress-nginx-controller.yaml

    fi

elif  [ "$1" = 'ingress-resource' ]; then
    if [ "$2" = 'up' ]; then
        echo "Applying ASR Ingress Resource from K8s cluster"

        kubectl apply -f ingress/decoding-sdk-server-ingress.yaml

    elif  [ "$2" = 'down' ]; then
        echo "Removing ASR Ingress Resource from K8s cluster"

        kubectl delete -f ingress/decoding-sdk-server-ingress.yaml

    fi

elif  [ "$1" = 'help' ]; then
    echo "Usage ./deployment-on-prem.sh [project/ingress-controller/ingress-resource/help] [up/down]"
    echo "  project: project component"
    echo "  ingress-controller: ingress-controller component"
    echo "  ingress-resource: ingress-resource component"
    echo "  help: displays this menu"
    echo "  up: deploys component to K8s cluster (only applies to components)"
    echo "  down: removes component from K8s cluster (only applies to components)"
    exit

else
    echo "Not a vaild flag"
    echo "Usage ./deployment-on-prem.sh [project/ingress-controller/ingress-resource/help] [up/down]"
    exit

fi