//
//  GetCountTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

// swiftlint:disable force_try

internal class GetCountTests: FetchKitTests {
    
    func testExecute() {
        let usersCount = try! GetCount<User>().execute(in: context)
        XCTAssertEqual(usersCount, 5)
    }
    
}
