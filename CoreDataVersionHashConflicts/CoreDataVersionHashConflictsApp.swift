//
//  CoreDataVersionHashConflictsApp.swift
//  CoreDataVersionHashConflicts
//
//  Created by Martin Hettiger on 05.02.21.
//

import SwiftUI

@main
struct CoreDataVersionHashConflictsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
