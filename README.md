# SoundCloud for macOS

SoundCloud doesn't offer a native macOS app: let me fix that for them! 

This is a very simple Swift application that wraps the SoundCloud web app using a `WKWebView`. It allows you to log in to SoundCloud (email/password, no OAuth for now) and persist your session via cookies. 

![App screenshot.](screenshot.png)

## Requirements

- macOS 10.15 or later
- Xcode 12 or later
- Swift 5

## Installation and Compilation

Follow these steps to download and compile the project in Xcode:

### 1. Clone the Repository

Open Terminal and run:

```bash
git clone https://github.com/yourusername/SoundCloudWrapperApp.git
```

Or download the ZIP archive from GitHub and unzip it.

### 2. Open the Project in Xcode

Navigate to the project folder.

Double-click the SoundCloudWrapperApp.xcodeproj file to open the project in Xcode.

### 3. Build the Project
In Xcode, select the appropriate scheme (the default should work for you).

Click Product > Build (or press Cmd+B) to compile the project.

### 4. Run the App

With the project open in Xcode, click Product > Run (or press Cmd+R).

The app window should appear displaying the SoundCloud login page in the embedded web view.

Log in as you normally would—the app uses a persistent cookie store to keep you logged in even after closing and re-opening the app.

## Troubleshooting

### Icon Issues:

If your app icon isn’t displaying as expected, ensure that you have added all required image sizes to the AppIcon asset in Assets.xcassets.

### WKWebView Loading Errors:

If the web page does not load, check Xcode’s debug console for error messages. Make sure you have an active internet connection and that no firewall or proxy is blocking the connection.

### Clearing Cache:

Sometimes macOS caches app icons or other data. Restart the Dock by running killall Dock in Terminal if you need to refresh the icon display.

## Contributing

Feel free to fork this repository and submit pull requests if you have improvements or fixes. 

Ideas for improvements:

- resize web view along with window
- bind to the MacBook reverse | play | forward keys
- feel free to suggest any other ideas!

## License

This project is licensed under the [MIT License](https://opensource.org/license/mit).

## Contact

For any questions or issues, please [open an issue](https://github.com/rlacombe/SoundCloud-macOS/issues) on GitHub.
