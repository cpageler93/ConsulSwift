//
//  Consul+AgentCheck.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 14.06.17.
//

import Foundation
import Quack

// https://www.consul.io/api/agent.html
public extension Consul {
    
    // MARK: - Checks
    
    
    /// This endpoint returns all checks that are registered with the local agent.
    /// These checks were either provided through configuration files or added dynamically using the HTTP API.
    ///
    /// It is important to note that the checks known by the agent may be different from those reported by
    /// the catalog. This is usually due to changes being made while there is no leader elected.
    /// The agent performs active anti-entropy, so in most situations everything will be in sync
    /// within a few seconds.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Returns: Result with Checks
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#list-checks
    ///
    public func agentChecks() -> QuackResult<[ConsulAgentCheckOutput]> {
        return respondWithArray(path: "/v1/agent/checks",
                                parser: QuackArrayParserByIgnoringDictionaryKeys(),
                                model: ConsulAgentCheckOutput.self)
    }
    
    /// Async version of `Consul.agentChecks()`
    ///
    /// - SeeAlso: `Consul.agentChecks()`
    /// - Parameter completion: completion block
    public func agentChecks(completion: @escaping (QuackResult<[ConsulAgentCheckOutput]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/agent/checks",
                              parser: QuackArrayParserByIgnoringDictionaryKeys(),
                              model: ConsulAgentCheckOutput.self,
                              completion: completion)
    }
    
    // MARK: Register / Deregister
    
    
    /// This endpoint adds a new check to the local agent. Checks may be of script, HTTP, TCP, or TTL type.
    /// The agent is responsible for managing the status of the check and keeping the Catalog in sync.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter check: check to register
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#register-check
    public func agentRegisterCheck(_ check: ConsulAgentCheckInput) -> QuackVoid {
        let params = agentRegisterCheckParams(check)
        return respondVoid(method: .put,
                           path: "/v1/agent/check/register",
                           body: params)
    }
    
    /// Async version of `Consul.agentRegisterCheck(_ check: ConsulAgentCheckInput)`
    ///
    /// - SeeAlso: `Consul.agentRegisterCheck(_ check: ConsulAgentCheckInput)`
    /// - Parameter completion: completion block
    public func agentRegisterCheck(_ check: ConsulAgentCheckInput,
                                   completion: @escaping (QuackVoid) -> (Void)) {
        let params = agentRegisterCheckParams(check)
        respondVoidAsync(method: .put,
                         path: "/v1/agent/check/register",
                         body: params,
                         completion: completion)
    }
    
    /// helper method which returns parameters for register check
    ///
    /// - Parameter check: check input
    /// - Returns: parameters
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
    
    /// This endpoint remove a check from the local agent.
    /// The agent will take care of deregistering the check from the catalog.
    /// If the check with the provided ID does not exist, no action is taken.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter id: check id
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#deregister-check
    public func agentDeregisterCheck(id: String) -> QuackVoid {
        return respondVoid(method: .put, path: "/v1/agent/check/deregister/\(id)")
    }
    
    /// Async version of `Consul.agentDeregisterCheck(id: String)`
    ///
    /// - SeeAlso: `Consul.agentDeregisterCheck(id: String)`
    /// - Parameter completion: completion block
    public func agentDeregisterCheck(id: String,
                                     completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/check/deregister/\(id)",
                         completion: completion)
    }
    
    // MARK: Check Status
    
    
    /// This endpoint is used with a TTL type check to set the status of the check to passing and
    /// to reset the TTL clock.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter id: check id
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#ttl-check-pass
    @discardableResult
    public func agentCheckPass(id: String) -> QuackVoid {
        return respondVoid(path: "/v1/agent/check/pass/\(id)")
    }
    
    /// Async version of `Consul.agentCheckPass(id: String)`
    ///
    /// - SeeAlso: `Consul.agentCheckPass(id: String)`
    /// - Parameter completion: completion block
    public func agentCheckPass(id: String,
                               completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/check/pass/\(id)",
                         completion: completion)
    }
    
    /// This endpoint is used with a TTL type check to set the status of the check to warning and
    /// to reset the TTL clock.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - id: check id
    ///   - note: note
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#ttl-check-warn
    @discardableResult
    public func agentCheckWarn(id: String,
                               note: String = "") -> QuackVoid {
        return respondVoid(path: "/v1/agent/check/warn/\(id)",
                           body: ["note": note])
    }
    
    /// Async version of `Consul.agentCheckWarn(id: String, note: String)`
    ///
    /// - SeeAlso: `Consul.agentCheckWarn(id: String, note: String)`
    /// - Parameter completion: completion block
    public func agentCheckWarn(id: String,
                               note: String = "",
                               completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/check/warn/\(id)",
                         body: ["note": note],
                         completion: completion)
    }
    
    /// This endpoint is used with a TTL type check to set the status of the check to critical and
    /// to reset the TTL clock.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - id: check id
    ///   - note: note
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#ttl-check-fail
    @discardableResult
    public func agentCheckFail(id: String,
                               note: String = "") -> QuackVoid {
        return respondVoid(path: "/v1/agent/check/fail/\(id)",
                           body: ["note": note])
    }
    
    /// Async version of `Consul.agentCheckFail(id: String, note: String)`
    ///
    /// - SeeAlso: `Consul.agentCheckFail(id: String, note: String)`
    /// - Parameter completion: completion block
    public func agentCheckFail(id: String,
                               note: String = "",
                               completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(path: "/v1/agent/check/fail/\(id)",
                         body: ["note": note],
                         completion: completion)
    }
    
    /// This endpoint is used with a TTL type check to set the status of the check and to reset the TTL clock.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - id: check id
    ///   - status: new status
    ///   - output: output string
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/check.html#ttl-check-update
    @discardableResult
    public func agentCheckUpdate(id: String,
                                 status: ConsulAgentCheckStatus,
                                 output: String = "") -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/check/update/\(id)",
                           body: [
                            "Status": status.rawValue,
                            "Output": output
                           ])
    }
    
    /// Async version of `Consul.agentCheckUpdate(id: String, status: ConsulAgentCheckStatus, output: String)`
    ///
    /// - SeeAlso: `Consul.agentCheckUpdate(id: String, status: ConsulAgentCheckStatus, output: String)`
    /// - Parameter completion: completion block
    public func agentCheckUpdate(id: String,
                                 status: ConsulAgentCheckStatus,
                                 output: String = "",
                                 completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/check/fail/\(id)",
                         body: [
                            "Status": status.rawValue,
                            "Output": output
                         ],
                         completion: completion)
    }
}
