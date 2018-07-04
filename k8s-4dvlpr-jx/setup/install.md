
## Overview
When building cloud native applications, it seem silly to develop in a non-cloud environment.  The point of Jenkins-x (jx) is to provide an easy way to develop in the cloud. The only setup we will discuss is on Google (gke). With this being said there are 2 componenets needed for jx to interact with gke. 

1) gcloud
2) kubectl


### Installing jenkins-x on workstation
1) brew tap jenkins-x/jx
2) brew install jx
3) jx init