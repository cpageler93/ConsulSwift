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
case .Success(let members):
    // do whatever you like with members which is kind of [ConsulAgentMember]
case .Failure(let error):
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
    case .Success(let members):
        // do whatever you like with members which is kind of [ConsulAgentMember]
    case .Failure(let error):
        // handle error
    }
}
```
