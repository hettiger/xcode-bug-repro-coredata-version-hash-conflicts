//
//  CoreDataVersionHashConflictsTests.swift
//  CoreDataVersionHashConflictsTests
//
//  Created by Martin Hettiger on 05.02.21.
//

import CoreData
@testable import CoreDataVersionHashConflicts
import XCTest

/// CoreData Version Hash Conflicts Tests
///
/// This test case reproduces an issue with the CoreData attribute »Preserve After Deletion« option.
/// Follow these simple steps to make all tests pass:
///
/// 1. Disable Preserve After Deletion on `Entity.id` in both model versions
/// 2. Open the mapping model; execute »Editor / Refresh Data Models«.
class CoreDataVersionHashConflictsTests: XCTestCase {
    var model: NSManagedObjectModel!
    var model2: NSManagedObjectModel!
    var mapping: NSMappingModel!

    override func setUp() {
        super.setUp()

        let modelPath = Bundle.main.path(
            forResource: "CoreDataVersionHashConflicts",
            ofType: "mom",
            inDirectory: "CoreDataVersionHashConflicts.momd"
        )!
        let modelURL = URL(fileURLWithPath: modelPath)
        model = NSManagedObjectModel(contentsOf: modelURL)!

        let model2Path = Bundle.main.path(
            forResource: "CoreDataVersionHashConflicts 2",
            ofType: "mom",
            inDirectory: "CoreDataVersionHashConflicts.momd"
        )!
        let model2URL = URL(fileURLWithPath: model2Path)
        model2 = NSManagedObjectModel(contentsOf: model2URL)!

        let mappingPath = Bundle.main.path(
            forResource: "CoreDataVersionHashConflicts to CoreDataVersionHashConflicts 2",
            ofType: "cdm"
        )!
        let mappingURL = URL(fileURLWithPath: mappingPath)
        mapping = NSMappingModel(contentsOf: mappingURL)!
    }

    override func tearDown() {
        model = nil
        model2 = nil
        mapping = nil

        super.tearDown()
    }

    func test_model_and_mapping_version_hashes_are_matching() {
        for entityMapping in mapping.entityMappings {
            let modelSourceEntityVersionHash = model
                .entityVersionHashesByName[entityMapping.sourceEntityName!]!
            let mappingSourceEntityVersionHash = entityMapping.sourceEntityVersionHash!
            XCTAssertEqual(modelSourceEntityVersionHash, mappingSourceEntityVersionHash)

            let modelDestinationEntityVersionHash = model2
                .entityVersionHashesByName[entityMapping.destinationEntityName!]!
            let mappingDestinationEntityVersionHash = entityMapping.destinationEntityVersionHash!
            XCTAssertEqual(modelDestinationEntityVersionHash, mappingDestinationEntityVersionHash)
        }
    }

    func test_finds_compatible_mapping_model() {
        XCTAssertNotNil(
            NSMappingModel(from: [.main], forSourceModel: model, destinationModel: model2)
        )
    }
}
