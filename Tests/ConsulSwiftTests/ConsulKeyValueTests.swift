//
//  ConsulKeyValueTests.swift
//  ConsulSwiftTests
//
//  Created by Christoph Pageler on 19.06.17.
//

import XCTest
@testable import ConsulSwift

class ConsulKeyValueTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    static var allTests = [
        ("test1WriteKeyAndReadKey", test1WriteKeyAndReadKey),
        ("test1WriteKeyAndReadKeyAsync", test1WriteKeyAndReadKeyAsync),
        ("test2ListKeys", test2ListKeys),
        ("test2ListKeysAsync", test2ListKeysAsync),
        ("test3DeleteKey", test3DeleteKey),
        ("test3DeleteKeyAsync", test3DeleteKeyAsync)
    ]
    
    func test1WriteKeyAndReadKey() {
        let consul = Consul()
        
        let writeKey = consul.writeKey("unitTest", value: "unitTestValue")
        switch writeKey {
        case .success(let writeKey):
            XCTAssertTrue(writeKey)
        case .failure(let error):
            XCTAssertNil(error)
        }
        
        let keyValuePair = consul.readKey("unitTest")
        switch keyValuePair {
        case .success(let keyValuePair):
            XCTAssertEqual(keyValuePair.decodedValue(), "unitTestValue")
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test1WriteKeyAndReadKeyAsync() {
        let consul = Consul()
        
        let writeExpectation = self.expectation(description: "writeKeyExpectation")
        let readExpectation = self.expectation(description: "readKeyExpectation")
        
        consul.writeKey("unitTestAsync", value: "unitTestValue") { writeKey in
            switch writeKey {
            case .success(let writeKey):
                XCTAssertTrue(writeKey)
            case .failure(let error):
                XCTAssertNil(error)
            }
            writeExpectation.fulfill()
            
            consul.readKey("unitTestAsync", completion: { keyValuePair in
                switch keyValuePair {
                case .success(let keyValuePair):
                    XCTAssertEqual(keyValuePair.decodedValue(), "unitTestValue")
                case .failure(let error):
                    XCTAssertNil(error)
                }
                readExpectation.fulfill()
            })
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test2ListKeys() {
        let consul = Consul()
        let keys = consul.listKeys()
        switch keys {
        case .success(let keys):
            XCTAssertGreaterThanOrEqual(keys.count, 1)
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test2ListKeysAsync() {
        let consul = Consul()
        let expectation = self.expectation(description: "listKeys")
        consul.listKeys { keys in
            switch keys {
            case .success(let keys):
                XCTAssertGreaterThanOrEqual(keys.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test3DeleteKey() {
        let consul = Consul()
        
        switch consul.listKeys() {
        case .success(let keys):
            let count = keys.count
            let delete = consul.deleteKey("unitTest")
            
            switch delete {
            case .success(let success):
                XCTAssertTrue(success)
                
                switch consul.listKeys() {
                case .success(let keys):
                    XCTAssertLessThan(keys.count, count)
                case .failure(let error):
                    XCTAssertNil(error)
                }
            case .failure(let error):
                XCTAssertNil(error)
            }
            
        case .failure(let error):
            XCTAssertNil(error)
        }
    }
    
    func test3DeleteKeyAsync() {
        let consul = Consul()
        
        let expectation = self.expectation(description: "listKeys")
        
        switch consul.listKeys() {
        case .success(let keys):
            let count = keys.count
            consul.deleteKey("unitTestAsync", completion: { delete in
                switch delete {
                case .success(let success):
                    XCTAssertTrue(success)
                    
                    switch consul.listKeys() {
                    case .success(let keys):
                        XCTAssertLessThan(keys.count, count)
                    case .failure(let error):
                        XCTAssertNil(error)
                    }
                    
                    expectation.fulfill()
                case .failure(let error):
                    XCTAssertNil(error)
                }
            })
            
        case .failure(let error):
            XCTAssertNil(error)
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
}
