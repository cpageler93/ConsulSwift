//
//  Consul+AgentServices.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 14.06.17.
//

import Foundation
import Quack

// API Documentation:
// https://www.consul.io/api/agent.html

public extension Consul {
    
    // MARK: - Services
    
    
    /// This endpoint returns all the services that are registered with the local agent.
    /// These services were either provided through configuration files or added dynamically using the HTTP API.
    ///
    /// It is important to note that the services known by the agent may be different from those reported
    /// by the catalog. This is usually due to changes being made while there is no leader elected.
    /// The agent performs active anti-entropy, so in most situations everything will be in sync within a few seconds.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Returns: Result with Services
    ///
    /// [apidoc]: https://www.consul.io/api/agent/service.html#list-services
    ///
    public func agentServices() -> Result<[AgentServiceOutput]> {
        return respondWithArray(path: "/v1/agent/services",
                                parser: Quack.ArrayParserByIgnoringDictionaryKeys(),
                                model: AgentServiceOutput.self)
    }
    
    /// Async version of `Consul.agentServices()`
    ///
    /// - SeeAlso: `Consul.agentServices()`
    /// - Parameter completion: completion block
    public func agentServices(completion: @escaping (Result<[AgentServiceOutput]>) -> (Void)) {
        return respondWithArrayAsync(path: "/v1/agent/services",
                                     parser: Quack.ArrayParserByIgnoringDictionaryKeys(),
                                     model: AgentServiceOutput.self,
                                     completion: completion)
    }
    
    // MARK: Register / Deregister
    
    
    /// This endpoint adds a new service, with an optional health check, to the local agent.
    /// The agent is responsible for managing the status of its local services,
    /// and for sending updates about its local services to the servers to keep the global catalog in sync.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter service: service to register
    /// - Returns: void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/service.html#register-service
    ///
    @discardableResult
    public func agentRegisterService(_ service: AgentServiceInput) -> Quack.Void {
        return respondVoid(method: .put,
                           path: "/v1/agent/service/register",
                           body: agentRegisterServiceParams(service),
                           requestModification: { (request) -> (Quack.Request) in
                            var request = request
                            request.encoding = .json
                            return request
                           })
    }
    
    /// Async version of `Consul.agentRegisterService(_ service: ConsulAgentServiceInput)`
    ///
    /// - SeeAlso: `Consul.agentRegisterService(_ service: ConsulAgentServiceInput)`
    /// - Parameter completion: completion block
    public func agentRegisterService(_ service: AgentServiceInput,
                                     completion: @escaping (Quack.Void) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/service/register",
                         body: agentRegisterServiceParams(service),
                         requestModification: { (request) -> (Quack.Request) in
                            var request = request
                            request.encoding = .json
                            return request
                         },
                         completion: completion)
    }
    
    /// helper method which returns parameters for register service
    ///
    /// - Parameter service: service input
    /// - Returns: parameters
    private func agentRegisterServiceParams(_ service: AgentServiceInput) -> [String: Any] {
        var params: [String: Any] = [:]
        
        params["Name"] = service.name
        params["Tags"] = service.tags
        
        let optionalParams: [String: Any?] = [
            "ID": service.id,
            "Address": service.address,
            "Port": service.port,
        ]
        
        for (key, value) in optionalParams {
            if let value = value {
                params[key] = value
            }
        }
        
        return params
    }
    
    /// This endpoint removes a service from the local agent. If the service does not exist, no action is taken.
    /// The agent will take care of deregistering the service with the catalog. If there is an associated check, that is also deregistered.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter id: service id to deregeister
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/service.html#deregister-service
    ///
    @discardableResult
    public func agentDeregisterService(_ id: String) -> Quack.Void {
        return respondVoid(method: .put,
                           path: "/v1/agent/service/deregister/\(id)")
    }
    
    /// Async version of `Consul.agentDeregisterService(_ id: String)`
    ///
    /// - SeeAlso: `Consul.agentDeregisterService(_ id: String)`
    /// - Parameter completion: completion block
    public func agentDeregisterService(_ id: String,
                                       completion: @escaping (Quack.Void) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/service/deregister/\(id)",
                         completion: completion)
    }
    
    // MARK: Maintenance
    
    
    /// This endpoint places a given service into "maintenance mode".
    /// During maintenance mode, the service will be marked as unavailable and will not be present in DNS or API queries.
    /// This API call is idempotent. Maintenance mode is persistent and will be automatically restored on agent restart.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - id: id of the service
    ///   - enable: enable or disable maintenance
    ///   - reason: reason
    /// - Returns: Void Result
    ///
    /// [apidoc]: https://www.consul.io/api/agent/service.html#enable-maintenance-mode
    ///
    @discardableResult
    public func agentServiceMaintenance(_ id: String,
                                        enable: Bool,
                                        reason: String) -> Quack.Void {
        let queryParams = [
            "enable": String(enable),
            "reason": reason
        ]
        return respondVoid(method: .put,
                           path: buildPath("/v1/agent/service/maintenance/\(id)", withParams: queryParams))
    }
    
    /// Async version of `Consul.agentServiceMaintenance(_ id: String, enable: Bool, reason: String)`
    ///
    /// - SeeAlso: `Consul.agentServiceMaintenance(_ id: String, enable: Bool, reason: String)`
    /// - Parameter completion: completion block
    public func agentServiceMaintenance(_ id: String,
                                        enable: Bool,
                                        reason: String,
                                        completion: @escaping (Quack.Void) -> (Void)) {
        let queryParams = [
            "enable": String(enable),
            "reason": reason
        ]
        respondVoidAsync(method: .put,
                         path: buildPath("/v1/agent/service/maintenance/\(id)", withParams: queryParams),
                         completion: completion)
    }
    
}
