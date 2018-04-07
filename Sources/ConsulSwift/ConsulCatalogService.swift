//
//  ConsulCatalogService.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import Foundation
import Quack


public extension Consul {
    
    public class CatalogService: Quack.Model {
        
        public var name: String
        public var tags: [String]
        
        public required init?(json: JSON) {
            fatalError("please use init with name")
        }
        
        public init?(name: String, json: JSON) {
            self.name = name
            
            var tags: [String] = []
            if let jsonTags = json.array {
                for jsonTag in jsonTags {
                    if let jsonTagString = jsonTag.string {
                        tags.append(jsonTagString)
                    }
                }
            }
            self.tags = tags
        }
        
    }
    
}
