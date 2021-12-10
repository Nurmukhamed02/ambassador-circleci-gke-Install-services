# Setting up the Google SDK
The first thing we see in the deploy_to_staging step is that we’re using the official Google Cloud SDK Docker image. This image contains the gcloud and nearly everything else we need to communicate with our container registry and Kubernetes cluster.

### The next thing we see is a few environment variables we need to set:
    
    - PROJECT_NAME: "my-app"
    - GOOGLE_PROJECT_ID: "xxx"
    - GOOGLE_COMPUTE_ZONE: "europe-west3-a"
    - GOOGLE_CLUSTER_NAME: "cluster-1"  


These are referenced later in the file when we describe the instance we want to connect to. The project name can be anything but keep in mind it’s used as the name of nearly all our resources (pods, deployment, images) — just take a look through config.yml and k8s.yml to see where it’s referenced.

Speaking of yml files, you’ll notice that they contain template strings such as {PROJECT_NAME} . While templating isn’t natively supported by CircleCI or Kubernetes, we can achieve the same objective by doing it ourselves. We’ll touch on this again in a few minutes but for now all you need to know is that we’re installing the gettext package which has a useful tool called envsubst:

    apt-get install -qq -y gettext

The next thing we do is take the contents of the GCLOUD_SERVICE_KEY environment variable we set earlier and dump it into a JSON file. We’ll then use the gcloud CLI to activate that service account using this file:

    echo $GCLOUD_SERVICE_KEY > ${HOME}/gcloud-service-key.json
    gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json 

Next, we make sure we’re using the correct project and zone (in case we have multiple) and most importantly we get the credentials needed to communicate with the Kubernetes cluster using kubectl . The get-credentials command will download and setup the necessary kubeconfig files:

    gcloud --quiet config set project ${GOOGLE_PROJECT_ID}
    gcloud --quiet config set compute/zone ${GOOGLE_COMPUTE_ZONE}
    gcloud --quiet container clusters get-credentials ${GOOGLE_CLUSTER_NAME}

[Simplifying your CI/CD build pipeline to GKE with CircleCI orbs ](https://circleci.com/blog/getting-started-with-nestjs-and-automatic-testing/)

[CI/CD using CircleCI and Google Kubernetes Engine (GKE)](https://medium.com/@admm/ci-cd-using-circleci-and-google-kubernetes-engine-gke-7ed3a5ad57e)