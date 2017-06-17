//
//  ConsulCatalogTests.swift
//  ConsulSwift
//
//  Created by Christoph on 15.06.17.
//
//

import XCTest
@testable import ConsulSwift

class ConsulCatalogTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCatalogDatacenters() {
        let consul = Consul()
        let datacenters = consul.catalogDatacenters()
        switch datacenters {
        case .success(let datacenters):
            XCTAssertEqual(datacenters.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testCatalogDatacentersAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "catalogDatacenters")
        consul.catalogDatacenters { datacenters in
            switch datacenters {
            case .success(let datacenters):
                XCTAssertEqual(datacenters.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCatalogNodesInDatacenter() {
        let consul = Consul()
        let nodes = consul.catalogNodesIn(datacenter: "fra1")
        switch nodes {
        case .success(let nodes):
            XCTAssertEqual(nodes.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testCatalogNodesInDatacenterAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "catalogNodesInDatacenter")
        consul.catalogNodesIn(datacenter: "fra1") { nodes in
            switch nodes {
            case .success(let nodes):
                XCTAssertEqual(nodes.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCatalogServicesInDatacenter() {
        let consul = Consul()
        let services = consul.catalogServicesIn(datacenter: "fra1")
        switch services {
        case .success(let services):
            XCTAssertGreaterThanOrEqual(services.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testCatalogServicesInDatacenterAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "catalogServicesInDatacenter")
        consul.catalogServicesIn(datacenter: "fra1") { services in
            switch services {
            case .success(let services):
                XCTAssertGreaterThanOrEqual(services.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testCatalogNodesWithService() {
        let consul = Consul()
        let service = ConsulAgentServiceInput(name: "testService1")
        consul.agentRegisterService(service)
        
        let nodes = consul.catalogNodesWith(service: "testService1")
        switch nodes {
        case .success(let nodes):
            XCTAssertGreaterThanOrEqual(nodes.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testCatalogNodesWithServiceAsync() {
        let consul = Consul()
        let service = ConsulAgentServiceInput(name: "testService1")
        consul.agentRegisterService(service)
        
        let expectation = self.expectation(description: "catalogServicesInDatacenter")
        
        consul.catalogNodesWith(service: "testService1") { nodes in
            switch nodes {
            case .success(let nodes):
                XCTAssertGreaterThanOrEqual(nodes.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
}
