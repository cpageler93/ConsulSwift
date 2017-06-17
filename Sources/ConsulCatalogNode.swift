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
    
    var id: String
    var node: String
    var address: String
    var datacenter: String
    var taggedAddresses: [String: String]
    
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
    
    var serviceID: String?
    var serviceName: String?
    var servicePort: Int?
    
    public required init?(json: JSON) {
        super.init(json: json)
        
        self.serviceID = json["ServiceID"].string
        self.serviceName = json["ServiceName"].string
        self.servicePort = json["ServicePort"].int
    }
}
