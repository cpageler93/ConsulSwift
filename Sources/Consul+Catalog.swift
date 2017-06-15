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
    
    
    /// This endpoint returns the list of all known datacenters.
    /// The datacenters will be sorted in ascending order based on the estimated median round
    /// trip time from the server to the servers in that datacenter.
    ///
    /// This endpoint does not require a cluster leader and will succeed even during an availability outage.
    /// Therefore, it can be used as a simple check to see if any Consul servers are routable.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Returns: Result with Catalog Datacenters
    ///
    /// [apidoc]: https://www.consul.io/api/catalog.html#list-datacenters
    ///
    public func catalogDatacenters() -> QuackResult<[ConsulCatalogDatacenter]> {
        return respondWithArray(path: "/v1/catalog/datacenters",
                                model: ConsulCatalogDatacenter.self)
    }
    
    /// Async version of `Consul.catalogDatacenters()`
    ///
    /// - SeeAlso: `Consul.catalogDatacenters()`
    /// - Parameter completion: completion block
    public func catalogDatacenters(completion: @escaping (QuackResult<[ConsulCatalogDatacenter]>) -> (Void)) {
        return respondWithArrayAsync(path: "/v1/catalog/datacenters",
                                     model: ConsulCatalogDatacenter.self,
                                     completion: completion)
    }
    
}
