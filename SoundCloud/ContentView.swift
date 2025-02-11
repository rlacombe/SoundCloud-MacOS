//
//  ContentView.swift
//  SoundCloud
//
//  Created by Romain on 2/6/25.
//  Edited by Jaufré on 2/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tabManager: TabManager

    var body: some View {
        VStack(spacing: 0) {
            // Only show the tab bar if there is more than one tab.
            if tabManager.tabs.count > 1 {
                tabBar
            }
            // (Divider removed to avoid an extra line.)
            contentArea
        }
        .onAppear {
            if let window = NSApplication.shared.windows.first {
                window.setContentSize(NSSize(width: 1280, height: 720))
                window.minSize = NSSize(width: 100, height: 100)
            }
            // Key event monitor for Command+W.
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.modifierFlags.contains(.command),
                   event.charactersIgnoringModifiers?.lowercased() == "w" {
                    if let selected = self.tabManager.selectedTab, self.tabManager.tabs.count > 1 {
                        self.tabManager.closeTab(selected)
                        return nil // Swallow the event.
                    }
                }
                return event
            }
        }
    }
    
    // Tab bar that distributes tabs evenly.
    var tabBar: some View {
        GeometryReader { geo in
            let tabWidth = geo.size.width / CGFloat(tabManager.tabs.count)
            HStack(spacing: 0) {
                ForEach(tabManager.tabs) { tab in
                    TabBarItemView(
                        tab: tab,
                        isSelected: tabManager.selectedTab?.id == tab.id,
                        onSelect: { tabManager.selectedTab = tab },
                        onClose: { tabManager.closeTab(tab) }
                    )
                    .frame(width: tabWidth)
                }
            }
        }
        .frame(height: 30)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    // Content area displaying persistent web views.
    var contentArea: some View {
        Group {
            if !tabManager.tabs.isEmpty {
                ZStack {
                    ForEach(tabManager.tabs) { tab in
                        PersistentWebView(container: tab.container)
                            .opacity(tabManager.selectedTab?.id == tab.id ? 1 : 0)
                            .allowsHitTesting(tabManager.selectedTab?.id == tab.id)
                            .onAppear {
                                // This sets the callback so that if a link is right-clicked (via CustomWKWebView),
                                // it opens a new tab.
                                tab.container.onOpenNewTab = { url in
                                    tabManager.addTab(url: url)
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No tab selected")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(TabManager())
}
