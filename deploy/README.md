# Deploy Abax.AI Speech Services

## Deploy infrastructure

  Go to `terraform/azure/environment/prd` and run commands:

    terraform init
    terraform plan -out prod.tfplan
    terraform apply prod.tfplan

  Get the infrastructure information

    terraform output 
    terraform output -out <sensitve_variable> # to show the password.


## Connect to the k8s cluster

### Connect to AKS cluster (Azure)

    az login
    az aks get-credentials --resource-group <resoureGroup> --name <aksCluster>

### Connect to EKS cluster (EKS)

    aws configure
    aws 


### Connect to GKE cluster (GCP)

    gcp cloud 


## Deploy services

### Livestream decoding

    kubectl create namespace  livestream-decoding
    kubectl config set-context --current --namespace=livestream-decoding

    kubectl apply -f deploy/git-k8s/speechlab-ghcr.yaml
    kubectl apply -f deploy/git-k8s/models-secrets.yaml

    kubectl apply -f deploy/public-az/online/online-decoding-pv.yaml
    kubectl apply -f deploy/public-az/online/online-decoding-secrets.yaml

    helm template online-decoding -f deploy/public-az/online/values.yaml charts/online-decoding --output-dir manifest/
    kubectl apply -f manifest/livestream-decoding/templates/


## Install Ingress and Certificate Managers

### Install nginx-ingress

    # Install the ingress-nginx from helm
    #########################################################
    
    kubectl create namespace ingress-nginx
    helm install ingress-nginx -n ingress-nginx \
                --set controller.replicaCount=2 \
                --set controller.service.type=LoadBalancer \
                ingress-nginx/ingress-nginx

    kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller


    # Archive for the fully private cluster on Azure
    #########################################################
    # Reference
    https://gaunacode.com/deploying-an-ingress-controller-to-an-internal-virtual-network-and-fronted-by-an-azure-application-gateway

    # Check the free IP address for the load balancer
    az network vnet check-ip-address --name spoke1-kubevnet -g prd_speechlab_aks --ip-address 10.0.5.200

    helm install nginx-ingress ingress-nginx/ingress-nginx \
      --namespace ingress-nginx \
      -f internal-ingress.yaml \
      --set controller.replicaCount=2 \
      --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
      --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
      --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux

    curl -L -H "Host: abax-task.speechlab.sg" http://10.0.5.130


### Install cert-manager (Lets Encrypt)

    # Create and apply the cert-manager
    kubectl create namespace cert-manager

    helm repo add jetstack https://charts.jetstack.io
    helm install \
        cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --create-namespace \
        --version v1.5.4 \
        --set installCRDs=true

### Apply ingress to expose services

    # mapping the host (set the size of the uploading files in ingress.yaml)
    kubectl apply -f deploy/git-k8s/prod_issuer.yaml
    kubectl apply -f deploy/git-k8s/online_ingress.yaml

    # Checking the cert is successfully installed.
    kubectl describe ingress <ingress_name>
    kubectl describe certificate <cert>
    kubectl describe clusterissuer <name>


## Monitoring and Logging

    # Reference links
    https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus
    https://github.com/kubernetes/kube-state-metrics
    https://grafana.com/docs/loki/latest/installation/helm/
    https://www.giantswarm.io/blog/grafana-logging-using-loki

    helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=true,prometheus.server.persistentVolume.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=default,loki.persistence.size=10Gi

    # Adding helm charts
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
    helm repo add grafana https://grafana.github.io/helm-charts

    # Update the repos
    helm repo update

    # Install loki, grafana stack
    helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false
    helm install grafana grafana/grafana


