//
//  Consul+Health.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 20.06.17.
//

import Foundation
import Quack
import Alamofire
import SwiftyJSON

// https://www.consul.io/api/health.html
public extension Consul {

    // MARK: - Health
    
    
    /// This endpoint returns the checks specific to the node provided on the path.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - node: name of node
    ///   - datacenter: datacenter
    /// - Returns: Result with checks
    ///
    ///  [apidoc]: https://www.consul.io/api/health.html#list-checks-for-node
    ///
    public func healthChecksFor(node: String,
                                datacenter: String? = nil) -> QuackResult<[ConsulAgentCheckOutput]> {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respondWithArray(path: "/v1/health/node/\(node)",
                                params: params,
                                model: ConsulAgentCheckOutput.self)
    }
    
    /// Async version of `Consul.healthChecksFor(node: String, datacenter: String? = nil)`
    ///
    /// - SeeAlso: `Consul.healthChecksFor(node: String, datacenter: String? = nil)`
    /// - Parameter completion: completion block
    public func healthChecksFor(node: String,
                                datacenter: String? = nil,
                                completion: @escaping (QuackResult<[ConsulAgentCheckOutput]>) -> (Void)) {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondWithArrayAsync(path: "/v1/health/node/\(node)",
                              params: params,
                              model: ConsulAgentCheckOutput.self,
                              completion: completion)
    }
    
    /// This endpoint returns the nodes providing the service indicated on the path.
    /// Users can also build in support for dynamic load balancing and other features by incorporating the use of health checks.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - service: Specifies the service to list services for.
    ///   - passing: Specifies the datacenter to query. This will default to the datacenter of the agent being queried.
    ///   - tag: Specifies the list of tags to filter the list.
    ///   - datacenter: Specifies the datacenter to query. This will default to the datacenter of the agent being queried.
    ///   - near: Specifies a node name to sort the node list in ascending order based on the estimated round trip time from that node. Passing ?near=_agent will use the agent's node for the sort.
    /// - Returns: Result with Nodes
    ///
    ///  [apidoc]: https://www.consul.io/api/health.html#list-nodes-for-service
    ///
    public func healthNodesFor(service: String,
                               passing: Bool? = true,
                               tag: String? = nil,
                               datacenter: String? = nil,
                               near: String? = "_agent") -> QuackResult<[ConsulCatalogNodeWithServiceAndChecks]> {
        var params: [String: String] = [:]
        if let passing = passing { params["passing"] = String(passing) }
        if let tag = tag { params["tag"] = tag }
        if let datacenter = datacenter { params["dc"] = datacenter }
        if let near = near { params["near"] = near }
        
        return respondWithArray(path: "/v1/health/service/\(service)",
                                params: params,
                                model: ConsulCatalogNodeWithServiceAndChecks.self)
    }
    
    /// Async version of `Consul.healthNodesFor(service: String, ...)`
    ///
    /// - SeeAlso: `Consul.healthNodesFor(service: String, ...)`
    /// - Parameter completion: completion block
    public func healthNodesFor(service: String,
                               passing: Bool? = true,
                               tag: String? = nil,
                               datacenter: String? = nil,
                               near: String? = nil,
                               completion: @escaping (QuackResult<[ConsulCatalogNodeWithServiceAndChecks]>) -> (Void)) {
        var params: [String: String] = [:]
        if let passing = passing { params["passing"] = String(passing) }
        if let tag = tag { params["tag"] = tag }
        if let datacenter = datacenter { params["dc"] = datacenter }
        if let near = near { params["near"] = near }
        
        return respondWithArrayAsync(path: "/v1/health/service/\(service)",
                                     params: params,
                                     model: ConsulCatalogNodeWithServiceAndChecks.self,
                                     completion: completion)
    }
    
    
    /// This endpoint returns the checks in the state provided on the path.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - state: Specifies the state to query. Supported states are any, passing, warning, or critical.
    ///   - datacenter: Specifies the datacenter to query. This will default to the datacenter of the agent being queried.
    ///   - near: Specifies a node name to sort the node list in ascending order based on the estimated round trip time from that node. Passing ?near=_agent will use the agent's node for the sort.
    /// - Returns: Result with checks
    ///
    ///  [apidoc]: https://www.consul.io/api/health.html#list-checks-in-state
    ///
    public func healthListChecksInState(_ state: ConsulAgentCheckStatus,
                                        datacenter: String? = nil,
                                        near: String? = "_agent") -> QuackResult<[ConsulAgentCheckOutput]> {
        return respondWithArray(path: "/v1/health/state/\(state.rawValue)",
                                model: ConsulAgentCheckOutput.self)
    }
    
    /// Async version of `Consul.healthListChecksInState(_ state: ConsulAgentCheckStatus, ...)`
    ///
    /// - SeeAlso: `Consul.healthListChecksInState(_ state: ConsulAgentCheckStatus, ...)`
    /// - Parameter completion: completion block
    public func healthListChecksInState(_ state: ConsulAgentCheckStatus,
                                        datacenter: String? = nil,
                                        near: String? = "_agent",
                                        completion: @escaping (QuackResult<[ConsulAgentCheckOutput]>) -> (Void)) {
        return respondWithArrayAsync(path: "/v1/health/state/\(state.rawValue)",
                                     model: ConsulAgentCheckOutput.self,
                                     completion: completion)
    }

}
