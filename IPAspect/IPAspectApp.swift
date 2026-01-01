//
//  IPAspectApp.swift
//  IPAspect
//
//  Created by Parker Howell on 12/30/25.
//
//  Copyright 2026 DevScape.io LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

