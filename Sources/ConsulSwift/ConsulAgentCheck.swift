//
//  ConsulAgentCheck.swift
//  ConsulSwift
//
//  Created by Christoph on 26.05.17.
//
//

import Foundation
import Quack


public extension Consul {
    
    public enum AgentCheckStatus: String {
        
        case passing
        case warning
        case critical
        
    }
    
    public class AgentCheckOutput: Quack.Model {
        
        public var node: String
        public var checkID: String
        public var name: String
        public var status: AgentCheckStatus?
        public var notes: String?
        public var output: String?
        public var serviceID: String?
        public var serviceName: String?
        
        required public init?(json: JSON) {
            guard let node = json["Node"].string,
                let checkID = json["CheckID"].string,
                let name = json["Name"].string,
                let status = json["Status"].string
            else {
                return nil
            }
            
            self.node = node
            self.checkID = checkID
            self.name = name
            self.status = AgentCheckStatus(rawValue: status)
            self.notes = json["Notes"].string
            self.output = json["Output"].string
            self.serviceID = json["ServiceID"].string
            self.serviceName = json["ServiceName"].string
        }
        
    }
    
    public class AgentCheckInput {
        
        public var name: String
        public var id: String?
        public var notes: String?
        public var deregisterCriticalServiceAfter: String? // 90m
        public var script: String?
        public var dockerContainerID: String?
        public var serviceID: String?
        public var http: String?
        public var tcp: String?
        public var interval: String? // 10s
        public var ttl: String? // 15s
        public var tlsSkipVerify: Bool = false
        public var status: AgentCheckStatus?
        
        public init(name: String, ttl: String) {
            self.name = name
            self.ttl = ttl
        }
        
        public init(name: String, script: String, interval: String) {
            self.name = name
            self.script = script
            self.interval = interval
        }
        
        public init(name: String, dockerContainerID: String, interval: String) {
            self.name = name
            self.dockerContainerID = dockerContainerID
            self.interval = interval
        }
        
        public init(name: String, http: String, interval: String) {
            self.name = name
            self.http = http
            self.interval = interval
        }
        
        public init(name: String, tcp: String, interval: String) {
            self.name = name
            self.tcp = tcp
            self.interval = interval
        }
        
    }
    
}
