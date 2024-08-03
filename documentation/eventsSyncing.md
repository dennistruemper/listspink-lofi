## Event Synchronisation

The client should have all the Events needed for the subscriptions and the server should have all events and distribute for clients and their devices

### Client

The client should have alle Events sorted by creationtime. The client should be able to subscribe and unsubscribe to aggregationIds. If the client creates a new aggregationId, it is subscribed to it.

#### Self created event

Every self created event should be appened in the end. The new List of events should be stored on client. And the new Event should be send to Server. Current state has to be reevaluated. Introduce cache later on.

#### Other device created event

Should get synced from Backend to Frontend. Should get sorted in to the right time. Store new Events on client. Current state has to be reevaluated.

### Server

- The server should get every event store in by aggregartionId.
- The server should be able to find out quickly, which users are subscribed to an aggregationId and which aggregationIds
- The server should know, which events are not synced to subscribed clients.
