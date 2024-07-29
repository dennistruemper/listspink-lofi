## Flows

Module `UserManagement` handles Auth.

### new User

- Create new user on client.
- Store new user on client.
- Send new user to backend and connect to current session

### connect client for existing User

- Start on new device / browser
- Click "Connect Existing Account"
- Open app on already connected device
- Show Code to connect
- Enter code and device name on new device

### reconnect User

- UserId and DeviceId is stored from previous session
- UserId and DeviceId is send to backend to reregister new session Id
