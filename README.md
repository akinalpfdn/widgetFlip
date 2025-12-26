# widgetFlip

A beautiful iOS coin flipper app with home screen and lock screen widgets.

![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0%2B-green)

## Features

- **Coin Flipping** – Tap to flip a virtual coin with smooth 3D animation
- **Home Screen Widget** – See your latest flip result directly on your home screen
- **Lock Screen Widget** – Quick access to coin flipping from lock screen
- **Flip History** – View your last 50 flips with timestamps
- **Haptic Feedback** – Satisfying vibration on each flip
- **Works Offline** – No internet connection required
- **Privacy First** – No data collection, no tracking, no analytics


## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later

## Installation

### From Source

1. Clone this repository:
   ```bash
   git clone https://github.com/akinalpfdn/widgetFlip.git
   ```

2. Open `widgetFlip.xcodeproj` in Xcode

3. Select your target device/simulator

4. Run the project (Cmd + R)

## How It Works

The app uses:
- **SwiftUI** for the user interface
- **WidgetKit** for home and lock screen widgets
- **AppIntents** for widget interactions
- **App Groups** to share data between the app and widgets

All data is stored locally on your device using `UserDefaults` with the App Group identifier `group.com.akinalpfdn.widgetflip`.

## Data Storage

| Data | Purpose |
|------|---------|
| Current coin side | Display in widget |
| Coin icon | Display in widget |
| Last flip timestamp | Display in widget |
| Flip counter | Animation state |
| Flip history (50 max) | Recent flips in app |

## Privacy Policy

This app does not collect, store, or transmit any personal data. All data remains on your device. See [privacy_policy.md](privacy_policy.md) for details.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.

## Author

**Akinalp Fidan** – [GitHub](https://github.com/akinalpfdn)

## Acknowledgments

- Built with SwiftUI and WidgetKit
- Icons by Apple SF Symbols
