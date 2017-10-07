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

    static var allTests = [
        ("testAgentMembers", testAgentMembers),
        ("testAgentMembersAsync", testAgentMembersAsync),
        ("testAgentReadConfiguration", testAgentReadConfiguration),
        ("testAgentReadConfigurationAsync", testAgentReadConfigurationAsync),
        ("testAgentReload", testAgentReload),
        ("testAgentReloadAsync", testAgentReloadAsync),
        ("testAgentMaintenanceEnable", testAgentMaintenanceEnable),
        ("testAgentMaintenanceEnableAsync", testAgentMaintenanceEnableAsync),
        ("testAgentMaintenanceDisable", testAgentMaintenanceDisable),
        ("testAgentMaintenanceDisableAsync", testAgentMaintenanceDisableAsync),
        ("test3AgentChecks", test3AgentChecks),
        ("test3AgentChecksAsync", test3AgentChecksAsync),
        ("test1AgentRegisterCheckMinimal", test1AgentRegisterCheckMinimal),
        ("test1AgentRegisterCheckAsync", test1AgentRegisterCheckAsync),
        ("test1AgentRegisterCheckMaximal", test1AgentRegisterCheckMaximal),
        ("test4AgentDeregisterCheck", test4AgentDeregisterCheck),
        ("test4AgentDeregisterCheckAsync", test4AgentDeregisterCheckAsync),
        ("test2AgentCheckPass", test2AgentCheckPass),
        ("test2AgentCheckPassAsync", test2AgentCheckPassAsync),
        ("test2AgentCheckWarn", test2AgentCheckWarn),
        ("test2AgentCheckWarnAsync", test2AgentCheckWarnAsync),
        ("test2AgentCheckFail", test2AgentCheckFail),
        ("test2AgentCheckFailAsync", test2AgentCheckFailAsync),
        ("test2AgentCheckUpdate", test2AgentCheckUpdate),
        ("test2AgentCheckUpdateAsync", test2AgentCheckUpdateAsync),
        ("test3AgentServices", test3AgentServices),
        ("test3AgentServicesAsync", test3AgentServicesAsync),
        ("test1AgentRegisterService", test1AgentRegisterService),
        ("test1AgentRegisterServiceAsync", test1AgentRegisterServiceAsync),
        ("test2AgentDeregisterService", test2AgentDeregisterService),
        ("test2AgentDeregisterServiceAsync", test2AgentDeregisterServiceAsync),
        ("test1AgentServiceMaintenance", test1AgentServiceMaintenance),
        ("test1AgentServiceMaintenanceWithWrongServiceID", test1AgentServiceMaintenanceWithWrongServiceID),
        ("test1AgentServiceMaintenanceAsync", test1AgentServiceMaintenanceAsync)
    ]
    
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
        let checkPass = consul.agentCheckPass(id: "MemTestUnitTests")
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
        consul.agentCheckPass(id: "MemTestUnitTests") { checkPass in
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
        let checkPass = consul.agentCheckWarn(id: "MemTestUnitTests", note: "Hello this is Test")
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
        consul.agentCheckWarn(id: "MemTestUnitTests", note: "Hello this is Test") { checkPass in
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
        let checkPass = consul.agentCheckFail(id: "MemTestUnitTests", note: "Hello this is Test")
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
        consul.agentCheckFail(id: "MemTestUnitTests", note: "Hello this is Test") { checkPass in
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
        let checkPass = consul.agentCheckUpdate(id: "MemTestUnitTests",
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
        consul.agentCheckUpdate(id: "MemTestUnitTests", status: .passing, output: "Hello this is Test") { checkPass in
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
    
    func test3AgentServices() {
        let consul = Consul()
        let services = consul.agentServices()
        switch services {
        case .success(let services):
            XCTAssertGreaterThanOrEqual(services.count, 2)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test3AgentServicesAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentServices")
        consul.agentServices { services in
            switch services {
            case .success(let services):
                XCTAssertGreaterThanOrEqual(services.count, 2)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test1AgentRegisterService() {
        let consul = Consul()
        let service = ConsulAgentServiceInput(name: "testService")
        let register = consul.agentRegisterService(service)
        switch register {
        case .success:
            print("regiser service success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test1AgentRegisterServiceAsync() {
        let consul = Consul()
        let service = ConsulAgentServiceInput(name: "testServiceAsync")
        
        let expectation = self.expectation(description: "agentServiceRegister")
        
        consul.agentRegisterService(service) { register in
            switch register {
            case .success:
                print("regiser service success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2AgentDeregisterService() {
        let consul = Consul()
        let deregister = consul.agentDeregisterService("testServiceAsync")
        switch deregister {
        case .success:
            print("deregister success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2AgentDeregisterServiceAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentServiceDeregister")
        
        consul.agentDeregisterService("testServiceAsync") { deregister in
            switch deregister {
            case .success:
                print("deregister success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test1AgentServiceMaintenance() {
        let consul = Consul()
        let maintenance = consul.agentServiceMaintenance("testService",
                                                         enable: true,
                                                         reason: "Test")
        switch maintenance {
        case .success:
            print("maintenance success")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test1AgentServiceMaintenanceWithWrongServiceID() {
        let consul = Consul()
        let maintenance = consul.agentServiceMaintenance("testServiceThisIsNotAValidServiceName",
                                                         enable: true,
                                                         reason: "Test")
        switch maintenance {
        case .success:
            XCTFail("this should fail because the id is invalid")
        case .failure:
            print("maintenance failure is correct")
        }
    }
    
    func test1AgentServiceMaintenanceAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "agentServiceMaintenance")
        
        consul.agentServiceMaintenance("testService", enable: true, reason: "Test") { maintenance in
            switch maintenance {
            case .success:
                print("maintenance success")
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }

}
