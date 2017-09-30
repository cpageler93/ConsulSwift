import XCTest

@testable import ConsulSwiftTests

XCTMain([
    testCase(ConsulSwiftTests.allTests),
    testCase(ConsulAgentTests.allTests),
    testCase(ConsulCatalogTests.allTests),
    testCase(ConsulEventTests.allTests),
    testCase(ConsulHealthTests.allTests),
    testCase(ConsulKeyValueTests.allTests)
])
