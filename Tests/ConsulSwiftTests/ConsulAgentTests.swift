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
    
    func test3AgentChecks() {
        let consul = Consul()
        let checks = consul.agentChecks()
        switch checks {
        case .success(let checks):
            XCTAssertGreaterThan(checks.count, 0)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test3AgentChecksAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "agentChecks")
        consul.agentChecks { checks in
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
    
    func test1AgentRegisterCheckMinimal() {
        let consul = Consul()
        let check = ConsulAgentCheckInput(name: "TestCheck", ttl: "60s")
        let result = consul.agentRegisterCheck(check)
        switch result {
        case .success:
            print("register success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test1AgentRegisterCheckAsync() {
        let consul = Consul()
        let check = ConsulAgentCheckInput(name: "TestCheckAsync", ttl: "60s")
        check.id = "TestCheckAsync"
        
        let expectation = self.expectation(description: "agentCheckRegister")
        consul.agentRegisterCheck(check) { result in
            switch result {
            case .success:
                print("register success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test1AgentRegisterCheckMaximal() {
        let consul = Consul()
        let check = ConsulAgentCheckInput(name: "MemTest", ttl: "15s")
        check.id = "MemTestUnitTests"
        check.notes = "Hello these are some notes"
        check.deregisterCriticalServiceAfter = "90m"
        check.script = "/usr/local/bin/check_mem.py"
        check.dockerContainerID = "f972c95ebf0e"
        check.http = "http://example.com"
        check.tcp = "example.com:22"
        check.interval = "10s"
        check.tlsSkipVerify = true
        check.status = .passing
        
        let result = consul.agentRegisterCheck(check)
        switch result {
        case .success:
            print("register success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test4AgentDeregisterCheck() {
        let consul = Consul()
        let deregister = consul.agentDeregisterCheck(id: "TestCheckAsync")
        switch deregister {
        case .success:
            print("deregister succes")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test4AgentDeregisterCheckAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentCheckDeregister")
        consul.agentDeregisterCheck(id: "MemTestUnitTests") { deregisteer in
            switch deregisteer {
            case .success:
                print("deregister success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2AgentCheckPass() {
        let consul = Consul()
        let checkPass = consul.agentCheckPass(id: "MemTest")
        switch checkPass {
        case .success:
            print("check pass success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2AgentCheckPassAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentCheckPass")
        consul.agentCheckPass(id: "MemTest") { checkPass in
            switch checkPass {
            case .success:
                print("check pass success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2AgentCheckWarn() {
        let consul = Consul()
        let checkPass = consul.agentCheckWarn(id: "MemTest", note: "Hello this is Test")
        switch checkPass {
        case .success:
            print("check warn success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2AgentCheckWarnAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentCheckPass")
        consul.agentCheckWarn(id: "MemTest", note: "Hello this is Test") { checkPass in
            switch checkPass {
            case .success:
                print("check warn success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2AgentCheckFail() {
        let consul = Consul()
        let checkPass = consul.agentCheckFail(id: "MemTest", note: "Hello this is Test")
        switch checkPass {
        case .success:
            print("check fail success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2AgentCheckFailAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentCheckPass")
        consul.agentCheckFail(id: "MemTest", note: "Hello this is Test") { checkPass in
            switch checkPass {
            case .success:
                print("check fail success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2AgentCheckUpdate() {
        let consul = Consul()
        let checkPass = consul.agentCheckUpdate(id: "MemTest",
                                                status: .passing,
                                                output: "Hello this is Test")
        switch checkPass {
        case .success:
            print("check update success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2AgentCheckUpdateAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentCheckPass")
        consul.agentCheckUpdate(id: "MemTest", status: .passing, output: "Hello this is Test") { checkPass in
            switch checkPass {
            case .success:
                print("check update success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
}
