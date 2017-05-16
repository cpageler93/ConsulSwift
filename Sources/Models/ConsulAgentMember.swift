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
    
    required public init?(json: JSON) {
        guard
            let name = json["Name"].string,
            let address = json["Address"].string,
            let port = json["Port"].int else { return nil }
        self.name = name
        self.address = address
        self.port = port
    }
}
