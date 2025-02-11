//
//  CustomWKWebView.swift
//  SoundCloud
//
//  Created by Jaufré Goumet on 11/02/2025.
//
import WebKit
import AppKit

class CustomWKWebView: WKWebView {
    /// Closure to be called when “Open Link in New Tab” is selected.
    var onOpenInNewTab: ((URL) -> Void)?

    override func menu(for event: NSEvent) -> NSMenu? {
        // Get the default menu.
        let menu = super.menu(for: event) ?? NSMenu()
        
        // Convert the event location into the web view’s coordinate system.
        let point = convert(event.locationInWindow, from: nil)
        // JavaScript to fetch the href attribute of the closest link element.
        let js = "document.elementFromPoint(\(point.x), \(point.y))?.closest('a')?.href;"
        
        // Evaluate the JavaScript synchronously using a semaphore (this is not ideal for production, but works for demo purposes).
        var linkURLString: String? = nil
        let semaphore = DispatchSemaphore(value: 0)
        evaluateJavaScript(js) { (result, error) in
            if let urlStr = result as? String {
                linkURLString = urlStr
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 0.5)
        
        // If a valid SoundCloud link was found, add the menu item.
        if let urlStr = linkURLString,
           let url = URL(string: urlStr),
           url.host?.contains("soundcloud.com") == true {
            let item = NSMenuItem(title: "Open Link in New Tab", action: #selector(openLinkInNewTab(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = url
            menu.addItem(item)
        }
        return menu
    }
    
    @objc func openLinkInNewTab(_ sender: NSMenuItem) {
        if let url = sender.representedObject as? URL {
            onOpenInNewTab?(url)
        }
    }
}
