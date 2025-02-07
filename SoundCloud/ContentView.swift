//
//  ContentView.swift
//  SoundCloud
//
//  Created by Romain on 2/6/25.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Called when navigation fails
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Navigation error: \(error.localizedDescription)")
        }
        
        // Called when the web view fails to load content
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Provisional navigation error: \(error.localizedDescription)")
        }
        
        // Called when navigation finishes successfully
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Navigation finished successfully.")
        }
    }

    func makeNSView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        // Use the default (persistent) data store so cookies persist between launches.
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = context.coordinator
        
        // Ensure the web view automatically resizes with its container.
        webView.autoresizingMask = [.width, .height]
        
        // Start loading the URL.
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
    }
}

struct ContentView: View {
    var body: some View {
        // Remove the fixed frame so the view can resize freely.
        WebView(url: URL(string: "https://soundcloud.com")!)
            .onAppear {
                // Set the initial window size to 1280 x 720.
                if let window = NSApplication.shared.windows.first {
                    window.setContentSize(NSSize(width: 1280, height: 720))
                    // Allow the window to be resized to smaller sizes.
                    window.minSize = NSSize(width: 100, height: 100)
                }
            }
    }
}

#Preview {
    ContentView()
}
