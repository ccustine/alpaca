# Creating Users and Child Accounts
1. Log in to ec-console with ec-sys/ec-password (or whatever admin credentials you have set up).
2. Add a child account to use. "Child Accounts" -> "Add". Take note of the "Account Name" because you will need this for registering gateways.
3. Select the newly created Child Account in the top pan eand click the Settings tab in the bottom pane.
4. Select each service and select the "infinite*" setting and then "Save" for each of the following services: VpnConnectionService, AccountService, GroupService, DeviceRegistryService, TagService, UserService, and JobService.
5. In the top right corner of the page click "Everyware Cloud Sysadmin @ec-sys" then "Switch to Account", and select the new Child Account that you created.
6. Add users by clicking "Users" menu, then "Add".
7. For each user that you create, select them in the top pane, and then assign a role by clicking on the "Role" tab in the bottom pane, then "Add". Select from the applicable roles.