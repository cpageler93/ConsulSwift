//
//  Consul+Events.swift
//  ConsulSwift
//
//  Created by Christoph Pageler on 19.06.17.
//

import Foundation
import Quack

// API Documentation:
// https://www.consul.io/api/event.html

public extension Consul {

    // MARK: - Events
    
    
    /// This endpoint triggers a new user event.
    ///
    /// [API Documentation][apidoc]
    ///
    /// - Parameters:
    ///   - name: Specifies the name of the event to fire. This is specified as part of the URL. This name must not start with an underscore, since those are reserved for Consul internally.
    ///   - datacenter: Specifies the datacenter to query. This will default to the datacenter of the agent being queried. This is specified as part of the URL as a query parameter
    ///   - node: Specifies a regular expression to filter by node name. This is specified as part of the URL as a query parameter.
    ///   - service: Specifies a regular expression to filter by service name. This is specified as part of the URL as a query parameter.
    ///   - tag: Specifies a regular expression to filter by tag. This is specified as part of the URL as a query parameter.
    /// - Returns: Result with fired Event
    ///
    ///  [apidoc]: https://www.consul.io/api/event.html#fire-event
    /// 
    @discardableResult
    public func eventFire(name: String,
                          datacenter: String? = nil,
                          node: String? = nil,
                          service: String? = nil,
                          tag: String? = nil) -> Quack.Result<Event> {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        if let node = node { params["node"] = node }
        if let service = service { params["service"] = service }
        if let tag = tag { params["tag"] = tag }
        
        return respond(method: .put,
                       path: buildPath("/v1/event/fire/\(name)", withParams: params),
                       model: Event.self)
    }
    
    /// Async version of `Consul.eventFire(name, ...)`
    ///
    /// - SeeAlso: `Consul.eventFire(name, ...)`
    /// - Parameter completion: completion block
    public func eventFire(name: String,
                          datacenter: String? = nil,
                          node: String? = nil,
                          service: String? = nil,
                          tag: String? = nil,
                          completion: @escaping (Quack.Result<Event>) -> (Void)) {
        var params: [String: String] = [:]
        if let datacenter = datacenter { params["dc"] = datacenter }
        if let node = node { params["node"] = node }
        if let service = service { params["service"] = service }
        if let tag = tag { params["tag"] = tag }
        
        return respondAsync(method: .put,
                            path: buildPath("/v1/event/fire/\(name)", withParams: params),
                            model: Event.self,
                            completion: completion)
    }
    
    /// This endpoint returns the most recent events known by the agent.
    /// As a consequence of how the event command works, each agent may have a different view of the events.
    ///  Events are broadcast using the gossip protocol,
    /// so they have no global ordering nor do they make a promise of delivery.
    ///
    /// - Parameters:
    ///   - name: Specifies the name of the event to filter.
    ///   - node: Specifies a regular expression to filter by node name.
    ///   - service: Specifies a regular expression to filter by service name.
    ///   - tag: Specifies a regular expression to filter by tag.
    /// - Returns: Result with Events
    ///
    ///  [apidoc]: https://www.consul.io/api/event.html#list-events
    ///
    public func eventList(name: String? = nil,
                          node: String? = nil,
                          service: String? = nil,
                          tag: String? = nil) -> Quack.Result<[Event]> {
        return respondWithArray(path: "/v1/event/list",
                                model: Event.self)
    }
    
    /// Async version of `Consul.eventList(name, ...)`
    ///
    /// - SeeAlso: `Consul.eventList(name, ...)`
    /// - Parameter completion: completion block
    public func eventList(name: String? = nil,
                          node: String? = nil,
                          service: String? = nil,
                          tag: String? = nil,
                          completion: @escaping (Quack.Result<[Event]>) -> (Void)) {
        respondWithArrayAsync(path: "/v1/event/list",
                              model: Event.self,
                              completion: completion)
    }

}
