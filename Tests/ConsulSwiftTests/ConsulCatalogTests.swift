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
    
}
