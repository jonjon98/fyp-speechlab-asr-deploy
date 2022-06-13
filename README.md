# speechlab-asr-deploy




## Build applications

To build docker images of speech applications and add-ons

Check the `INSTALL.md` for more information


## Helm Charts
To package the application into helm charts (template and can render into manifest)

See in `charts/`

## Infrastructure Provisioning

Using Terraform to provision resource.

See in terraform/

## Deploy on Cloud [Production]

### Microsoft Azure (Fully private cluster)

  * Access the jumpbox (bastion host)
  * Connect to the private cluster
  * Deploy the services
 
### Microsoft Azure (Public endpoint)

  * Follow guide in `terraform/az/` to deploy the public production cluster.
  * Connect to the private cluster
  * Deploy the services

### Amazon AWS

  * Access the jumpbox (bastion host)
  * Connect to the private cluster
  * Deploy the services

### Google GCP

  * Access the jumpbox (bastion host)
  * Connect to the private cluster
  * Deploy the services

## Deploy on-premise (Data Center)

  * Connect to the private cluster
  * Deploy the services

## References


## Endpoints 
 

## Supports and Contact

Visit us at [TL Speechlab](https://temasek-labs.ntu.edu.sg/Research/KET/Pages/Speech-Recognition.aspx)

Contact [Ly](tlvu@ntu.edu.sg) or [Nga](ngaht@ntu.edu.sg) if you have any queries.

