# Install MTConnect Component in ESF
1. Locate the mtConnect_0.1.0.dp package file and download locally.
2. In ESF, click "Packages" from left side menu.
3. Click "Install/Upgrade", then "Choose File" and select the mtConnect_0.1.0.dp package from the local download location. Then "Submit".
4. Verify that "mtConnect 0.1.0" shows up in the installed package list.

# Configure MTConnect Driver
1. Click "Drivers and Assets" in left side menu.
2. Click "New Driver", then select "org.eclipse.kura.driver.mtconnect" for Driver Factory.
3. Under "Driver Name", give this driver a unique name such as "MTConnectDriver1".
4. Click "Apply"
5. Select the driver row you just created and fill in a value for "mtconnect.host". This is the MTConnect API endpoint to connect to, examples: http://mtconnect.mazakcorp.com:5609 for the Mazak public API endpoint, or the Mazak SmartBox endpoint URL.
6. Click "Apply".
7. Select "New Asset", fill in value for "Asset Name". Example: MTConnectAsset1
8. Select the Asset you just created, then select "New Channel", then "Add" (this uses a default name of Channel-1.)
9. Change value.type to BYTE_ARRAY.
10. Leave mtx.xpath blank to query all streams at endpoint, or use an xpath such as //Device[@name='MFMS10-MC1'] to only bring back specific results.
11. Click "Apply".

# Create Kura Wires Route
1. Select "Wires" from left side menu.
2. Select "Timer" under "Wire Components" on far right side menu, and give it a unique name such as "pollTimer". Click "Ok". You should see a new timer component in the route. Keep default values.
3. Select "Asset" from the right side menu, select the MTConnect Asset you created previously, and "OK". Keep default values.
4. Select "Publisher" from Wires Components menu, give it a unique name such as "cloudPublisher", then click "Ok". Keep default values.
5. Now connect the components from left to right by clicking the purple box on the timer, and dragging to the MTConnect asset. Repeat by connecting the MTConnect asset to the publisher.
6. Click "Apply" to save the Wires route and start the polling timer in the route.
7. You can use a command such as ```oc rsh dc/esf tail -f /var/log/kura.log``` to watch the log file for the gateway and verify that the timer is firing and the messages are being pushed to the Cloud Service. Log messages will appear similar to this: ```2018-02-07 08:50:52,898 [DataServiceImpl:Submit] INFO  o.e.k.c.d.t.m.MqttDataTransport - Publishing message on topic: Red-Hat/02:42:AC:11:00:04/W1/A1/MTConnectAsset1 with QoS: 0```