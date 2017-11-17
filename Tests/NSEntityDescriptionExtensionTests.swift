//
//  NSEntityDescriptionExtensionTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 17.11.2017.
//

import CoreData
@testable import FetchKit
import XCTest

internal class NSEntityDescriptionExtensionTests: FetchKitTests {
    
    func testAttributeDescriptionForName() {
        let entityDescription = NSEntityDescription.entity(forEntityName: User.fk_entityName, in: context)
        let attributeDescription = entityDescription?.attributeDescription(for: #keyPath(User.id))

        XCTAssertNotNil(attributeDescription)
        XCTAssertEqual(attributeDescription!.name, #keyPath(User.id))
    }

    func testAttributeDescriptionForInvalidName() {
        let entityDescription = NSEntityDescription.entity(forEntityName: User.fk_entityName, in: context)
        let attributeDescription = entityDescription?.attributeDescription(for: "invalid")

        XCTAssertNil(attributeDescription)
    }

}
