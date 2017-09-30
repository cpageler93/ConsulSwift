//
//  Consul+KVStore.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 19.06.17.
//

import Foundation
import Quack
import KituraNet
import SwiftyJSON

// https://www.consul.io/api/kv.html
public extension Consul {

    // MARK: - KV Store
    
    
    /// Using the key listing method may be suitable when you do not need the values or flags or want to implement a key-space explorer.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter datacenter: datacenter
    /// - Returns: Result with keys
    ///
    ///  [apidoc]: https://www.consul.io/api/kv.html#keys-response
    ///
    public func listKeys(datacenter: String? = nil) -> QuackResult<[String]> {
        var params: [String: String] = ["keys": "true"]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respondWithArray(path: buildPath("/v1/kv/", withParams: params),
                                model: String.self)
    }
    
    /// Async version of `Consul.listKeys(datacenter: String)`
    ///
    /// - SeeAlso: `Consul.listKeys(datacenter: String)`
    /// - Parameter completion: completion block
    public func listKeys(datacenter: String? = nil,
                         completion: @escaping (QuackResult<[String]>) -> (Void) ) {
        var params: [String: String] = ["keys": "true"]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondWithArrayAsync(path: buildPath("/v1/kv/", withParams: params),
                              model: String.self,
                              completion: completion)
    }
    
    /// This endpoint returns the specified key. If no key exists at the given path,
    /// a 404 is returned instead of a 200 response.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - key: key
    ///   - datacenter: datacenter
    /// - Returns: Result with key-value pair
    ///
    ///  [apidoc]: https://www.consul.io/api/kv.html#read-key
    ///
    public func readKey(_ key: String,
                        datacenter: String? = nil) -> QuackResult<ConsulKeyValuePair> {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respond(path: "/v1/kv/\(key)",
                       body: params,
                       model: ConsulKeyValuePair.self)
    }
    
    /// Async version of `Consul.readKey(_ key: string, datacenter: String)`
    ///
    /// - SeeAlso: `Consul.readKey(_ key: string, datacenter: String)`
    /// - Parameter completion: completion block
    public func readKey(_ key: String,
                        datacenter: String? = nil,
                        completion: @escaping (QuackResult<ConsulKeyValuePair>) -> (Void)) {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondAsync(path: "/v1/kv/\(key)",
                     body: params,
                     model: ConsulKeyValuePair.self,
                     completion: completion)
    }
    
    
    /// Creates or updates key
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - key: key
    ///   - value: value
    ///   - datacenter: datacenter
    /// - Returns: Result with Book
    ///
    ///  [apidoc]: https://www.consul.io/api/kv.html#create-update-key
    ///
    @discardableResult
    public func writeKey(_ key: String,
                         value: String,
                         datacenter: String? = nil
                         ) -> QuackResult<Bool> {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respond(method: .put,
                       path: buildPath("/v1/kv/\(key)", withParams: params),
                       model: Bool.self,
                       requestModification: { (request) -> (ClientRequest) in
                        request.write(from: value)
                        return request
        })
    }
    
    /// Async version of `Consul.writeKey(_ key: string, value: String, datacenter: String)`
    ///
    /// - SeeAlso: `Consul.writeKey(_ key: string, value: String, datacenter: String)`
    /// - Parameter completion: completion block
    public func writeKey(_ key: String,
                         value: String,
                         datacenter: String? = nil,
                         completion: @escaping (QuackResult<Bool>) -> (Void)) {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondAsync(method: .put,
                     path: buildPath("/v1/kv/\(key)", withParams: params),
                     model: Bool.self,
                     requestModification: { (request) -> (ClientRequest) in
                        request.write(from: value)
                        return request
                     },
                     completion: completion)
    }
    
    /// This endpoint deletes a single key or all keys sharing a prefix.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameter key: key
    /// - Returns: Result with Bool
    ///
    ///  [apidoc]: https://www.consul.io/api/kv.html#delete-key
    ///
    @discardableResult
    public func deleteKey(_ key: String) -> QuackResult<Bool> {
        return respond(method: .delete,
                       path: "/v1/kv/\(key)",
                       model: Bool.self)
    }
    
    /// Async version of `Consul.deleteKey(_ key: string)`
    ///
    /// - SeeAlso: `Consul.deleteKey(_ key: string)`
    /// - Parameter completion: completion block
    public func deleteKey(_ key: String,
                          completion: @escaping (QuackResult<Bool>) -> (Void)) {
        return respondAsync(method: .delete,
                            path: "/v1/kv/\(key)",
                            model: Bool.self,
                            completion: completion)
    }
}
