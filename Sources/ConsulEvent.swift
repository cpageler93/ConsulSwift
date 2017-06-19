//
//  ConsulEvent.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 19.06.17.
//
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulEvent: QuackModel {
    
    var id: String
    var name: String
    var payload: String?
    var nodeFilter: String
    var serviceFilter: String
    var tagFilter: String
    var version: Int
    var lTime: Int
    
    public required init?(json: JSON) {
        guard
            let id = json["ID"].string,
            let name = json["Name"].string,
            let version = json["Version"].int,
            let lTime = json["LTime"].int
        else { return nil }
        
        self.id = id
        self.name = name
        self.payload = json["Payload"].string
        self.nodeFilter = json["NodeFilter"].string ?? ""
        self.serviceFilter = json["ServiceFilter"].string ?? ""
        self.tagFilter = json["TagFilter"].string ?? ""
        self.version = version
        self.lTime = lTime
    }
    
}
