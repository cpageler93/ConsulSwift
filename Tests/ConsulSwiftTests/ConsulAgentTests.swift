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
    
    func testAgentMembers() {
        let consul = Consul()
        let members = consul.agentMembers()
        switch members {
        case .Success(let members):
            XCTAssertEqual(members.count, 1)
        case .Failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func testAgentMembersAsync() {
        let consul = Consul()
        let agentMembersExpectation = self.expectation(description: "agentMembers")
        consul.agentMembers { members in
            switch members {
            case .Success(let members):
                XCTAssertEqual(members.count, 1)
            case .Failure(let error):
                XCTAssertNil(error)
            }
            agentMembersExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
}
