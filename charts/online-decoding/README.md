# OnlineDecoder

OnlineDecoder project, is a speech to text system in batch mode. It receives the audio files, transcribing it and return transcriptions in different formats.

This chart bootstraps a SpeechToText deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.18+
- Helm 3+

## Get Repo Info

```console
helm repo add abax-speech <URL>
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
# Helm
$ helm install [RELEASE_NAME] abax-speech/online-decoding
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
# Helm
$ helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading Chart

```console
# Helm
$ helm upgrade [RELEASE_NAME] [CHART] --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._


## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
# Helm 2
$ helm inspect values abax-speech/online-decoding

# Helm 3
$ helm show values abax-speech/online-decoding
```

### RBAC Configuration

Roles and RoleBindings resources will be created automatically for `server` service.

To manually setup RBAC you need to set the parameter `rbac.create=false` and specify the service account to be used for each service by setting the parameters: `serviceAccounts.{{ component }}.create` to `false` and `serviceAccounts.{{ component }}.name` to the name of a pre-existing service account.

> **Tip**: You can refer to the default `*-clusterrole.yaml` and `*-clusterrolebinding.yaml` files in [templates](templates/) to customize your own.

### ConfigMap Files


### Ingress TLS

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [cert-manager](https://github.com/jetstack/cert-manager)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls onlinedecoder-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the online-decoding/master Ingress TLS section of your custom `values.yaml` file:


```yaml
server:
  ingress:
    ## If true, OnlineDecoder server Ingress will be created
    ##
    enabled: true

    ## OnlineDecoder server Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - livestream-decoding.domain.com

    ## OnlineDecoder server Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: onlinedecoder-tls
        hosts:
          - livestream-decoding.domain.com
```

### NetworkPolicy

Enabling Network Policy for OnlineDecoder will secure connections by only accepting connections from OnlineDecoder Server. All inbound connections to OnlineDecoder Server are still allowed.

To enable network policy for OnlineDecoder, install a networking plugin that implements the Kubernetes NetworkPolicy spec, and set `networkPolicy.enabled` to true.

If NetworkPolicy is enabled for OnlineDecoder' scrape targets, you may also need to manually create a networkpolicy which allows it.

