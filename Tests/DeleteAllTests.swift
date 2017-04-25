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

class DeleteAllTests: FetchKitTests {
    
    func testExecute() {
        let deleteCount = try! deleteAll<User>()
            .where(#keyPath(User.firstName), equals: "John")
            .execute(in: context)
        let newCount = try! getCount<User>().execute(in: context)
        
        XCTAssertEqual(deleteCount, 2)
        XCTAssertEqual(newCount, 3)
    }
    
}
