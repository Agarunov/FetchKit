//
//  FindAllTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

// swiftlint:disable force_try

internal class FindAllTests: FetchKitTests {
    
    func testExecute() {
        let all = try! FindAll<User>().execute(in: context)
        XCTAssertEqual(all.count, 5)
    }
    
}
