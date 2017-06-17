//
//  ConsulAgentMember.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 16.05.17.
//
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulAgentMember: QuackModel {
    var name: String
    var address: String
    var port: Int
    var tags: [String: String]
    
    required public init?(json: JSON) {
        guard
            let name = json["Name"].string,
            let address = json["Addr"].string,
            let port = json["Port"].int else { return nil }
        self.name = name
        self.address = address
        self.port = port
        
        var tags: [String: String] = [:]
        if let jsonTags = json["Tags"].dictionary {
            for (key, value) in jsonTags {
                if let valueString = value.string {
                    tags[key] = valueString
                }
            }
        }
        self.tags = tags
    }
    
    public func id() -> String? {
        return self.tags["id"]
    }
}
