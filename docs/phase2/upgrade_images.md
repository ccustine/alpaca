# Upgrade Elasticsearch

1. ```oc set env dc/elasticsearch ES_HEAP_SIZE-```
2. ```oc set env dc/elasticsearch ES_JAVA_OPTS='-Des.cluster.name=kapua-datastore -Des.http.cors.enabled=true -Des.http.cors.allow-origin=* -Xms256m -Xmx256m'```
3. ```oc set triggers dc/elasticsearch --from-image=elasticsearch:5.4 --containers=elasticsearch```
4. ```docker pull elasticsearch:5.4```
5. ```docker save -o elasticsearch54.tar elasticsearch:5.4```
6. ```docker load < elasticsearch54.tar```
7. ```docker tag elasticsearch:5.4 $(oc get route docker-registry -n default --template='{{.spec.host}}')/alpaca/elasticsearch:5.4```
8. ```oc get pods -w``` Verify the elasticsearch pod redeploys

# Upgrade ESF

1. Download latest esf-5.2_1.tar (in email instructions)
2. ```docker load < esf-5.2_1.tar```
3. ```docker tag 327816968817.dkr.ecr.us-east-1.amazonaws.com/pub/redhat/esf:5.2.0-SNAPSHOT-RHEL-x86-64-bootd $(oc get route docker-registry -n default --template='{{.spec.host}}')/alpaca/esf:5.2.0-RHEL```
4. ```docker push $(oc get route docker-registry -n default --template='{{.spec.host}}')/alpaca/esf:5.2.0-RHEL```
5. ```oc get pods -w``` Verify that the previous pod completes and a new one deploys