## From Private Docker Registry

TODO

## From External File
1. ```docker load < esf-5.2.tar```
2. ```docker tag docker-registry-default.apps.iiot-demo.rhiot.org/redhat-iot/esf:5.2.0-RHEL <integrated registry url>/alpaca/esf:5.2.0-RHEL```
3. ```docker push <integrated registry url>/alpaca/esf:5.2.0-RHEL```
4. ```oc new-app esf:5.2.0-RHEL -n alpaca```
5. ```oc expose svc/esf```
6. ```oc status``` and then open the url for the esf-alpaca service on port 80.
7. Default login is admin/admin
