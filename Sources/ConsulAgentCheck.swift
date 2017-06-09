//
//  ConsulAgentCheck.swift
//  ConsulSwift
//
//  Created by Christoph on 26.05.17.
//
//

import Foundation
import Quack
import SwiftyJSON

public enum ConsulAgentCheckStatus: String {
    case passing
    case warning
    case critical
}

public class ConsulAgentCheckOutput: QuackModel {
    var node: String
    var checkID: String
    var name: String
    var status: ConsulAgentCheckStatus?
    var notes: String?
    var output: String?
    var serviceID: String?
    var serviceName: String?
    
    required public init?(json: JSON) {
        guard
            let node = json["Node"].string,
            let checkID = json["CheckID"].string,
            let name = json["Name"].string,
            let status = json["Status"].string else { return nil }
        self.node = node
        self.checkID = checkID
        self.name = name
        self.status = ConsulAgentCheckStatus(rawValue: status)
        self.notes = json["Notes"].string
        self.output = json["Output"].string
        self.serviceID = json["ServiceID"].string
        self.serviceName = json["ServiceName"].string
    }
}

public class ConsulAgentCheckInput {
    var name: String
    var id: String?
    var notes: String?
    var deregisterCriticalServiceAfter: String? // 90m
    var script: String?
    var dockerContainerID: String?
    var serviceID: String?
    var http: String?
    var tcp: String?
    var interval: String? // 10s
    var ttl: String? // 15s
    var tlsSkipVerify: Bool = false
    var status: ConsulAgentCheckStatus?
    
    init(name: String, ttl: String) {
        self.name = name
        self.ttl = ttl
    }
    
    init(name: String, script: String, interval: String) {
        self.name = name
        self.script = script
        self.interval = interval
    }
    
    init(name: String, dockerContainerID: String, interval: String) {
        self.name = name
        self.dockerContainerID = dockerContainerID
        self.interval = interval
    }
    
    init(name: String, http: String, interval: String) {
        self.name = name
        self.http = http
        self.interval = interval
    }
    
    init(name: String, tcp: String, interval: String) {
        self.name = name
        self.tcp = tcp
        self.interval = interval
    }
}
