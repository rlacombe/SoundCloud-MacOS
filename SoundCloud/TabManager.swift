//
//  TabManager.swift
//  SoundCloud
//
//  Created by Jaufré on 11/02/2025.
//

import Foundation
import SwiftUI
import WebKit

// Represents one tab in your app.
struct TabItem: Identifiable {
    let id = UUID()
    let url: URL
    let container: WebViewContainer

    // Custom initializer that creates the container automatically.
    init(url: URL) {
        self.url = url
        self.container = WebViewContainer(url: url)
    }
}

extension TabItem: Equatable {
    static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TabItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Manages a list of tabs.
class TabManager: ObservableObject {
    @Published var tabs: [TabItem] = []
    @Published var selectedTab: TabItem?
    
    init() {
        // Start with one default tab.
        let defaultURL = URL(string: "https://soundcloud.com")!
        let initialTab = TabItem(url: defaultURL)
        tabs.append(initialTab)
        selectedTab = initialTab
    }
    
    func addTab(url: URL) {
        let newTab = TabItem(url: url)
        newTab.container.onOpenNewTab = { [weak self] url in
            self?.addTab(url: url)
        }
        newTab.container.onOpenNewWindow = { url in
            // Your window opening logic.
            print("Open new window for \(url)")
        }
        tabs.append(newTab)
        selectedTab = newTab
    }


    
    func closeTab(_ tab: TabItem) {
        // Remove the tab from the array.
        tabs.removeAll { $0.id == tab.id }
        
        // If the closed tab was the selected one,
        // set the selected tab to the last tab in the list.
        if selectedTab?.id == tab.id {
            selectedTab = tabs.last
        }
    }
}

extension URL {
    var shortDisplayName: String {
        if self.absoluteString == "https://soundcloud.com" {
            return "Home"
        }
        let comps = self.pathComponents.filter { $0 != "/" && !$0.isEmpty }
        if comps.isEmpty {
            return "Home"
        }
        return comps.last!.capitalized
    }
}
