//
//  Consul.swift
//  ConsulSwift
//
//  Created by Christoph on 16.05.17.
//
//

import Foundation
import Quack

public class Consul: QuackClient {

    public init() {
        super.init(url: URL(string: "http://localhost:8500")!)
    }
    
    public init(url: URL) {
        super.init(url: url)
    }
    
}
