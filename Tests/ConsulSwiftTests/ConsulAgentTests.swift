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
}
