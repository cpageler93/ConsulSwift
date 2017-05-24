# ConsulSwift
Consul Client for Swift

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

|  Group             |  Endpoint                    |  Route                           | Implemented  |
|--------------------|------------------------------|----------------------------------|--------------|
|  Agent - Base      |  List Members                |  GET /v1/agent/members           | ✅           |
|                    |  Read Configuration          |  GET /v1/agent/self              | ✅           |
|                    |  Reload Agent                |  PUT /v1/agent/reload            | ❌           |
|                    |  Enable Maintenance Mode     |  PUT /v1/agent/maintenance       | ❌           |
|                    |  Join Agent                  |  GET /v1/agent/join/:id          | ❌           |
|                    |  Gracefull Leave + Shutdown  |  PUT /v1/agent/leave             | ❌           |
|                    |  Force Leave + Shutdown      |  PUT /v1/agent/force-leave       | ❌           |
|--------------------|------------------------------|----------------------------------|--------------|
|  Agent - Checs     |  List Checks                 |  GET /v1/agent/checks            | ❌           |
|                    |                              |                                  | ❌           |
|                    |                              |                                  | ❌           |
|                    |                              |                                  | ❌           |
|                    |                              |                                  | ❌           |
|                    |                              |                                  | ❌           |

