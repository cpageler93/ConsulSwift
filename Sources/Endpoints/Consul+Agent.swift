//
//  Consul+Agent.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 16.05.17.
//
//

import Foundation
import Quack
import Models

extension Consul {
    
    public func agentMembers() {
        respondWithArray(method: .get, path: "/v1/agent/members", model: ConsulAgentMember.self)
    }
    
}
