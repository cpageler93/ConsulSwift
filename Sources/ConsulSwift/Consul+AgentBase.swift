//
//  Consul+Agent.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 16.05.17.
//
//

import Foundation
import Quack

// API Documentation:
// https://www.consul.io/api/agent.html

public extension Consul {
    
    // MARK: - Members
    

    /// This endpoint returns the members the agent sees in the cluster gossip pool.
    /// Due to the nature of gossip, this is eventually consistent: the results may differ by agent.
    /// The strongly consistent view of nodes is instead provided by /v1/catalog/nodes.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Returns: Result with array of Members
    ///
    /// [apidoc]: https://www.consul.io/api/agent.html#list-members
    public func agentMembers() -> Quack.Result<[AgentMember]> {
        return respondWithArray(path: "/v1/agent/members",
                                model: AgentMember.self)
    }
    
    /// Async version of `Consul.agentMembers()`
    ///
    /// - SeeAlso: `Consul.agentMembers()`
    /// - Parameter completion: completion block
    public func agentMembers(completion: @escaping (Quack.Result<[AgentMember]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/agent/members",
                              model: AgentMember.self,
                              completion: completion)
    }
    
    // MARK: - Configuration
    
    
    /// This endpoint returns the configuration and member information of the local agent.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Returns: Result with Agent Configuration
    ///
    /// [apidoc]: https://www.consul.io/api/agent.html#read-configuration
    public func agentReadConfiguration() -> Quack.Result<AgentConfiguration> {
        return respond(path: "/v1/agent/self",
                       model: AgentConfiguration.self)
    }
    
    /// Async version of `Consul.agentReadConfiguration()`
    ///
    /// - SeeAlso: `Consul.agentReadConfiguration()`
    /// - Parameter completion: completion block
    public func agentReadConfiguration(completion: @escaping (Quack.Result<AgentConfiguration>) -> (Void)) {
        return respondAsync(path: "/v1/agent/self",
                            model: AgentConfiguration.self,
                            completion: completion)
    }
    
    // MARK: - Reload
    
    
    /// This endpoint instructs the agent to reload its configuration. Any errors encountered during this process are returned.
    /// Not all configuration options are reloadable.
    /// See the Reloadable Configuration section on the agent options page for details on which options are supported.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent.html#reload-agent
    @discardableResult
    public func agentReload() -> Quack.Void {
        return respondVoid(method: .put,
                           path: "/v1/agent/reload")
    }
    
    /// Async version of `Consul.agentReload()`
    ///
    /// - SeeAlso: `Consul.agentReload()`
    /// - Parameter completion: completion block
    public func agentReload(completion: @escaping (Quack.Void) -> (Void)) {
        return respondVoidAsync(method: .put,
                                path: "/v1/agent/reload",
                                completion: completion)
    }
    
    // MARK: - Maintenance
    
    
    /// This endpoint places the agent into "maintenance mode". During maintenance mode,
    /// the node will be marked as unavailable and will not be present in DNS or API queries.
    /// This API call is idempotent.
    ///
    /// Maintenance mode is persistent and will be automatically restored on agent restart.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - enable: Specifies whether to enable or disable maintenance mode.
    ///   - reason: Specifies a text string explaining the reason for placing the node into maintenance mode. This is simply to aid human operators. If no reason is provided, a default value will be used instead.
    ///
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent.html#enable-maintenance-mode
    @discardableResult
    public func agentMaintenance(enable: Bool,
                                 reason: String) -> Quack.Void {
        let queryParams = [
            "enable": String(enable),
            "reason": reason
        ]
        return respondVoid(method: .put,
                           path: buildPath("/v1/agent/maintenance", withParams: queryParams))
    }
    
    /// Async version of `Consul.agentMaintenance(enable: Bool, reason: String)`
    ///
    /// - SeeAlso: `Consul.agentMaintenance(enable: Bool, reason: String)`
    /// - Parameter completion: completion block
    public func agentMaintenance(enable: Bool,
                                 reason: String,
                                 completion: @escaping (Quack.Void) -> (Void)) {
        let queryParams = [
            "enable": String(enable),
            "reason": reason
        ]
        respondVoidAsync(method: .put,
                         path: buildPath("/v1/agent/maintenance", withParams: queryParams),
                         completion: completion)
    }
    
    // MARK: - Join
    
    
    // TODO: add tests
    // missing tests because missing address to join
    
    /// This endpoint instructs the agent to attempt to connect to a given address.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - address: Specifies the address of the other agent to join
    ///   - wan: Specifies to try and join over the WAN pool. This is only optional for agents running in server mode.
    ///
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent.html#join-agent
    ///
    @discardableResult
    public func agentJoin(address: String,
                          wan: Bool = false) -> Quack.Void {
        return respondVoid(path: "/v1/agent/join/\(address)",
                           body: Quack.JSONBody(["wan": String(wan)]))
    }
    
    // TODO: add tests
    // missing tests because missing address to join
    
    /// Async version of `Consul.agentJoin(address: String, wan: Bool)`
    ///
    /// - SeeAlso: `Consul.agentJoin(address: String, wan: Bool)`
    /// - Parameter completion: completion block
    public func agentJoin(address: String,
                          wan: Bool = false,
                          completion: @escaping (Quack.Void) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/join/\(address)",
                         body: Quack.JSONBody(["wan": String(wan)]),
                         completion: completion)
    }
    
    // MARK: - Leave / Shutdown
    
    
    /// ## Graceful
    /// This endpoint triggers a graceful leave and shutdown of the agent.
    /// It is used to ensure other nodes see the agent as "left" instead of "failed".
    /// Nodes that leave will not attempt to re-join the cluster on restarting with a snapshot.
    ///
    /// For nodes in server mode, the node is removed from the Raft peer set in a graceful manner.
    /// This is critical, as in certain situations a non-graceful leave can affect cluster availability.
    ///
    /// ## Force
    /// This endpoint instructs the agent to force a node into the left state.
    /// If a node fails unexpectedly, then it will be in a failed state. Once in the failed state,
    /// Consul will attempt to reconnect, and the services and checks belonging to that node will not be cleaned up.
    /// Forcing a node into the left state allows its old entries to be removed.
    ///
    /// - [API Documentation Graceful][apidocGraceful]
    /// - [API Documentation Force][apidocForce]
    ///
    /// - Parameter force: Specifices to leave gracefully or forced
    ///
    /// - Returns: Void Result
    ///
    /// [apidocGraceful]: https://www.consul.io/api/agent.html#graceful-leave-and-shutdown
    /// [apidocForce]: https://www.consul.io/api/agent.html#force-leave-and-shutdown
    ///
    @discardableResult
    public func agentLeave(force: Bool = false) -> Quack.Void {
        return respondVoid(method: .put,
                           path: agentLeavePath(force: force))
    }
    
    /// Async version of `Consul.agentLeave(force: Bool)`
    ///
    /// - SeeAlso: `Consul.agentLeave(force: Bool)`
    /// - Parameter completion: completion block
    public func agentLeave(force: Bool = false, completion: @escaping (Quack.Void) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: agentLeavePath(force: force),
                         completion: completion)
    }
    
    /// just a small helper method which returns the correct path for agent-leave (forced)
    ///
    /// - Parameter force: Specifies whether the path for force of graceful shutdown should be returned
    /// - Returns: leave path
    private func agentLeavePath(force: Bool) -> String {
        if force {
            return "/v1/agent/force-leave"
        } else {
            return "/v1/agent/leave"
        }
    }
    
}
