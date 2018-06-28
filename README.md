# Notes on configuring GKE

## Create a new Cluster
### kubectl

### jenkins-x


## Connect a new workstation to an existing cluster
### tl;dr
1) login to google cloud
2) install gcloud on the new workstation
3) Initalize gcloud
4) set project id
5) get credentials

### Install gcloud from source - OS X
```
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-206.0.0-darwin-x86_64.tar.gz .
tar -xzvf google-cloud-sdk-206.0.0-darwin-x86_64.tar.gz
cd google-cloud-sdk
./install.sh
gcloud -h
```
### Initialize gcloud
You must login to Google Cloud using the `gcloud init` command. The --console-only bypasses the default web browser login.
```
gcloud init --console-only
```
Its a good idea to set the project.  The only way I know to get the project id is from the google console (i.e. website.)
```
gcloud config set project [PROJECT ID]
```
In order to use `kubectl` you must execute the below credentials command with the proper cluster name and zone
```
gcloud container clusters get-credentials [CLUSTERNAME] --zone=[ZONE]
```
### kubectl
`kubectl get pods --all-namespaces` should now return all pods in the cluster
