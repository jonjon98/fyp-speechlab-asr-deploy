# Deploy Abax.AI Speech Services on on-prem cluster

## Deploy services (using manifest files) !have to be in this order, if anything fails just give it a while and try again
./deployment-on-prem.sh ingress-controller up
./deployment-on-prem.sh ingress-resource up
./deployment-on-prem.sh project up

## Removing services (using manifest files) !have to be in this order, if anything fails just give it a while and try again
./deployment-on-prem.sh ingress-controller down
./deployment-on-prem.sh ingress-resource down
./deployment-on-prem.sh project down