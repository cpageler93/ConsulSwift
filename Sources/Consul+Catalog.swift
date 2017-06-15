//
//  Consul+Catalog.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import Foundation
import Quack
import Alamofire

// https://www.consul.io/api/catalog.html
extension Consul {
    
    // MARK: - Catalog
    
    public func catalogDatacenters() -> QuackResult<[ConsulCatalogDatacenter]> {
        return respondWithArray(path: "/v1/catalog/datacenters",
                                model: ConsulCatalogDatacenter.self)
    }
    
    public func catalogDatacenters(completion: @escaping (QuackResult<[ConsulCatalogDatacenter]>) -> (Void)) {
        return respondWithArrayAsync(path: "/v1/catalog/datacenters",
                                     model: ConsulCatalogDatacenter.self,
                                     completion: completion)
    }
    
}
