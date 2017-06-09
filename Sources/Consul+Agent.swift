//
//  Consul+Agent.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 16.05.17.
//
//

import Foundation
import Quack
import Alamofire

// https://www.consul.io/api/agent.html
extension Consul {
    
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
    public func agentMembers() -> QuackResult<[ConsulAgentMember]> {
        return respondWithArray(path: "/v1/agent/members",
                                model: ConsulAgentMember.self)
    }
    
    /// Async version of `Consul.agentMembers()`
    ///
    /// - SeeAlso: `Consul.agentMembers()`
    /// - Parameter completion: completion block
    public func agentMembers(completion: @escaping (QuackResult<[ConsulAgentMember]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/agent/members",
                              model: ConsulAgentMember.self,
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
    public func agentReadConfiguration() -> QuackResult<ConsulAgentConfiguration> {
        return respond(path: "/v1/agent/self",
                       model: ConsulAgentConfiguration.self)
    }
    
    /// Async version of `Consul.agentReadConfiguration()`
    ///
    /// - SeeAlso: `Consul.agentReadConfiguration()`
    /// - Parameter completion: completion block
    public func agentReadConfiguration(completion: @escaping (QuackResult<ConsulAgentConfiguration>) -> (Void)) {
        return respondAsync(path: "/v1/agent/self",
                            model: ConsulAgentConfiguration.self,
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
    public func agentReload() -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/reload")
    }
    
    /// Async version of `Consul.agentReload()`
    ///
    /// - SeeAlso: `Consul.agentReload()`
    /// - Parameter completion: completion block
    public func agentReload(completion: @escaping (QuackVoid) -> (Void)) {
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
    public func agentMaintenance(enable: Bool,
                                 reason: String) -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/maintenance",
                           params: [
                            "enable": String(enable),
                            "reason": reason
                           ],
                           encoding: URLEncoding.queryString)
    }
    
    /// Async version of `Consul.agentMaintenance(enable: Bool, reason: String)`
    ///
    /// - SeeAlso: `Consul.agentMaintenance(enable: Bool, reason: String)`
    /// - Parameter completion: completion block
    public func agentMaintenance(enable: Bool,
                                 reason: String,
                                 completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/maintenance",
                         params: [
                            "enable": String(enable),
                            "reason": reason
                         ],
                         encoding: URLEncoding.queryString,
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
    public func agentJoin(address: String,
                          wan: Bool = false) -> QuackVoid {
        return respondVoid(path: "/v1/agent/join/\(address)",
                           params: ["wan": String(wan)])
    }
    
    // TODO: add tests
    // missing tests because missing address to join
    
    /// Async version of `Consul.agentJoin(address: String, wan: Bool)`
    ///
    /// - SeeAlso: `Consul.agentJoin(address: String, wan: Bool)`
    /// - Parameter completion: completion block
    public func agentJoin(address: String,
                          wan: Bool = false, 
                          completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/join/\(address)",
                         params: ["wan": String(wan)],
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
    /// - Parameter force: Specifices to leave gracefully or forced
    ///
    /// - Returns: Void Result
    ///
    /// [apidocGraceful]: https://www.consul.io/api/agent.html#graceful-leave-and-shutdown
    /// [apidocForce]: https://www.consul.io/api/agent.html#force-leave-and-shutdown
    ///
    public func agentLeave(force: Bool = false) -> QuackVoid {
        return respondVoid(method: .put,
                           path: agentLeavePath(force: force))
    }
    
    /// Async version of `Consul.agentLeave(force: Bool)`
    ///
    /// - SeeAlso: `Consul.agentLeave(force: Bool)`
    /// - Parameter completion: completion block
    public func agentLeave(force: Bool = false, completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: agentLeavePath(force: force),
                         completion: completion)
    }
    
    private func agentLeavePath(force: Bool) -> String {
        if force {
            return "/v1/agent/force-leave"
        } else {
            return "/v1/agent/leave"
        }
    }
    
    // MARK: - Checks
    
    public func agentChecks() -> QuackResult<[ConsulAgentCheckOutput]> {
        return respondWithArray(path: "/v1/agent/checks",
                                parser: QuackArrayParserByIgnoringDictionaryKeys(),
                                model: ConsulAgentCheckOutput.self)
    }
    
    public func agentChecks(completion: @escaping (QuackResult<[ConsulAgentCheckOutput]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/agent/checks",
                              parser: QuackArrayParserByIgnoringDictionaryKeys(),
                              model: ConsulAgentCheckOutput.self,
                              completion: completion)
    }
    
    public func agentRegisterCheck(_ check: ConsulAgentCheckInput) -> QuackVoid {
        let params = agentRegisterCheckParams(check)
        return respondVoid(method: .put,
                           path: "/v1/agent/check/register",
                           params: params,
                           encoding: JSONEncoding.default)
    }
    
    public func agentRegisterCheck(_ check: ConsulAgentCheckInput, completion: @escaping (QuackVoid) -> (Void)) {
        let params = agentRegisterCheckParams(check)
        respondVoidAsync(method: .put,
                         path: "/v1/agent/check/register",
                         params: params,
                         encoding: JSONEncoding.default,
                         completion: completion)
    }
    
    private func agentRegisterCheckParams(_ check: ConsulAgentCheckInput) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["Name"] = check.name
        
        let optionalParams: [String: Any?] = [
            "Notes": check.notes,
            "DeregisterCriticalServiceAfter": check.deregisterCriticalServiceAfter,
            "Script": check.script,
            "DockerContainerID": check.dockerContainerID,
            "ServiceID": check.serviceID,
            "HTTP": check.http,
            "TCP": check.tcp,
            "Interval": check.interval,
            "TTL": check.ttl,
            "TLSSkipVerify": check.tlsSkipVerify,
            "Status": check.status?.rawValue
        ]
        
        for (key, value) in optionalParams {
            if let value = value {
                params[key] = value
            }
        }
        
        return params
    }
    
    public func agentDeregisterCheck(id: String) -> QuackVoid {
        return respondVoid(method: .put, path: "/v1/agent/check/deregister/\(id)")
    }
    
    public func agentDeregisterCheck(id: String,
                                     completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/check/deregister/\(id)",
                         completion: completion)
    }
    
    public func agentCheckPass(id: String) -> QuackVoid {
        return respondVoid(path: "/v1/agent/check/pass/\(id)")
    }
    
    public func agentCheckPass(id: String,
                               completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/check/pass/\(id)",
                         completion: completion)
    }
    
    public func agentCheckWarn(id: String,
                               note: String = "") -> QuackVoid {
        return respondVoid(path: "/v1/agent/check/warn/\(id)",
                           params: ["note": note])
    }
    
    public func agentCheckWarn(id: String,
                               note: String = "",
                               completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/check/warn/\(id)",
                         params: ["note": note],
                         completion: completion)
    }
    
    public func agentCheckFail(id: String,
                               note: String = "") -> QuackVoid {
        return respondVoid(path: "/v1/agent/check/fail/\(id)",
                           params: ["note": note])
    }
    
    public func agentCheckFail(id: String,
                               note: String = "",
                               completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/check/fail/\(id)",
                         params: ["note": note],
                         completion: completion)
    }
    
    public func agentCheckUpdate(id: String,
                                 status: ConsulAgentCheckStatus,
                                 output: String = "") -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/check/update/\(id)",
                           params: [
                            "Status": status.rawValue,
                            "Output": output
                           ],
                           encoding: JSONEncoding.default)
    }
    
    public func agentCheckUpdate(id: String,
                                 status: ConsulAgentCheckStatus,
                                 output: String = "",
                                 completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/check/fail/\(id)",
                         params: [
                            "Status": status.rawValue,
                            "Output": output
                         ],
                         encoding: JSONEncoding.default,
                         completion: completion)
    }
}
