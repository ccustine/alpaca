#! /bin/sh

minishift setup-cdk
minishift profile set redhat-iot
minishift addons enable registry-route
minishift addons enable anyuid
minishift addons disable xpaas
minishift config set insecure-registry 172.30.0.0/16
# There is a problem with CDK 3.2 somewhere. Naming a specific version tag
# creates an Openshift where you can't push images directly to the local docker registry.
# For now we must stick with the default which is 3.6.x
# minishift config set ocp-tag v3.5.5.31.48
minishift config set memory 8GB
minishift config set cpus 4
minishift config set vm-driver xhyve
minishift start
