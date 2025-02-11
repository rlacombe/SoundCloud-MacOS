//
//  WindowHelper.swift
//  SoundCloud
//
//  Created by Jaufré on 11/02/2025.
//

import Foundation
import SwiftUI
import AppKit

func createNewWindow(for url: URL) -> NSWindow {
    // Create a new WebViewContainer for the provided URL.
    let webContainer = WebViewContainer(url: url)
    // Optionally set up the callbacks on the container if needed.
    webContainer.onOpenNewTab = { newURL in
        // For a new tab, you might want to use your TabManager logic.
        print("New tab requested for \(newURL)")
    }
    webContainer.onOpenNewWindow = { newURL in
        // This is the same as the current closure.
        print("New window requested for \(newURL)")
    }
    
    // Wrap the persistent web view in a SwiftUI view.
    let hostingController = NSHostingController(rootView: PersistentWebView(container: webContainer))
    // Create a new NSWindow with that hosting controller.
    let window = NSWindow(contentViewController: hostingController)
    window.title = "SoundCloud - \(url.host ?? url.absoluteString)"
    window.setContentSize(NSSize(width: 1280, height: 720))
    window.minSize = NSSize(width: 400, height: 300)
    window.makeKeyAndOrderFront(nil)
    return window
}
