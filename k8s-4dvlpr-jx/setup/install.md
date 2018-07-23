
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

Set Variables
```
CLUSTER_NAME=
ADMIN_PW=
API_TOKEN=
GIT_USER=
PROJECT_ID=
GKE_USER=
```
```
jx create cluster gke \
--batch-mode=true \
--cluster-name ${CLUSTER_NAME} \
--default-admin-password ${ADMIN_PW} \
--domain docure.cc \
--git-api-token ${API_TOKEN} \
--git-provider-url github.com \
--git-username ${GIT_USER} \
--machine-type n1-standard-2 \
--max-num-nodes 5 \
--min-num-nodes 3 \
--no-default-environments \         # the Stage and Production environments will NOT be created nor will the git repos
--project-id ${PROJECT_ID} \
--skip-login \
--username ${GKE_USER} \
--verbose \
--zone us-central1-c
```


### What if you already have GitHub repos that you want to include into your jx cluster?
1) Use the above jx create
2) jx import
3) Then do the below to create the stating and production environments


### To create the environments after the cluster is created, excute the below; 

[Developing Git](https://jenkins-x.io/developing/git/)

```
jx create git server 
jx create token
jx create env
```

### Delete steps

```
jx uninstall --batch-mode -y
helm list --all --short | xargs -L1 helm delete --purge
helm reset
```