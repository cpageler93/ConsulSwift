//
//  ConsulHealthTests.swift
//  ConsulSwiftTests
//
//  Created by Christoph Pageler on 20.06.17.
//

import XCTest
@testable import ConsulSwift

class ConsulHealthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test2HealthChecksForNode() {
        let consul = Consul()
        let agentMembers = consul.agentMembers()
        switch agentMembers {
        case .success(let agentMembers):
            if let firstNode = agentMembers.first {
                let healthChecks = consul.healthChecksFor(node: firstNode.name)
                switch healthChecks {
                case .success(let healthChecks):
                    XCTAssertGreaterThanOrEqual(healthChecks.count, 1)
                case .failure(let error):
                    XCTAssertNil(error)
                }
            } else {
                XCTFail()
            }
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2HealthChecksForNodeAsync() {
        let consul = Consul()
        let agentMembers = consul.agentMembers()
        
        let expectation = self.expectation(description: "healthCkecksForNode")
        
        switch agentMembers {
        case .success(let agentMembers):
            if let firstNode = agentMembers.first {
                consul.healthChecksFor(node: firstNode.name, completion: { healthChecks in
                    switch healthChecks {
                    case .success(let healthChecks):
                        XCTAssertGreaterThanOrEqual(healthChecks.count, 1)
                    case .failure(let error):
                        XCTAssertNil(error)
                    }
                    
                    expectation.fulfill()
                })
            } else {
                XCTFail()
            }
        case .failure(let error):
            XCTAssertNil(error)
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2HealthNodesForService() {
        let consul = Consul()
        
        let service = ConsulAgentServiceInput(name: "myTestService")
        service.tags = ["superImportant"]
        consul.agentRegisterService(service)
        
        let healthNodes = consul.healthNodesFor(service: "myTestService",
                                                tag: "superImportant")
        switch healthNodes {
        case .success(let healthNodes):
            XCTAssertGreaterThanOrEqual(healthNodes.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
        
        consul.agentDeregisterService("myTestService")
    }
    
    func test2HealthNodesForServiceAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "healthCkecksForNode")
        
        let service = ConsulAgentServiceInput(name: "myTestService")
        service.tags = ["superImportant"]
        consul.agentRegisterService(service)
        
        consul.healthNodesFor(service: "myTestService", tag: "superImportant") { healthNodes in
            switch healthNodes {
            case .success(let healthNodes):
                XCTAssertGreaterThanOrEqual(healthNodes.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            consul.agentDeregisterService("myTestService")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testHealthListChecksInState() {
        let consul = Consul()
        let checks = consul.healthListChecksInState(.passing)
        switch checks {
        case .success(let checks):
            XCTAssertGreaterThanOrEqual(checks.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testHealthListChecksInStateAync() {
        let consul = Consul()
        let expectation = self.expectation(description: "healthChecksInState")
        consul.healthListChecksInState(.passing) { checks in
            switch checks {
            case .success(let checks):
                XCTAssertGreaterThanOrEqual(checks.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
}
