#! /bin/sh

eval $(minishift oc-env)
eval $(minishift docker-env)
docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
eval $(aws ecr get-login --no-include-email)

oc new-project redhatiot --display-name='Red Hat IoT'

docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-broker:5.0.0-128-rhel
docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-api:5.0.0-128-rhel
docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-console:5.0.0-128-rhel
docker pull 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-vpn:5.0.0-128-rhel 

docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-broker:5.0.0-128-rhel $(minishift openshift registry)/redhatiot/ec-broker:5.0.0
docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-api:5.0.0-128-rhel $(minishift openshift registry)/redhatiot/ec-api:5.0.0
docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-console:5.0.0-128-rhel $(minishift openshift registry)/redhatiot/ec-console:5.0.0
docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/eurotech/ec-vpn:5.0.0-128-rhel $(minishift openshift registry)/redhatiot/ec-vpn:5.0.0

# Yes, for some reason the login is lost and this is required a second time. Looking into this issue.
eval $(minishift docker-env)
docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
eval $(minishift oc-env)

docker push $(minishift openshift registry)/redhatiot/ec-broker
docker push $(minishift openshift registry)/redhatiot/ec-api
docker push $(minishift openshift registry)/redhatiot/ec-console
docker push $(minishift openshift registry)/redhatiot/ec-vpn
