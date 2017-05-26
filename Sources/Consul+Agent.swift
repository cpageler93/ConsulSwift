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

extension Consul {
    
    // MARK: - Members
    
    public func agentMembers() -> QuackResult<[ConsulAgentMember]> {
        return respondWithArray(path: "/v1/agent/members",
                                model: ConsulAgentMember.self)
    }
    
    public func agentMembers(completion: @escaping (QuackResult<[ConsulAgentMember]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/agent/members",
                              model: ConsulAgentMember.self,
                              completion: completion)
    }
    
    // MARK: - Configuration
    
    public func agentReadConfiguration() -> QuackResult<ConsulAgentConfiguration> {
        return respond(path: "/v1/agent/self",
                       model: ConsulAgentConfiguration.self)
    }
    
    public func agentReadConfiguration(completion: @escaping (QuackResult<ConsulAgentConfiguration>) -> (Void)) {
        return respondAsync(path: "/v1/agent/self",
                            model: ConsulAgentConfiguration.self,
                            completion: completion)
    }
    
    // MARK: - Reload
    
    public func agentReload() -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/reload")
    }
    
    public func agentReload(completion: @escaping (QuackVoid) -> (Void)) {
        return respondVoidAsync(method: .put,
                                path: "/v1/agent/reload",
                                completion: completion)
    }
    
    // MARK: - Maintenance
    
    public func agentMaintenance(enable: Bool, reason: String) -> QuackVoid {
        return respondVoid(method: .put,
                           path: "/v1/agent/maintenance",
                           params: [
                            "enable": String(enable),
                            "reason": reason
                           ],
                           encoding: URLEncoding.queryString)
    }
    
    public func agentMaintenance(enable: Bool, reason: String, completion: @escaping (QuackVoid) -> (Void)){
        respondVoidAsync(method: .put,
                         path: "/v1/agent/maintenance",
                         params: [
                            "enable": String(enable),
                            "reason": reason
                         ],
                         encoding: URLEncoding.queryString,
                         completion: completion)
    }
    
}
