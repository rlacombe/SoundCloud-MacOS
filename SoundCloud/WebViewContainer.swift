//
//  WebViewContainer.swift
//  SoundCloud
//
//  Created by Jaufré on 11/02/2025.
//

import Foundation
import SwiftUI
import WebKit

class WebViewContainer: NSObject, ObservableObject, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    var webView: CustomWKWebView
    @Published var currentURL: URL?
    @Published var currentTitle: String?
    var onOpenNewTab: ((URL) -> Void)?
    var onOpenNewWindow: ((URL) -> Void)?
    
    private var coordinator: Coordinator!
    
    init(url: URL) {
        // Create a configuration with a user content controller.
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        // JavaScript to intercept navigation changes and send an object with URL and title.
        let js = """
        (function() {
            function notifyURLChange() {
                var info = { "url": document.location.href, "title": document.title };
                window.webkit.messageHandlers.urlChanged.postMessage(info);
            }
            var pushState = history.pushState;
            history.pushState = function() {
                pushState.apply(history, arguments);
                setTimeout(notifyURLChange, 100);
            };
            var replaceState = history.replaceState;
            history.replaceState = function() {
                replaceState.apply(history, arguments);
                setTimeout(notifyURLChange, 100);
            };
            window.addEventListener('popstate', function() {
                setTimeout(notifyURLChange, 100);
            });
        })();
        """
        let userScript = WKUserScript(source: js,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: false)
        contentController.addUserScript(userScript)
        config.userContentController = contentController
        config.websiteDataStore = WKWebsiteDataStore.default()
        
        
        
        // Initialize all stored properties BEFORE calling super.init().
        self.webView = CustomWKWebView(frame: .zero, configuration: config)
        self.currentURL = url
        self.currentTitle = nil
        
        // Now that all stored properties are initialized, call super.init().
        super.init()
        
        // Now safely use self.
        contentController.add(self, name: "urlChanged")
        
        // Set up the navigation and UI delegates.
        self.coordinator = Coordinator(self)
        self.webView.navigationDelegate = self.coordinator
        self.webView.uiDelegate = self.coordinator
                
        let request = URLRequest(url: url)
        self.webView.load(request)
                
        self.webView.onOpenNewTab = { [weak self] url in
                    self?.onOpenNewTab?(url)
        }
        self.webView.onOpenNewWindow = { [weak self] url in
                    self?.onOpenNewWindow?(url)
        }
    }
    
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "urlChanged",
           let dict = message.body as? [String: Any],
           let newURLString = dict["url"] as? String,
           let newTitle = dict["title"] as? String,
           let newURL = URL(string: newURLString) {
            DispatchQueue.main.async {
                self.currentURL = newURL
                self.currentTitle = newTitle
            }
        }
    }
    
    // Updated method signature to match WKNavigationDelegate protocol
       @objc func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
           print("Navigation did commit.")
       }

       // Updated method signature to match WKNavigationDelegate protocol
       @objc func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           print("Navigation finished successfully.")
           if let newURL = webView.url {
               DispatchQueue.main.async {
                   self.currentURL = newURL
                   self.currentTitle = webView.title
               }
           }
       }

       // Updated method signature to match WKNavigationDelegate protocol
       @objc func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
           print("Navigation error: \(error.localizedDescription)")
       }
   }
    
    // MARK: - Coordinator
class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebViewContainer
        
        init(_ parent: WebViewContainer) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Navigation error: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Provisional navigation error: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Navigation finished successfully.")
            if let newURL = webView.url {
                DispatchQueue.main.async {
                    self.parent.currentURL = newURL
                    self.parent.currentTitle = webView.title
                }
            }
        }
        
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
                DispatchQueue.main.async {
                    self.parent.onOpenNewTab?(url)
                }
            }
            return nil
        }
    }


