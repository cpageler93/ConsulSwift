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
extension Consul {

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

}
