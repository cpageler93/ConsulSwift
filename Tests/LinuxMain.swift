import XCTest

@testable import ConsulSwiftTests
@testable import ConsulAgentTests
@testable import ConsulCatalogTests
@testable import ConsulEventTests
@testable import ConsulHealthTests
@testable import ConsulKeyValueTests

XCTMain([
    testCase(ConsulSwiftTests.allTests),
    testCase(ConsulAgentTests.allTests),
    testCase(ConsulCatalogTests.allTests),
    testCase(ConsulEventTests.allTests),
    testCase(ConsulHealthTests.allTests),
    testCase(ConsulKeyValueTests.allTests)
])
