import XCTest
@testable import ConsulSwift

class ConsulSwiftTests: XCTestCase {
    func testInitialURLIsLocalhost8500() {
        let consul = Consul()
        XCTAssertEqual(consul.url.absoluteString, "http://localhost:8500")
    }
}
