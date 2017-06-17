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
import SwiftyJSON

// https://www.consul.io/api/catalog.html
extension Consul {
    
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
    public func catalogNodesIn(datacenter: String) -> QuackResult<[ConsulCatalogNode]> {
        return respondWithArray(path: "/v1/catalog/nodes",
                                params: [
                                    "dc": datacenter
                                ],
                                encoding: URLEncoding.queryString,
                                model: ConsulCatalogNode.self)
    }
    
    /// Async version of `Consul.catalogNodesIn(datacenter: String)`
    ///
    /// - SeeAlso: `Consul.catalogNodesIn(datacenter: String)`
    /// - Parameter completion: completion block
    public func catalogNodesIn(datacenter: String,
                               completion: @escaping (QuackResult<[ConsulCatalogNode]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/catalog/nodes",
                              params: [
                                "dc": datacenter
                              ],
                              encoding: URLEncoding.queryString,
                              model: ConsulCatalogNode.self,
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
    public func catalogServicesIn(datacenter: String) -> QuackResult<[ConsulCatalogService]> {
        return respondWithArray(path: "/v1/catalog/services",
                                params: [
                                    "dc": datacenter
                                ],
                                encoding: URLEncoding.queryString,
                                parser: CatalogServicesParser(),
                                model: ConsulCatalogService.self)
    }
    
    /// Async version of `Consul.catalogServicesIn(datacenter: String)`
    ///
    /// - SeeAlso: `Consul.catalogServicesIn(datacenter: String)`
    /// - Parameter completion: completion block
    public func catalogServicesIn(datacenter: String,
                                  completion: @escaping (QuackResult<[ConsulCatalogService]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/catalog/services",
                              params: [
                                "dc": datacenter
                              ],
                              encoding: URLEncoding.queryString,
                              parser: CatalogServicesParser(),
                              model: ConsulCatalogService.self,
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
    public func catalogNodesWith(service: String) -> QuackResult<[ConsulCatalogNodeWithService]> {
        return respondWithArray(path: "/v1/catalog/service/\(service)",
                                model: ConsulCatalogNodeWithService.self)
    }
    
    /// Async version of `Consul.catalogNodesWith(service: String)`
    ///
    /// - SeeAlso: `Consul.catalogNodesWith(service: String)`
    /// - Parameter completion: completion block
    public func catalogNodesWith(service: String,
                                 completion: @escaping (QuackResult<[ConsulCatalogNodeWithService]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/catalog/service/\(service)",
                              model: ConsulCatalogNodeWithService.self,
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
    public func catalogServicesFor(node: String) -> QuackResult<ConsulCatalogNodeWithServices> {
        return respond(path: "/v1/catalog/node/\(node)",
                       model: ConsulCatalogNodeWithServices.self)
    }
    
    /// Async version of `Consul.catalogServicesFor(node: String)`
    ///
    /// - SeeAlso: `Consul.catalogServicesFor(node: String)`
    /// - Parameter completion: completion block
    public func catalogServicesFor(node: String,
                                   completion: @escaping (QuackResult<ConsulCatalogNodeWithServices>) -> (Void)) {
        respondAsync(path: "/v1/catalog/node/\(node)",
                     model: ConsulCatalogNodeWithServices.self,
                     completion: completion)
    }
}

public class CatalogServicesParser : QuackCustomArrayParser {
    
    public func parseArray<Model>(json: JSON, model: Model.Type) -> QuackResult<[Model]> where Model : QuackModel {
        if let dictionary = json.dictionary {
            var result: [Model] = []
            for (key, value) in dictionary {
                if let model = ConsulCatalogService(name: key, json: value) {
                    result.append(model as! Model)
                }
            }
            return QuackResult.success(result)
        }
        
        return QuackResult.failure(QuackError.JSONParsingError)
    }

}
