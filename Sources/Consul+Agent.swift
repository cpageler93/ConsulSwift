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
    
    // MARK: - Leave / Shutdown
    
    public func agentLeave(force: Bool = false) -> QuackVoid {
        return respondVoid(method: .put,
                           path: agentLeavePath(force: force))
    }
    
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
