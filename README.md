# ConsulSwift

[Consul](https://www.consul.io) Client for Swift

ConsulSwift connects to `http://localhost:8500` by default.

You can change the default behaviour by calling an other initializer.

```swift
let consul = Consul(url: otherBaseURL)
```

## Examples

### Synchronous Example

```swift
// get consul instance
let consul = Consul()

// get agent members
let members = consul.agentMembers()

// check members result
switch members {
case .success(let members):
    // do whatever you like with members which is kind of [ConsulAgentMember]
case .failure(let error):
    // handle error
}
```

### Asynchronous Example

```swift
// get consul instance
let consul = Consul()

// get agent members
consul.agentMembers { members in
    // check members result
    switch members {
    case .success(let members):
        // do whatever you like with members which is kind of [ConsulAgentMember]
    case .failure(let error):
        // handle error
    }
}
```

## Features

|  Group             |  Endpoint                       |  Route                                   | Implemented  |
|--------------------|---------------------------------|------------------------------------------|--------------|
|  Agent - Base      |  List Members                   |  GET /v1/agent/members                   | ✅           |
|                    |  Read Configuration             |  GET /v1/agent/self                      | ✅           |
|                    |  Reload Agent                   |  PUT /v1/agent/reload                    | ✅           |
|                    |  Enable Maintenance Mode        |  PUT /v1/agent/maintenance               | ✅           |
|                    |  Join Agent                     |  GET /v1/agent/join/:id                  | ❌           |
|                    |  Gracefull Leave + Shutdown     |  PUT /v1/agent/leave                     | ❌           |
|                    |  Force Leave + Shutdown         |  PUT /v1/agent/force-leave               | ❌           |
|                    |                                 |                                          |              |
|  Agent - Checs     |  List Checks                    |  GET /v1/agent/checks                    | ❌           |
|                    |  Register Check                 |  PUT /v1/agent/check/register            | ❌           |
|                    |  Deregister Check               |  PUT /v1/agent/check/deregister/:id      | ❌           |
|                    |  TLL Check Pass                 |  GET /v1/agent/check/pass/:id            | ❌           |
|                    |  TLL Check Warn                 |  GET /v1/agent/check/warn/:id            | ❌           |
|                    |  TLL Check Fail                 |  GET /v1/agent/check/fail/:id            | ❌           |
|                    |  TLL Check Update               |  GET /v1/agent/check/update/:id          | ❌           |
|                    |                                 |                                          |              |
|  Agent - Services  |  List Services                  |  GET /v1/agent/services                  | ❌           |
|                    |  Register Service               |  PUT /v1/agent/service/register          | ❌           |
|                    |  Deregister Service             |  PUT /v1/agent/service/deregister/:id    | ❌           |
|                    |  Enable Maintenance Mode        |  PUT /v1/agent/service/maintenance/:id   | ❌           |
|                    |                                 |                                          | ❌           |
|  Catalog           |  List Datacenters               |  GET /v1/catalog/datacenters             | ❌           |
|                    |  List Nodes in a given DC       |  GET /v1/catalog/nodes                   | ❌           |
|                    |  List Services in a given DC    |  GET /v1/catalog/services                | ❌           |
|                    |  List Nodes for Service         |  GET /v1/catalog/service/:id             | ❌           |
|                    |  List Services for Node         |  GET /v1/catalog/node/:id                | ❌           |
|                    |                                 |                                          | ❌           |
|  Coordinates       |  Read WAN Coordinates           |  GET /v1/coordinates/datacenters         | ❌           |
|                    |  Read LAN Coordinates           |  GET /v1/coordinates/nodes               | ❌           |
|                    |                                 |                                          | ❌           |
|  Events            |  Fire Event                     |  PUT /v1/event/fire/:name                | ❌           |
|                    |  List Events                    |  GET /v1/event/list                      | ❌           |
|                    |                                 |                                          | ❌           |
|  Health            |  List Checks for Node           |  GET /v1/health/node/:id                 | ❌           |
|                    |  List Checks for Service        |  GET /v1/health/checks/:id               | ❌           |
|                    |  List Nodes for Service         |  GET /v1/health/service/:id              | ❌           |
|                    |  List Checks in State           |  GET /v1/health/state/:state             | ❌           |
|                    |                                 |                                          | ❌           |
|  KV Store          |  Read Key                       |  GET /v1/kv/:key                         | ❌           |
|                    |  Create/Update Key              |  PUT /v1/kv/:key                         | ❌           |
|                    |  Delete Key                     |  DELETE /v2/kv/:key                      | ❌           |
|                    |                                 |                                          | ❌           |

## Test

To test ConsulSwift on your local machine you need to start consul first

    # start consul
    consul agent -dev -dc=fra1

    # test
    swift test


## Need Help?

Please [submit an issue](https://github.com/cpageler93/ConsulSwift/issues) on GitHub or contact me via Mail or Twitter.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.