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

