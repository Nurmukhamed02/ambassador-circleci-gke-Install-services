#!/bin/bash
echo "------------------------------------EXTERNAL-DNS------------------------------------"
namespace=$(kubectl get ns | grep "external-dns" )
echo $namespace
if [[ -n $namespace  ]]
then
    echo "namespace external-dns already exists"
else
    kubectl create ns external-dns
fi

#####helm part####
output=$(helm version | grep "version.BuildInfo" )
if [[ -n $output ]]
then
    repo=$(helm repo list | grep bitnami)
else
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
fi

if [[ -n $repo  ]]
then
    echo "repo already exists"
else
    helm repo add bitnami https://charts.bitnami.com/bitnami
fi
chart=$(helm list --all-namespaces | grep "external-dns")
git clone https://github.com/nurizaesenbaeva/external-dns.git
cd external-dns
helm repo update
helm upgrade --install external-dns bitnami/external-dns \
-n external-dns \
-f values.yaml \
--version 3.2.6 \
--atomic \
--wait 

