//
//  ConsulEvent.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 19.06.17.
//
//

import Foundation
import Quack


public extension Consul {
    
    public class Event: Quack.Model {
        
        public var id: String
        public var name: String
        public var payload: String?
        public var nodeFilter: String
        public var serviceFilter: String
        public var tagFilter: String
        public var version: Int
        public var lTime: Int
        
        public required init?(json: JSON) {
            guard let id = json["ID"].string,
                let name = json["Name"].string,
                let version = json["Version"].int,
                let lTime = json["LTime"].int
            else {
                return nil
            }
            
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
    
}
