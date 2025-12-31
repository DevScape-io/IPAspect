# IPAspect

A modern macOS application for analyzing IPA (iOS App) files and inspecting their provisioning profile expiration dates.

## Features

- 🔍 **Analyze IPA Files**: Drag and drop or select IPA files to analyze
- 📅 **Expiration Tracking**: View provisioning profile expiration dates and remaining days
- 📊 **Visual Status Indicators**: Color-coded status (Valid, Expiring Soon, Expired)
- 📱 **Device Information**: View all provisioned devices in Ad Hoc and Development profiles
- 💾 **History Tracking**: Keep a history of all analyzed IPAs using SwiftData
- 🎨 **Modern UI**: Clean, native macOS design following Apple's Human Interface Guidelines

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later (for building from source)

## Installation

### Building from Source

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd IPAspect
   ```

2. Open `IPAspect.xcodeproj` in Xcode

3. Build and run the project (⌘R)

## Usage

### Using the App

1. Launch IPAspect
2. Click the **+** button or press **⌘O** to select an IPA file
3. Wait for the analysis to complete
4. View the provisioning profile details in the main window

The app will show:
- Profile expiration date and status
- Days remaining until expiration
- Team name and identifier
- Bundle identifier
- Profile type (Development, Ad Hoc, App Store, Enterprise)
- List of provisioned devices (if applicable)

### Using the Command-Line Tool

The included `analyze-ipa.sh` script allows you to analyze IPA files from the terminal:

```bash
# Make the script executable
chmod +x analyze-ipa.sh

# Analyze an IPA file
./analyze-ipa.sh /path/to/your/app.ipa
```

The script will output:
- Team information
- Bundle identifier
- Profile type
- Creation and expiration dates
- Expiration status with color-coded warnings
- List of provisioned devices

## Architecture

### Components

- **IPAInfo.swift**: SwiftData model for storing IPA analysis results
- **IPAAnalyzer.swift**: Actor-based service for extracting and parsing provisioning profiles
- **ContentView.swift**: Main view with sidebar navigation and IPA list
- **IPADetailView.swift**: Detailed view showing all provisioning profile information
- **analyze-ipa.sh**: Shell script for command-line analysis

### How It Works

1. **IPA Extraction**: The IPA file (which is a ZIP archive) is extracted to a temporary directory
2. **Profile Location**: The app searches for `.mobileprovision` files within the app bundle
3. **Profile Parsing**: The provisioning profile is parsed to extract the embedded plist data
4. **Data Extraction**: Key information is extracted including:
   - Expiration and creation dates
   - Team information
   - Bundle identifier
   - Provisioned devices
   - Profile type
5. **Storage**: Results are stored using SwiftData for persistent history

## Status Indicators

- 🟢 **Green (Valid)**: Profile is valid and has more than 30 days remaining
- 🟠 **Orange (Expiring Soon)**: Profile has less than 30 days until expiration
- 🔴 **Red (Expired)**: Profile has already expired

## Keyboard Shortcuts

- **⌘O**: Open/Analyze new IPA file
- **⌘W**: Close window
- **⌘Q**: Quit application
- **⌘Delete**: Delete selected IPA from history

## Technical Details

### Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Data persistence and model management
- **Swift Concurrency**: Actor-based IPA analysis
- **AppKit Integration**: File picker dialogs using NSOpenPanel
- **Shell Scripting**: Command-line automation

### Provisioning Profile Structure

The app parses the following information from `.mobileprovision` files:
- `ExpirationDate`: When the profile expires
- `CreationDate`: When the profile was created
- `TeamName`: Developer team name
- `TeamIdentifier`: Developer team ID
- `Entitlements.application-identifier`: App bundle identifier
- `ProvisionedDevices`: Array of device UDIDs (for Ad Hoc/Development)
- `Entitlements.get-task-allow`: Indicates Development profile

## Troubleshooting

### "No provisioning profile found in IPA"

This error occurs when:
- The file is not a valid IPA
- The IPA is corrupted
- The IPA doesn't contain an embedded provisioning profile

### "Failed to parse provisioning profile data"

This can happen if:
- The provisioning profile format is invalid
- The embedded plist is corrupted

### Command-line script not working

Make sure:
- The script has execute permissions: `chmod +x analyze-ipa.sh`
- The path to the IPA file is correct
- You have the necessary command-line tools installed (PlistBuddy, security)

## Future Enhancements

Possible future features:
- Export analysis results to CSV/JSON
- Batch IPA analysis
- Notifications for expiring profiles
- Certificate information extraction
- Entitlements analysis
- App icon extraction and display

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]

## Support

For issues, questions, or feature requests, please [open an issue](your-repo-url/issues).
