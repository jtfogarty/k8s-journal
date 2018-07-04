
## Overview
When building cloud native applications, it seem silly to develop in a non-cloud environment.  The point of Jenkins-x (jx) is to provide an easy way to develop in the cloud. The only setup we will discuss is on Google (gke). With this being said there are 2 componenets needed for jx to interact with gke. 

1) gcloud - [Install Instructions](https://cloud.google.com/sdk/docs/quickstart-macos)
    - tl;dr
        1) login to google cloud
        2) install gcloud
        3) initalize gcloud
        4) set project id
        5) get credentials
    
    Reading
    - [introduction](https://medium.com/google-cloud/introduction-to-g-cloud-command-line-tool-f10834789b73)
2) kubectl - [Install Instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
    - tl;dr 
        1) brew install kubernetes-cli

### Installing Jenkins-x
1) brew tap jenkins-x/jx
2) brew install jx
3) jx init

### Creating a cluster with Jenkins-x
- [jenkins-x.io doc](https://jenkins-x.io/getting-started/create-cluster/#using-google-cloud-gke)