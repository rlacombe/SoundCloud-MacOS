//
//  SoundCloudApp.swift
//  SoundCloud
//
//  Created by Romain on 2/6/25.
//  Edited by Jaufré on 2/11/25.
//

import SwiftUI

@main
struct SoundCloudApp: App {
    @StateObject var tabManager = TabManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tabManager)
        }
        .commands {
            CommandMenu("Tabs") {
                Button("New Tab") {
                    tabManager.addTab(url: URL(string: "https://soundcloud.com")!)
                }
                .keyboardShortcut("t", modifiers: [.command])
                
                // New shortcut: open current link in new tab.
                Button("Open Current Link in New Tab") {
                    if let url = tabManager.selectedTab?.container.currentURL {
                        tabManager.addTab(url: url)
                    }
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])
            }
        }
    }
}
