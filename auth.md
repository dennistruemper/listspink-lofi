## Flows

### new User

FE connect WS to BE
FE createUser User to BE

- create UserId and DeviceId, store on device
- BE stores User and DeviceId
- BE stores sessionId and a reference to UserId

### connect client for existing User

FE connects WS to BE
FE connectClient User BE

- BE checks for sessionID and if User and device is matching
  - sessionId with matching user and device -> OK
  - noSessionId -> ask for PIN on other devices
