//
//  Consul+KVStore.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 19.06.17.
//

import Foundation
import Quack
import Alamofire
import SwiftyJSON

// https://www.consul.io/api/kv.html
extension Consul {

    // MARK: - KV Store
    
    public func listKeys(datacenter: String? = nil) -> QuackResult<[String]> {
        var params: [String: String] = ["keys": "true"]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respondWithArray(path: "/v1/kv/",
                                params: params,
                                model: String.self)
    }
    
    public func listKeys(datacenter: String? = nil,
                         completion: @escaping (QuackResult<[String]>) -> (Void) ) {
        var params: [String: String] = ["keys": "true"]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondWithArrayAsync(path: "/v1/kv/",
                              params: params,
                              model: String.self,
                              completion: completion)
    }
    
    public func readKey(_ key: String,
                        datacenter: String? = nil) -> QuackResult<ConsulKeyValuePair> {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respond(path: "/v1/kv/\(key)",
                       params: params,
                       model: ConsulKeyValuePair.self)
    }
    
    public func readKey(_ key: String,
                        datacenter: String? = nil,
                        completion: @escaping (QuackResult<ConsulKeyValuePair>) -> (Void)) {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondAsync(path: "/v1/kv/\(key)",
                     params: params,
                     model: ConsulKeyValuePair.self,
                     completion: completion)
    }
    
    public func writeKey(_ key: String,
                         value: String,
                         datacenter: String? = nil
                         ) -> QuackResult<Bool> {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        return respond(method: .put,
                       path: "/v1/kv/\(key)",
                       params: params,
                       encoding: URLEncoding.queryString,
                       model: Bool.self,
                       urlRequestModification: { (request) -> (URLRequest) in
                        var newRequest = request
                        newRequest.httpBody = value.data(using: String.Encoding.utf8)
                        return newRequest
        })
    }
    
    public func writeKey(_ key: String,
                         value: String,
                         datacenter: String? = nil,
                         completion: @escaping (QuackResult<Bool>) -> (Void)) {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        
        respondAsync(method: .put,
                     path: "/v1/kv/\(key)",
                     params: params,
                     encoding: URLEncoding.queryString,model: Bool.self,
                     urlRequestModification: { (request) -> (URLRequest) in
                        var newRequest = request
                        newRequest.httpBody = value.data(using: String.Encoding.utf8)
                        return newRequest
                     },
                     completion: completion)
    }
    
    public func deleteKey(_ key: String) -> QuackResult<Bool> {
        return respond(method: .delete,
                       path: "/v1/kv/\(key)",
                    model: Bool.self)
    }
    
    public func deleteKey(_ key: String,
                          completion: @escaping (QuackResult<Bool>) -> (Void)) {
        return respondAsync(method: .delete,
                            path: "/v1/kv/\(key)",
                            model: Bool.self,
                            completion: completion)
    }
}
