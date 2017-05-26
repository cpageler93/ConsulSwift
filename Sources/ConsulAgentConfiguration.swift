//
//  ConsulAgentConfiguration.swift
//  ConsulSwift
//
//  Created by Christoph on 24.05.17.
//
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulAgentConfiguration: QuackModel {
    var devMode: Bool
    var bootstrap: Bool
    var server: Bool
    var datacenter: String
    var nodeID: String
    var nodeName: String
    
    required public init?(json: JSON) {
        guard
            let config = json["Config"].dictionary,
            let devMode = config["DevMode"]?.bool,
            let bootstrap = config["Bootstrap"]?.bool,
            let server = config["Server"]?.bool,
            let datacenter = config["Datacenter"]?.string,
            let nodeID = config["NodeID"]?.string,
            let nodeName = config["NodeName"]?.string
        else {
            return nil
        }
        
        self.devMode = devMode
        self.bootstrap = bootstrap
        self.server = server
        self.datacenter = datacenter
        self.nodeID = nodeID
        self.nodeName = nodeName
    }
}