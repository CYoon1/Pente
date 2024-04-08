//
//  PenteApp.swift
//  Pente
//
//  Created by Christopher Yoon on 4/1/24.
//

import SwiftUI
import SwiftData

@main
struct PenteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameData.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
