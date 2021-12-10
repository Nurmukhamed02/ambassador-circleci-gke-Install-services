# Settings in CircleCI add cred

    1. GCLOUD_SERVICE_KEY

__GCLOUD_SERVICE_KEY__ we have to add credentials from GCP service account in .JSON format to the CircelCI Environment variable.
[Tutorial how to Add Context and Enviroment variable](https://www.youtube.com/watch?v=QBsgCvPQueA)


# Setting up the Google SDK
The first thing we see in the deploy_to_staging step is that we’re using the official Google Cloud SDK Docker image. This image contains the gcloud and nearly everything else we need to communicate with our container registry and Kubernetes cluster.

### The next thing we see is a few environment variables we need to set:
    
    - PROJECT_NAME: "my-app"
    - GOOGLE_PROJECT_ID: "xxx"
    - GOOGLE_COMPUTE_ZONE: "europe-west3-a"
    - GOOGLE_CLUSTER_NAME: "cluster-1"  


These are referenced later in the file when we describe the instance we want to connect to. The project name can be anything but keep in mind it’s used as the name of nearly all our resources (pods, deployment, images) — just take a look through __config.yml__ 

Speaking of yml files, you’ll notice that they contain template strings such as __{PROJECT_NAME}__ . While templating isn’t natively supported by CircleCI or Kubernetes, we can achieve the same objective by doing it ourselves. We’ll touch on this again in a few minutes but for now all you need to know is that we’re installing the gettext package which has a useful tool called __envsubst__:

    apt-get install -qq -y gettext

The next thing we do is take the contents of the __GCLOUD_SERVICE_KEY__ environment variable we set earlier and dump it into a __JSON__ file. We’ll then use the gcloud CLI to activate that service account using this file:

    echo $GCLOUD_SERVICE_KEY > ${HOME}/gcloud-service-key.json
    gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json 

Next, we make sure we’re using the correct project and zone (in case we have multiple) and most importantly we get the credentials needed to communicate with the Kubernetes cluster using kubectl . The get-credentials command will download and setup the necessary kubeconfig files:

    gcloud --quiet config set project ${GOOGLE_PROJECT_ID}
    gcloud --quiet config set compute/zone ${GOOGLE_COMPUTE_ZONE}
    gcloud --quiet container clusters get-credentials ${GOOGLE_CLUSTER_NAME}

# Install ambassador | cert-manager | external-dns | reloader
To install it we have to run command bellow. 
1. Firstly Using [envsubst](https://nickjanetakis.com/blog/using-envsubst-to-merge-environment-variables-into-config-files) to Merge Environment Variables into Config Files
2. Change file permission to run it 
3. Run it as a script

            envsubst < ${HOME}/project/ambassador.sh > ${HOME}/ambassador.sh
            chmod +x ambassador.sh
            bash ambassador.sh

            envsubst < ${HOME}/project/cert-manager.sh > ${HOME}/cert-manager.sh
            chmod +x cert-manager.sh
            bash cert-manager.sh

            envsubst < ${HOME}/project/external-dns.sh > ${HOME}/external-dns.sh
            chmod +x external-dns.sh
            bash external-dns.sh

            envsubst < ${HOME}/project/reloader.sh > ${HOME}/reloader.sh
            chmod +x reloader.sh
            bash reloader.sh


Sources below were used in this tutorial )







[Simplifying your CI/CD build pipeline to GKE with CircleCI orbs ](https://circleci.com/blog/getting-started-with-nestjs-and-automatic-testing/)

[CI/CD using CircleCI and Google Kubernetes Engine (GKE)](https://medium.com/@admm/ci-cd-using-circleci-and-google-kubernetes-engine-gke-7ed3a5ad57e)