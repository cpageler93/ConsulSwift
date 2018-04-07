//
//  Consul.swift
//  ConsulSwift
//
//  Created by Christoph on 16.05.17.
//
//

import Foundation
import Quack


public class Consul: Quack.Client {

    public init() {
        super.init(url: URL(string: "http://localhost:8500")!)
    }
    
    public init(url: URL) {
        super.init(url: url)
    }
    
    public typealias Result = Quack.Result
    
}

// MARK: - Consul Extensions for Standard Types

extension Bool: Quack.Model {
    
    public init?(json: JSON) {
        guard let bool = json.bool else { return nil }
        self.init(bool)
    }
    
}

extension String: Quack.Model {
    
    public init?(json: JSON) {
        guard let str = json.string else { return nil }
        self.init(str)
    }
    
}
