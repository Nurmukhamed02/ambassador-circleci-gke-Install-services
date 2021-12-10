#!/bin/bash
echo "------------------------------------CERT-MANAGER------------------------------------"
namespace=$(kubectl get ns | grep "cert-manager" )
echo $namespace
if [[ -n $namespace  ]]
then
    echo "namespace cert-manager already exists"
else
    kubectl create ns cert-manager
fi

#####helm part####
output=$(helm version | grep "version.BuildInfo" )
if [[ -n $output ]]
then
    repo=$(helm repo list | grep jetstack)
else
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
fi

if [[ -n $repo  ]]
then
    echo "repo already exists"
else
    helm repo add jetstack https://charts.jetstack.io 
fi
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.1/cert-manager.crds.yaml
git clone https://github.com/nurizaesenbaeva/cert-manager.git
cd cert-manager
helm repo update 
helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager \
-f values.yaml \
--version v0.16.1 \
--debug \
--atomic \
--wait 

