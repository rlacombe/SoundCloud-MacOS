//
//  CustomWKWebView.swift
//  SoundCloud
//
//  Created by Jaufré on 11/02/2025.
//
import WebKit
import AppKit

enum ContextualMenuAction {
    case openNewTab
    case openNewWindow
}

class CustomWKWebView: WKWebView {
    /// Closure to be called when “Open Link in New Tab” is selected.
    var onOpenNewTab: ((URL) -> Void)?
    /// Closure to be called when “Open Link in New Window” is selected.
    var onOpenNewWindow: ((URL) -> Void)?
    
    /// Tracks which action was triggered (if needed in delegate methods).
    var contextualMenuAction: ContextualMenuAction?
    
    override func menu(for event: NSEvent) -> NSMenu? {
        // If this is a middle click (buttonNumber == 2), don't modify the menu.
        if event.buttonNumber == 2 {
            return super.menu(for: event)
        }
        
        // For left/right clicks, get the default menu.
        let menu = super.menu(for: event) ?? NSMenu()
        
        // Iterate through the menu items and rename the default "Open Link in New Window" item.
        for item in menu.items {
            if let id = item.identifier?.rawValue, id == "WKMenuItemIdentifierOpenLinkInNewWindow" {
                item.title = "Open Link in New Tab"
            }
        }
        
        // Now, for a non-middle click, get the link using synchronous JavaScript.
        let point = convert(event.locationInWindow, from: nil)
        let js = "document.elementFromPoint(\(point.x), \(point.y))?.closest('a')?.href;"
        
        var linkURLString: String? = nil
        let semaphore = DispatchSemaphore(value: 0)
        evaluateJavaScript(js) { (result, error) in
            if let urlStr = result as? String {
                linkURLString = urlStr
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 0.5)
        
        // If a valid SoundCloud link is found and the default item is missing, add one.
        if let urlStr = linkURLString,
           let url = URL(string: urlStr),
           url.host?.contains("soundcloud.com") == true {
            if !menu.items.contains(where: { $0.title == "Open Link in New Tab" }) {
                let newItem = NSMenuItem(title: "Open Link in New Tab", action: #selector(openNewTab(_:)), keyEquivalent: "")
                newItem.target = self
                newItem.representedObject = url
                menu.addItem(newItem)
            }
        }
        
        return menu
    }

    


    
    @objc func openNewTab(_ sender: NSMenuItem) {
        if let url = sender.representedObject as? URL {
            self.contextualMenuAction = .openNewTab
            onOpenNewTab?(url)
        }
    }
    
    @objc func openNewWindow(_ sender: NSMenuItem) {
        if let url = sender.representedObject as? URL {
            self.contextualMenuAction = .openNewWindow
            onOpenNewWindow?(url)
        }
    }
}

extension CustomWKWebView: WKUIDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            DispatchQueue.main.async {
                if let customWebView = webView as? CustomWKWebView {
                    if let action = customWebView.contextualMenuAction, action == .openNewTab {
                        customWebView.onOpenNewTab?(url)
                    } else {
                        customWebView.onOpenNewWindow?(url)
                    }
                    customWebView.contextualMenuAction = nil
                }
            }
        }
        return nil
    }
}
