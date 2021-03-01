#!/bin/bash

# SERVICE=vault-server-tls
SERVICE=vault-agent-injector-svc

# NAMESPACE where the Vault service is running.
NAMESPACE=vault

# SECRET_NAME to create in the Kubernetes secrets store.
SECRET_NAME=$1

# TMPDIR is a temporary working directory.
TMPDIR=$2

CSR_NAME=vault-agent-injector-csr

#clean up previous runs
rm ${TMPDIR}/* 
#sleep 5
kubectl delete csr ${CSR_NAME}
kubectl delete secret -n ${NAMESPACE} ${SECRET_NAME}

# Generate key for the certificate
openssl genrsa -out ${TMPDIR}/vault-injector.key 2048

# Create a file ${TMPDIR}/csr-vault-agent-injector.conf 
# with the following contents:

cat <<EOF >${TMPDIR}/csr-vault-agent-injector.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SERVICE}
DNS.2 = ${SERVICE}.${NAMESPACE}
DNS.3 = ${SERVICE}.${NAMESPACE}.svc
DNS.4 = ${SERVICE}.${NAMESPACE}.svc.cluster.local
IP.1 = 127.0.0.1
EOF

# Create a Certificate Signing Request (CSR).
openssl req -new -key ${TMPDIR}/vault-injector.key -subj "/CN=system:node:${SERVICE};/O=system:nodes" -out ${TMPDIR}/server-vault-agent-injector.csr -config ${TMPDIR}/csr-vault-agent-injector.conf

cat <<EOF >${TMPDIR}/agent-injector-csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${CSR_NAME}
spec:
  groups:
  - system:authenticated
  request: $(cat ${TMPDIR}/server-vault-agent-injector.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kubelet-serving
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

# Send the CSR to Kubernetes.
kubectl create -f ${TMPDIR}/agent-injector-csr.yaml

# Approve the CSR in Kubernetes
kubectl certificate approve ${CSR_NAME}

# Store key, cert, and Kubernetes CA into Kubernetes secrets store
# Retrieve the certificate.
serverCert=$(kubectl get csr ${CSR_NAME} -o jsonpath='{.status.certificate}')

# Write the certificate out to a file.
echo "${serverCert}" | openssl base64 -d -A -out ${TMPDIR}/vault-injector.crt

# Retrieve Kubernetes CA.
kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > ${TMPDIR}/vault-injector.ca

# for the helm chart we need to base64 encode the ca certificate 
# to fill the value injector.certs.caBundle you can run
# cat ${TMPDIR}/vault-injector.ca | base64

# Store the key, cert, and Kubernetes CA into Kubernetes secrets.
kubectl create secret generic ${SECRET_NAME} \
        --namespace ${NAMESPACE} \
        --from-file=vault-injector.key=${TMPDIR}/vault-injector.key \
        --from-file=vault-injector.crt=${TMPDIR}/vault-injector.crt \
        --from-file=vault-injector.ca=${TMPDIR}/vault-injector.ca
