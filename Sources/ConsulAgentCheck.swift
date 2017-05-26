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
