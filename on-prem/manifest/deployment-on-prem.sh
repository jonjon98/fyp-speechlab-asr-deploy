#!/bin/bash

if [ "$1" = 'project' ]; then
    if [ "$2" = 'up' ]; then
        echo "Applying ASR project from K8s cluster"

        kubectl apply -f services/server.yaml
        kubectl apply -f deployments/server.yaml
        kubectl apply -f volumes/worker-storageclass.yaml
        kubectl apply -f volumes/worker-pv.yaml
        kubectl apply -f volumes/worker-pvc.yaml
        kubectl apply -f deployments/worker.yaml
    
    elif  [ "$2" = 'down' ]; then
        echo "Removing ASR project from K8s cluster"

        kubectl delete -f deployments/server.yaml
        kubectl delete -f services/server.yaml
        kubectl delete -f deployments/worker.yaml
        kubectl delete -f volumes/worker-pvc.yaml
        kubectl delete -f volumes/worker-pv.yaml
        kubectl delete -f volumes/worker-storageclass.yaml

    fi

elif  [ "$1" = 'ingress-controller' ]; then
    if [ "$2" = 'up' ]; then
        echo "Applying ASR Ingress Controller from K8s cluster"

        kubectl apply -f ingresses/nginx-controller.yaml

    elif  [ "$2" = 'down' ]; then
        echo "Removing ASR Ingress Controller from K8s cluster"

        kubectl delete -f ingresses/nginx-controller.yaml

    fi

elif  [ "$1" = 'ingress-resource' ]; then
    if [ "$2" = 'up' ]; then
        echo "Applying ASR Ingress Resource from K8s cluster"

        kubectl apply -f ingresses/server-resource.yaml

    elif  [ "$2" = 'down' ]; then
        echo "Removing ASR Ingress Resource from K8s cluster"

        kubectl delete -f ingresses/server-resource.yaml

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