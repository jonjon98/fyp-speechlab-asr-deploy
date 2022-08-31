# **Deploy Abax.AI Speech Services on on-prem cluster**

## **Kubernetes Manifest Deploy**
### Deploy services 
#### *(have to be in this order, if anything fails just give it a while and try again)*
    ./deployment-on-prem.sh ingress-controller up
    ./deployment-on-prem.sh ingress-resource up
    ./deployment-on-prem.sh project up

### Removing services 
#### *(have to be in this order, if anything fails just give it a while and try again)*
    ./deployment-on-prem.sh project down
    ./deployment-on-prem.sh ingress-resource down
    ./deployment-on-prem.sh ingress-controller down


## **Helm Chart Deploy**
### *To change the default values, do so in `charts/on-prem/values.yaml`*
### *arg and env values do not have a default attached to them so removing them would resulting in them being empty*
### Deploying services (using helm chart)
    ./deployment-on-prem.sh ingress-controller down
    helm install on-prem on-prem

### Removing services (using helm chart)
    helm install on-prem on-prem
    ./deployment-on-prem.sh ingress-controller down