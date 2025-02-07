//
//  SoundCloudApp.swift
//  SoundCloud
//
//  Created by Romain on 2/6/25.
//

import SwiftUI

@main
struct SoundCloudApp: App {
    var body: some Scene {
        WindowGroup {
            // Using a fixed frame size for clarity.
            WebView(url: URL(string: "https://soundcloud.com")!)
                .frame(width: 1280, height: 720)
        }
    }
}
