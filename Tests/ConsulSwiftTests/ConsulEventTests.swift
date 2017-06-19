//
//  ConsulEventTests.swift
//  ConsulSwiftTests
//
//  Created by Christoph Pageler on 19.06.17.
//

import XCTest
@testable import ConsulSwift

class ConsulEventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1EventFire() {
        let consul = Consul()
        let event = consul.eventFire(name: "testEvent")
        switch event {
        case .success(let event):
            XCTAssertEqual(event.name, "testEvent")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test1EventFireAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "eventFire")
        consul.eventFire(name: "testEventAsync") { event in
            switch event {
            case .success(let event):
                XCTAssertEqual(event.name, "testEventAsync")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2EventList() {
        let consul = Consul()
        let events = consul.eventList()
        switch events {
        case .success(let events):
            XCTAssertGreaterThanOrEqual(events.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2EventListAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "eventList")
        consul.eventList { events in
            switch events {
            case .success(let events):
                XCTAssertGreaterThanOrEqual(events.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
}
