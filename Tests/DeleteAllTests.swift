//
//  DeleteAllTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

// swiftlint:disable force_try

internal class DeleteAllTests: FetchKitTests {
    
    func testExecute() {
        let deleteCount = try! DeleteAll<User>()
            .where(#keyPath(User.firstName), equals: "John")
            .execute(in: context)
        let newCount = try! GetCount<User>().execute(in: context)
        
        XCTAssertEqual(deleteCount, 2)
        XCTAssertEqual(newCount, 3)
    }
    
}
