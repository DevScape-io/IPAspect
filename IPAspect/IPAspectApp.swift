//
//  IPAspectApp.swift
//  IPAspect
//
//  Created by Parker Howell on 12/30/25.
//

import SwiftUI
import SwiftData

@main
struct IPAspectApp: App {
    @State private var fileURLToOpen: URL?
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            IPAInfo.self,
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
            ContentView(fileURLToOpen: $fileURLToOpen)
                .onOpenURL { url in
                    // Handle files opened from Finder
                    if url.pathExtension.lowercased() == "ipa" {
                        fileURLToOpen = url
                    }
                }
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.automatic)
        .defaultSize(width: 900, height: 650)
        .commands {
            CommandGroup(after: .newItem) {
                Button("Analyze IPA...") {
                    NSApplication.shared.sendAction(#selector(NSResponder.keyDown(with:)), to: nil, from: nil)
                }
                .keyboardShortcut("o", modifiers: .command)
            }
        }
    }
}

