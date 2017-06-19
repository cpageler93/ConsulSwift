//
//  Consul.swift
//  ConsulSwift
//
//  Created by Christoph on 16.05.17.
//
//

import Foundation
import SwiftyJSON
import Quack

public class Consul: QuackClient {

    public init() {
        super.init(url: URL(string: "http://localhost:8500")!)
    }
    
    public init(url: URL) {
        super.init(url: url)
    }
    
}

extension Bool: QuackModel {
    public init?(json: JSON) {
        guard let bool = json.bool else { return nil }
        self.init(bool)
    }
}

extension String: QuackModel {
    public init?(json: JSON) {
        guard let str = json.string else { return nil }
        self.init(str)
    }
}
