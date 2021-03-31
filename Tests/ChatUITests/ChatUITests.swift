import XCTest
@testable import ChatUI

final class ChatUITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ChatUI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
