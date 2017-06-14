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
    
    public func agentRegisterService(_ service: ConsulAgentServiceInput) -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/service/register",
                           params: agentRegisterServiceParams(service),
                           encoding: JSONEncoding.default)
    }
    
    public func agentRegisterService(_ service: ConsulAgentServiceInput,
                                     completion: @escaping (QuackVoid) -> (Void)) {
        respondVoidAsync(method: .put,
                         path: "/v1/agent/service/register",
                         params: agentRegisterServiceParams(service),
                         encoding: JSONEncoding.default,
                         completion: completion)
    }
    
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
}
