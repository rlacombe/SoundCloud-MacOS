//
//  PersistentWebView.swift
//  SoundCloud
//
//  Created by Jaufré on 11/02/2025.
//

import Foundation
import SwiftUI
import WebKit

struct PersistentWebView: NSViewRepresentable {
    @ObservedObject var container: WebViewContainer
    
    func makeNSView(context: Context) -> WKWebView {
        container.webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // No update logic is needed.
    }
}
