//
//  ConsulAgentService.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 14.06.17.
//

import Foundation
import Quack
import SwiftyJSON

public class ConsulAgentServiceOutput: QuackModel {
    
    public var id: String
    public var service: String
    public var tags: [String]
    public var address: String
    public var port: Int
    
    public required init?(json: JSON) {
        guard
            let id = json["ID"].string,
            let service = json["Service"].string,
            let address = json["Address"].string,
            let port = json["Port"].int
            else { return nil }
        self.id = id
        self.service = service
        
        var tags: [String] = []
        if let jsonTags = json["Tags"].array {
            for jsonTag in jsonTags {
                if let jsonTagString = jsonTag.string {
                    tags.append(jsonTagString)
                }
            }
        }
        self.tags = tags
        self.address = address
        self.port = port
    }
}
