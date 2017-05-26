//
//  ConsulAgentTests.swift
//  ConsulSwift
//
//  Created by Christoph on 17.05.17.
//
//

import XCTest
@testable import ConsulSwift

class ConsulAgentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Members
    
    func testAgentMembers() {
        let consul = Consul()
        let members = consul.agentMembers()
        switch members {
        case .success(let members):
            XCTAssertEqual(members.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentMembersAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentMembers")
        consul.agentMembers { members in
            switch members {
            case .success(let members):
                XCTAssertEqual(members.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - Configuration
    
    func testAgentReadConfiguration() {
        let consul = Consul()
        let config = consul.agentReadConfiguration()
        switch config {
        case .success(let config):
            XCTAssertNotNil(config)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentReadConfigurationAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentReadConfiguration")
        consul.agentReadConfiguration { config in
            switch config {
            case .success(let config):
                XCTAssertNotNil(config)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - Reload
    
    func testAgentReload() {
        let consul = Consul()
        let reload = consul.agentReload()
        switch reload {
        case .success:
            print("reload success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentReloadAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentReload")
        consul.agentReload { reload in
            switch reload {
            case .success:
                print("reload success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - Maintenance
    
    func testAgentMaintenanceEnable() {
        let consul = Consul()
        let maintenance = consul.agentMaintenance(enable: true, reason: "UnitTest")
        switch maintenance {
        case .success:
            print("enabled maintenance success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentMaintenanceEnableAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentMaintenanceEnable")
        consul.agentMaintenance(enable: true, reason: "UnitTest") { maintenance in
            switch maintenance {
            case .success:
                print("enabled maintenance success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testAgentMaintenanceDisable() {
        let consul = Consul()
        let maintenance = consul.agentMaintenance(enable: false, reason: "UnitTest")
        switch maintenance {
        case .success:
            print("disable maintenance success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentMaintenanceDisableAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentMaintenanceDisable")
        consul.agentMaintenance(enable: false, reason: "UnitTest") { maintenance in
            switch maintenance {
            case .success:
                print("disable maintenance success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - leave

    // this test will shutdown consul and possible other tests will fail
//    func testAgentLeave() {
//        let consul = Consul()
//        let leave = consul.agentLeave()
//        switch leave {
//        case .success:
//            print("leave success")
//        case .failure(let error):
//            XCTAssertNil(error)
//        }
//    }
    
//    func testAgentLeaveAsync() {
//        let consul = Consul()
//        let expectation = self.expectation(description: "agentLeave")
//        consul.agentLeave() { leave in
//            switch leave {
//            case .success:
//                print("leave success")
//            case .failure(let error):
//                XCTAssertNil(error)
//            }
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 15, handler: nil)
//    }
    
    // MARK: - Checks
    
    func testAgentChecks() {
        let consul = Consul()
        let checks = consul.agentChecks()
        switch checks {
        case .success(let checks):
            XCTAssertGreaterThan(checks.count, 0)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentChecksAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentChecks")
        consul.agentChecks() { checks in
            switch checks {
            case .success(let checks):
                XCTAssertGreaterThan(checks.count, 0)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
}
