#!/bin/bash
echo "------------------------------------AMBASSADOR------------------------------------"
namespace=$(kubectl get ns | grep "ambassador" )
echo $namespace
if [[ -n $namespace  ]]
then
    echo "namespace ambassador already exists"
else
    kubectl create ns ambassador
fi

#####helm part####
output=$(helm version | grep "version.BuildInfo" )
if [[ -n $output ]]
then
    repo=$(helm repo list | grep datawire)
else
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
fi

if [[ -n $repo  ]]
then
    echo "repo  already exists"
else
    helm repo add datawire https://www.getambassador.io 
fi
kubectl apply -f https://www.getambassador.io/yaml/aes-crds.yaml 
git clone https://github.com/nurizaesenbaeva/ambassador.git
cd ambassador
helm repo update
helm upgrade --install aes1 datawire/ambassador -n ambassador \
-f values.yaml \
--atomic \
--waith 