//
//  ConsulCatalogNode.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulCatalogNode: QuackModel {
    
    public var id: String
    public var node: String
    public var address: String
    public var datacenter: String
    public var taggedAddresses: [String: String]
    
    public required init?(json: JSON) {
        guard
            let id = json["ID"].string,
            let node = json["Node"].string,
            let address = json["Address"].string,
            let datacenter = json["Datacenter"].string
            else { return nil }
        
        self.id = id
        self.node = node
        self.address = address
        self.datacenter = datacenter
        
        var taggedAddresses: [String: String] = [:]
        if let taggedAddressesJson = json["TaggedAddresses"].dictionary {
            for (key, value) in taggedAddressesJson {
                if let valueString = value.string {
                    taggedAddresses[key] = valueString
                }
            }
        }
        self.taggedAddresses = taggedAddresses
    }

}

public class ConsulCatalogNodeWithService: ConsulCatalogNode {
    
    public var serviceID: String?
    public var serviceName: String?
    public var servicePort: Int?
    
    public required init?(json: JSON) {
        self.serviceID = json["ServiceID"].string
        self.serviceName = json["ServiceName"].string
        self.servicePort = json["ServicePort"].int
        
        super.init(json: json)
    }
    
}

public class ConsulCatalogNodeWithServices: ConsulCatalogNode {
    
    public var services: [ConsulAgentServiceOutput]
    
    public required init?(json: JSON) {
        let nodeJson = json["Node"]
        guard nodeJson.exists() else { return nil }
        
        var services: [ConsulAgentServiceOutput] = []
        if let jsonServices = json["Services"].dictionary {
            for (_, jsonService) in jsonServices {
                if let service = ConsulAgentServiceOutput(json: jsonService) {
                    services.append(service)
                }
            }
        }
        self.services = services
        
        super.init(json: nodeJson)
    }

}


public class ConsulCatalogNodeWithServiceAndChecks: ConsulCatalogNode {
    
    public var service: ConsulAgentServiceOutput
    public var checks: [ConsulAgentCheckOutput] = []
    
    public required init?(json: JSON) {
        guard let service = ConsulAgentServiceOutput(json: json["Service"]) else { return nil }
        self.service = service
        
        var checks: [ConsulAgentCheckOutput] = []
        if let jsonChecks = json["Checks"].array {
            for jsonCheck in jsonChecks {
                if let check = ConsulAgentCheckOutput(json: jsonCheck) {
                    checks.append(check)
                }
            }
        }
        self.checks = checks
        
        super.init(json: json["Node"])
    }
    
}
