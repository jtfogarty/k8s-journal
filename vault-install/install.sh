#!/bin/bash

SECRET_NAME=vault-server-tls

INJECTOR_SECRET_NAME=vault-agent-injector-tls

TMPDIR=/vault/userconfig/tls

mkdir -p ${TMPDIR}

git checkout ./vault-helm/values.yaml

./setup-v1.sh ${SECRET_NAME} ${TMPDIR}

./setup-v1-injector.sh ${INJECTOR_SECRET_NAME} ${TMPDIR}

INJECTOR_CA=$(cat ${TMPDIR}/vault-injector.ca | base64 | tr -d '\n')

sed -i "s/CA-BUNDLE-REPLACE-ME/${INJECTOR_CA}/" ./vault-helm/values.yaml

exit
# execute the below one at a time
helm install vault --namespace=vault ./vault-helm

# after the pod(s) are running execute the below
kubectl exec -it -n vault vault-0 -- /bin/sh
 > vault operator init
 > vault operator unseal

or 

kubectl exec -ti -n vault vault-0 -- vault operator init
kubectl exec -ti -n vault vault-0 -- vault operator unseal


