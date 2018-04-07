//
//  Consul+Catalog.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import Foundation
import Quack

// API Documentation:
// https://www.consul.io/api/catalog.html

public extension Consul {
    
    // MARK: - Datacenters
    
    
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
    public func catalogDatacenters() -> Result<[CatalogDatacenter]> {
        return respondWithArray(path: "/v1/catalog/datacenters",
                                model: CatalogDatacenter.self)
    }
    
    /// Async version of `Consul.catalogDatacenters()`
    ///
    /// - SeeAlso: `Consul.catalogDatacenters()`
    /// - Parameter completion: completion block
    public func catalogDatacenters(completion: @escaping (Result<[CatalogDatacenter]>) -> (Void)) {
        return respondWithArrayAsync(path: "/v1/catalog/datacenters",
                                     model: CatalogDatacenter.self,
                                     completion: completion)
    }
    
    // MARK: Nodes/Services in Datacenter
    
    
    /// This endpoint and returns the nodes registered in a given datacenter.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter datacenter: Datacenter ID
    /// - Returns: Result with Catalog Node
    ///
    /// [apidoc]: https://www.consul.io/api/catalog.html#list-nodes
    ///
    public func catalogNodesIn(datacenter: String) -> Result<[CatalogNode]> {
        let queryParams = [
            "dc": datacenter
        ]
        return respondWithArray(path: buildPath("/v1/catalog/nodes", withParams: queryParams),
                                model: CatalogNode.self)
    }
    
    /// Async version of `Consul.catalogNodesIn(datacenter: String)`
    ///
    /// - SeeAlso: `Consul.catalogNodesIn(datacenter: String)`
    /// - Parameter completion: completion block
    public func catalogNodesIn(datacenter: String,
                               completion: @escaping (Result<[CatalogNode]>) -> (Void)) {
        let queryParams = [
            "dc": datacenter
        ]
        respondWithArrayAsync(path: buildPath("/v1/catalog/nodes", withParams: queryParams),
                              model: CatalogNode.self,
                              completion: completion)
    }
    
    /// This endpoint returns the services registered in a given datacenter.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter datacenter: datacenter
    /// - Returns: Result with Services
    ///
    /// [apidoc]: https://www.consul.io/api/catalog.html#list-services
    ///
    public func catalogServicesIn(datacenter: String) -> Result<[CatalogService]> {
        let queryParams = [
            "dc": datacenter
        ]
        return respondWithArray(path: buildPath("/v1/catalog/services", withParams: queryParams),
                                parser: CatalogServicesParser(),
                                model: CatalogService.self)
    }
    
    /// Async version of `Consul.catalogServicesIn(datacenter: String)`
    ///
    /// - SeeAlso: `Consul.catalogServicesIn(datacenter: String)`
    /// - Parameter completion: completion block
    public func catalogServicesIn(datacenter: String,
                                  completion: @escaping (Result<[CatalogService]>) -> (Void)) {
        let queryParams = [
            "dc": datacenter
        ]
        respondWithArrayAsync(path: buildPath("/v1/catalog/services", withParams: queryParams),
                              parser: CatalogServicesParser(),
                              model: CatalogService.self,
                              completion: completion)
    }
    
    // MARK: Nodes <-> Service
    
    
    /// This endpoint returns the nodes providing a service in a given datacenter.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter service: service
    /// - Returns: Result with Nodes with Service
    ///
    /// [apidoc]: https://www.consul.io/api/catalog.html#list-nodes-for-service
    ///
    public func catalogNodesWith(service: String) -> Result<[CatalogNodeWithService]> {
        return respondWithArray(path: "/v1/catalog/service/\(service)",
                                model: CatalogNodeWithService.self)
    }
    
    /// Async version of `Consul.catalogNodesWith(service: String)`
    ///
    /// - SeeAlso: `Consul.catalogNodesWith(service: String)`
    /// - Parameter completion: completion block
    public func catalogNodesWith(service: String,
                                 completion: @escaping (Result<[CatalogNodeWithService]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/catalog/service/\(service)",
                              model: CatalogNodeWithService.self,
                              completion: completion)
    }
    
    /// This endpoint returns the node's registered services.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter node: node
    /// - Returns: Result With Nodes with Services
    ///
    /// [apidoc]: https://www.consul.io/api/catalog.html#list-services-for-node
    ///
    public func catalogServicesFor(node: String) -> Result<CatalogNodeWithServices> {
        return respond(path: "/v1/catalog/node/\(node)",
                       model: CatalogNodeWithServices.self)
    }
    
    /// Async version of `Consul.catalogServicesFor(node: String)`
    ///
    /// - SeeAlso: `Consul.catalogServicesFor(node: String)`
    /// - Parameter completion: completion block
    public func catalogServicesFor(node: String,
                                   completion: @escaping (Result<CatalogNodeWithServices>) -> (Void)) {
        respondAsync(path: "/v1/catalog/node/\(node)",
                     model: CatalogNodeWithServices.self,
                     completion: completion)
    }
}

internal class CatalogServicesParser : Quack.CustomArrayParser {
    
    func parseArray<Model>(data: Data, model: Model.Type) -> Quack.Result<[Model]> where Model : Quack.DataModel {
        let json = JSON(data: data)
        
        if let dictionary = json.dictionary {
            var result: [Model] = []
            for (key, value) in dictionary {
                if let model = Consul.CatalogService(name: key, json: value) {
                    result.append(model as! Model)
                }
            }
            return .success(result)
        }
        
        return .failure(.jsonParsingError)
    }

}
