//
//  Consul+AgentServices.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 14.06.17.
//

import Foundation
import Quack
import Alamofire

// https://www.consul.io/api/agent.html
extension Consul {
    
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
    public func agentServices() -> QuackResult<[ConsulAgentServiceOutput]> {
        return respondWithArray(path: "/v1/agent/services",
                                parser: QuackArrayParserByIgnoringDictionaryKeys(),
                                model: ConsulAgentServiceOutput.self)
    }
    
    /// Async version of `Consul.agentServices()`
    ///
    /// - SeeAlso: `Consul.agentServices()`
    /// - Parameter completion: completion block
    public func agentServices(completion: @escaping (QuackResult<[ConsulAgentServiceOutput]>) -> (Void)) {
        return respondWithArrayAsync(path: "/v1/agent/services",
                                     parser: QuackArrayParserByIgnoringDictionaryKeys(),
                                     model: ConsulAgentServiceOutput.self,
                                     completion: completion)
    }
    
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
    public func agentRegisterService(_ service: ConsulAgentServiceInput) -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/service/register",
                           params: agentRegisterServiceParams(service),
                           encoding: JSONEncoding.default)
    }
    
    /// Async version of `Consul.agentRegisterService(_ service: ConsulAgentServiceInput)`
    ///
    /// - SeeAlso: `Consul.agentRegisterService(_ service: ConsulAgentServiceInput)`
    /// - Parameter completion: completion block
    public func agentRegisterService(_ service: ConsulAgentServiceInput,
                                     completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/service/register",
                         params: agentRegisterServiceParams(service),
                         encoding: JSONEncoding.default,
                         completion: completion)
    }
    
    /// helper method which returns parameters for register service
    ///
    /// - Parameter service: service input
    /// - Returns: parameters
    private func agentRegisterServiceParams(_ service: ConsulAgentServiceInput) -> [String: Any] {
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
    public func agentDeregisterService(_ id: String) -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/service/deregister/\(id)")
    }
    
    /// Async version of `Consul.agentDeregisterService(_ id: String)`
    ///
    /// - SeeAlso: `Consul.agentDeregisterService(_ id: String)`
    /// - Parameter completion: completion block
    public func agentDeregisterService(_ id: String,
                                       completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/service/deregister/\(id)",
                         completion: completion)
    }
    
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
    public func agentServiceMaintenance(_ id: String,
                                        enable: Bool,
                                        reason: String) -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/service/maintenance/\(id)",
                           params: [
                                "enable": String(enable),
                                "reason": reason
                           ],
                           encoding: URLEncoding.queryString)
    }
    
    /// Async version of `Consul.agentServiceMaintenance(_ id: String, enable: Bool, reason: String)`
    ///
    /// - SeeAlso: `Consul.agentServiceMaintenance(_ id: String, enable: Bool, reason: String)`
    /// - Parameter completion: completion block
    public func agentServiceMaintenance(_ id: String,
                                        enable: Bool,
                                        reason: String,
                                        completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/service/maintenance/\(id)",
                         params: [
                            "enable": String(enable),
                            "reason": reason
                         ],
                         encoding: URLEncoding.queryString,
                         completion: completion)
    }
    
}
