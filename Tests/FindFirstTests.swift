//
//  FindFirstTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

// swiftlint:disable force_try force_unwrapping

internal class FindFirstTests: FetchKitTests {
        
    func testExecute() {
        let user = try! FindFirst<User>()
            .sorted(by: #keyPath(User.firstName))
            .execute(in: context)
        XCTAssertEqual(user!.id, 3)
        XCTAssertEqual(user!.firstName, "Alex")
        XCTAssertEqual(user!.lastName, "Finch")
    }
    
}
