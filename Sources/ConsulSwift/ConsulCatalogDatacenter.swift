//
//  ConsulCatalogDatacenter.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import Foundation
import Quack


public extension Consul {
    
    public class CatalogDatacenter: Quack.Model {
        
        public var name: String
        
        public required init?(json: JSON) {
            guard let name = json.string else { return nil }
            self.name = name
        }
        
    }

}
