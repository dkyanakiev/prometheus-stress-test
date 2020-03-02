# Prerequisites 

1. [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
    - The cli that will be used to work with any of the K8s clusters
2. [Gcloud sdk](https://cloud.google.com/sdk/install)
    - The cli that will be used to work with Google Cloud in order to provision and delete resources
3. [Helm](https://helm.sh/docs/intro/install/)
    - Allows us to automate and better control our kubernetes resources. Helms allows you to define a custom application as a resource and it will manage all the subcomponents for you.

## Overview

Deployment and configuration is done via Helm.
The reason for the decoupled configuration/charts is to have better control over each component. 
The full stack chart for `Loki + Grafana + Prometheus + Promtail` is really restricted in terms of configurations, like importing custom dashboards during provisioning.
`cAdvisor` is used to expose some additional metrics for container resource usage.

## Managing the GKE cluster
`./cluster.sh <cluster-name> <project-name>` - To build,delete or get credentials for your cluster 
    - `cluster-name` - Name you want to give to the new GKE cluster
    - `project-name` - Name of the google project you wish to assign the GKE cluster
Example: 
`./cluster.sh test-cluster-demo automation-test-demo`

Options : build / delete / creds

`build` - builds your cluster with predefined settings
`delete` - deletes your cluster 
`creds` - configures your kubectl config in order to use the cluster

## Deploying the monitoring components

Once you you have finished building your cluster and gotten your credntials using the `./cluster.sh` script. 
Simply run `./deploy.sh` in order to deploy all the components

## Accessing Grafana
Two things are needed to access grafana:
1. Credentials 
Username is `admin`
Password: In order to get the password run `kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo` in the terminal
2. This basic setup and configuration does not have an ingress so in order to access it from your machine you would have to expose the service:
`kubectl port-forward svc/grafana 8000:80`
Once you have the port-forwarding in place you can navigate to `http://localhost:8000` and login

## Complete setup example 

1. `./cluster.sh test-cluster-demo automation-test-demo` - select `build`, wait for it to complete
2. `./cluster.sh test-cluster-demo automation-test-demo` - select `creds`, wait for it to complete
3. `./deploy.sh` - To build your resources
4. `kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo` - to get login credentials 
5. `kubectl port-forward svc/grafana 8000:80` - To expose the service 
    Note: If you are unable to expose the service due to pod being in a Pending state, please wait a few minutes and retry.
6. `http://localhost:8000`  