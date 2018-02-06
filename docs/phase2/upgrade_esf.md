# Upgrade ESF

1. Download latest esf-5.2_1.tar (in email instructions)
2. ```docker load < esf-5.2_1.tar```
3. ```docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/pub/redhat/esf:5.2.0-SNAPSHOT-RHEL-x86-64-bootd $(oc get route docker-registry -n default --template='{{.spec.host}}')/alpaca/esf:5.2.0-RHEL```
4. ```docker push $(oc get route docker-registry -n default --template='{{.spec.host}}')/alpaca/esf:5.2.0-RHEL```
5. ```oc get pods -w``` Verify that the previous pod completes and a new one deploys