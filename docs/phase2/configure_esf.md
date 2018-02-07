# Configure Cloud Services in ESF
1. Log in to ESF Console (credentials sent via email)
2. Click "Cloud Services" in left side menu.
3. Under "DataService" tab, change connect.auto-on-startup to true then "Apply".
4. Under "MqttDataService", change the following values:
    broker-url = mqtt://ec-broker-mqtt.alpaca.svc:1883/
    topic.context.account-name = <Child Account Name created in EC>
    username = <gateway username created in EC>
    password = <password from EC>
5. Click "Apply"
6. Click "Connect"
7. Click on the "!Status" at top of left side menu and verify "Service Status" shows CONNECTED.
