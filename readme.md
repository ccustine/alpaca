*WARNING: This project is WIP for collaboration on install steps, nothing to see here unless you have been directed here by me.*

# Configuration and Installation of Red Hat IoT Infrastructure
This document details the steps necessary to install and run the Red Hat IoT infrastructure. If you are installing on an existing Openshift
environment, skip the section titled "Minishift" as this is only necessary for a local development environment.

## Minishift

### Log in to AWS ECR
The following steps are necessary to retrieve the docker images. If you already have them pulled locally, you can skip this step.
1. `aws configure`  
Then add the Access Key ID, Secret Key, and us-east-1 as default region
2. `aws ecr get-login`  
Then cut off the "-e none" from the end of the command and copy the resulting ocmmand to clipboard
3. Paste the resulting command and run it
4. `aws ecr list-images --repository-name eurotech/ec-api` to verify docker is connected

### The following commands will create a minishift profile and configure the settings necessary to succesfully deploy the Red Hat IoT 
infrastructure for development, troubleshooting or demo purposes.  
Prerequisites: CDK 3.2, AWS CLI (For ECR command to retrieve Eurotech docker images).

```
$ minishift profile set redhat-iot
$ minishift addons enable registry-route
$ minishift addons enable anyuid
$ minishift addons disable xpaas
$ minishift config set insecure-registry 172.30.0.0/16
$ minishift config set memory 8GB
$ minishift config set cpus 4
$ minishift config set vm-driver xhyve
$ minishift start

# Only if nip.io is broken
$ minishift ip
$ minishift openshift config set --patch '{"routingConfig": {"subdomain": "[MINISHIFT IP].xip.io"}}'

# Only for origin and upstream minishift (not for CDK)
$ oc login -u system:admin
$ oc delete route docker-registry -n default
$ oc login $(minishift ip):8443 -u developer

$ eval $(minishift docker-env)
$ eval $(minishift oc-env)
$ docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
$ eval $(aws ecr get-login --no-include-email)
[Do docker pull commands above, this will pull directly to the minishift docker registry]
```

## Openshift
### Create project  
```
$ oc new-project alpaca
```

### Pull Eurotech Images
Run the following commands:  
```
$ docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-api:5.0.0-128-rhel
$ docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-console:5.0.0-128-rhel
$ docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-broker:5.0.0-128-rhel
$ docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-vpn:5.0.0-128-rhel  
```

### Tag the images to match openshift app and project
```
$ docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-console:5.0.0-128-rhel $(minishift openshift registry)/alpaca/ec-console:5.0.0
$ docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-broker:5.0.0-128-rhel $(minishift openshift registry)/alpaca/ec-broker:5.0.0
$ docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-vpn:5.0.0-128-rhel $(minishift openshift registry)/alpaca/ec-vpn:5.0.0
$ docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-api:5.0.0-128-rhel $(minishift openshift registry)/alpaca/ec-api:5.0.0
```

### Log in to OCP docker registry
```
$ docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
```

### Push the images
```
$ docker push $(minishift openshift registry)/alpaca/ec-api
$ docker push $(minishift openshift registry)/alpaca/ec-console
$ docker push $(minishift openshift registry)/alpaca/ec-vpn
$ docker push $(minishift openshift registry)/alpaca/ec-broker
```

### Start MariaDB
```
$ oc new-app -e MYSQL_USER=redhat -e MYSQL_PASSWORD=RedHat123 -e MYSQL_DATABASE=redhatiot -e MYSQL_LOWER_CASE_TABLE_NAMES=1 registry.access.redhat.com/rhscl/mariadb-101-rhel7 -n alpaca
```

### Create DB password secret
```
oc create secret generic ec-db --from-literal=name=ecdb --from-literal=username=redhat --from-literal=password=RedHat123 -n alpaca
```

### Create certs
```
$ oc create secret generic ec-crt --from-file=crt=cert.pem --from-file=key=key.pem --from-file=ca=ca.pem -n alpaca
```

### Start Elasticsearch 2.4
```
$ oc new-app -eES_HEAP_SIZE=256m -e "ES_JAVA_OPTS=-Des.cluster.name=kapua-datastore -Des.http.cors.enabled=true -Des.http.cors.allow-origin=*" elasticsearch:2.4 -n alpaca
```


### Start Eurotech Images


```
$ oc new-app -n alpaca -f broker.yml -p "IMAGE_VERSION=5.0.0" -p "NAMESPACE=redhatiot" -p "EC_SECRET_DB=ec-db" -p "DISABLE_SSL=true" -p STORAGE_HOST=172.30.33.69 -p STORAGE_PORT=9200 -p DB_HOST=172.30.172.64 -p DB_PORT=3306
$ oc new-app -n alpaca -f console.yml -p "IMAGE_VERSION=5.0.0" -p "NAMESPACE=redhatiot" -p "EC_SECRET_DB=ec-db" -p STORAGE_HOST=172.30.33.69 -p STORAGE_PORT=9200 -p DB_HOST=172.30.172.64 -p DB_PORT=3306
$ oc new-app -n alpaca -f api.yml -p "IMAGE_VERSION=5.0.0" -p "NAMESPACE=redhatiot" -p "EC_SECRET_DB=ec-db" -p STORAGE_HOST=172.30.33.69 -p STORAGE_PORT=9200 -p DB_HOST=172.30.172.64 -p DB_PORT=3306
```




# Everything below here is obsolete or unused, saving for context

## Save Images to external files (and copy to USB stick, etc.)
Save to local directory (or directly to USB)  
```
$ docker save 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-api > ec-api.tar
$ docker save 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-console > ec-console.tar
$ docker save 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-broker > ec-broker.tar
$ docker save 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-vpn > ec-vpn.tar
```

## Load Images from USB
```
$ docker load < ec-api.tar
$ docker load < ec-broker.tar
$ docker load < ec-console.tar
$ docker load < ec-vpn.tar
```
