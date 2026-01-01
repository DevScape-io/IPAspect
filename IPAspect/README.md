# IPAspect

A modern, native macOS application for analyzing iOS App (IPA) files and inspecting their provisioning profile details, expiration dates, and more.

![IPAspect Banner](Screenshots/banner.png)
*TODO: Add banner screenshot showing the app interface*

## Features

- 🔍 **Analyze IPA Files**: Drag and drop or select IPA files for instant analysis
- 📅 **Expiration Tracking**: View provisioning profile expiration dates with precise countdown
- 📊 **Visual Status Indicators**: Color-coded status badges (Valid, Expiring Soon, Expired)
- 🎨 **App Icon Display**: Automatically extracts and displays app icons from IPAs
- 📱 **Device Information**: Complete list of all provisioned devices in Ad Hoc and Development profiles
- 💾 **Persistent History**: All analyzed IPAs are stored locally using SwiftData
- 📤 **Export Options**: Export analysis results as JSON or CSV for reporting and automation
- 🎯 **Context Menus**: Right-click actions for quick access to common tasks
- 🖱️ **Swipe Gestures**: Natural macOS swipe-to-delete interactions
- 🎨 **Modern UI**: Clean, native macOS design following Apple's Human Interface Guidelines
- ⚡ **Performance**: Actor-based concurrent processing with Swift Concurrency
- 🖥️ **CLI Tools**: Command-line scripts for automation and batch processing

## Screenshots

### Main Window
![Main Window](Screenshots/main-window.png)
*TODO: Add screenshot of main window with sidebar and detail view*

### Detail View with Profile Information
![Detail View](Screenshots/detail-view.png)
*TODO: Add screenshot showing the profile details*

### Batch Analysis
![CLI Output](Screenshots/cli-output.png)
*TODO: Add screenshot of terminal showing batch analysis*

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

1. **Launch IPAspect**
2. **Add an IPA** using any method:
   - Click the **+** button in toolbar (or press **⌘O**)
   - Drag and drop an IPA file onto the sidebar
   - Double-click an IPA file (if IPAspect is set as default handler)
3. **Wait for analysis** - typically completes in 1-2 seconds
4. **View results** in the detail pane

#### What You'll See

**Sidebar (IPA List)**
- App icon (extracted from IPA)
- File name
- Status indicator with color coding:
  - 🟢 **Green**: Valid (>30 days remaining)
  - 🟠 **Orange**: Expiring Soon (<30 days)
  - 🔴 **Red**: Expired
- Days until expiration
- Relative analysis time

**Detail View (Selected IPA)**
- **Status Card**: Visual status with days remaining and expiration date
- **Progress Bar**: Shows profile lifetime elapsed
- **Profile Information**:
  - Team Name and Team Identifier
  - Bundle Identifier
  - Profile Type (Development, Ad Hoc, App Store, Enterprise)
  - Creation Date and Expiration Date
- **Provisioned Devices**: List of UDIDs (for Ad Hoc and Development profiles)
  - Device count
  - Copy button for each device ID
  - Shows first 10 devices by default

#### Keyboard Shortcuts

- **⌘O** - Open/Analyze new IPA file
- **⌘Delete** - Delete selected IPA from history
- **⌘W** - Close window
- **⌘Q** - Quit application

#### Context Menu Actions

Right-click any IPA in the sidebar to access:
- **View Details** - Select and show detail view
- **Show in Finder** - Reveal original IPA file location
- **Export Message** - Copy summary to clipboard
- **Delete** - Remove from history

#### Swipe Actions

Swipe left on any IPA row to reveal quick delete button.

#### Exporting Data

Click the **Export** menu in toolbar to export all analyzed IPAs:
- **Export as JSON** - Structured data with full details
- **Export as CSV** - Spreadsheet-compatible format

Perfect for:
- Team reporting and dashboards
- Automated monitoring systems
- Historical tracking
- Integration with other tools

### Using the Command-Line Tools

IPAspect includes two powerful shell scripts for automation and CI/CD integration.

#### Single IPA Analysis

```bash
# Make the script executable (first time only)
chmod +x analyze-ipa.sh

# Analyze an IPA file
./analyze-ipa.sh /path/to/your/app.ipa
```

**Output includes:**
- Team information (name and identifier)
- Bundle identifier
- Profile type
- Creation and expiration dates
- Expiration status with color-coded warnings
- Days remaining or days since expiration
- List of provisioned devices (if applicable)

**Example output:**
```
=== IPAspect - IPA Analyzer ===
Analyzing: MyApp.ipa

📦 Extracting IPA...
✓ Found provisioning profile

📋 Provisioning Profile Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Name:     My Development Team
Team ID:       ABC1234567
Bundle ID:     com.example.myapp
Profile Type:  Ad Hoc
Created:       Mon Dec 30 10:30:00 PST 2024
Expires:       Sun Jun 29 10:30:00 PDT 2025

⏰ Expiration Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ VALID (181 days remaining)

📱 Provisioned Devices
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Device Count: 3

✓ Analysis complete
```

#### Batch Analysis

```bash
# Make the script executable (first time only)
chmod +x batch-analyze-ipa.sh

# Analyze all IPAs in a directory
./batch-analyze-ipa.sh /path/to/ipa/directory

# Specify custom output filename
./batch-analyze-ipa.sh /path/to/ipa/directory custom-report.csv
```

**Generated CSV includes:**
- File Name
- Bundle ID
- Team Name
- Team ID
- Profile Type
- Creation Date
- Expiration Date
- Status (Valid/Expiring Soon/Expired)
- Days Remaining

Perfect for:
- CI/CD pipelines
- Automated monitoring
- Weekly/monthly reporting
- Team dashboards

## Architecture

### Overview

IPAspect is built with modern Swift technologies and follows Apple's best practices for macOS app development.

### Key Components

#### SwiftUI Views
- **`ContentView.swift`**: Main app interface with NavigationSplitView
  - Sidebar with IPA list and drag-and-drop support
  - Detail pane showing selected IPA information
  - Toolbar with analyze and export actions
- **`IPADetailView.swift`**: Detailed provisioning profile information display
  - Status card with visual indicators
  - Profile information sections
  - Provisioned devices list with copy functionality
- **`IPAListRow.swift`**: Sidebar row component showing IPA summary

#### Data Layer
- **`IPAInfo.swift`**: SwiftData model representing analyzed IPA
  - Stores all profile information
  - Computed properties for status and expiration
  - Persists between app launches
- **`IPAAnalyzer.swift`**: Actor-based service for IPA analysis
  - Extracts IPA contents (ZIP archive)
  - Locates and parses provisioning profile
  - Extracts app icon from app bundle
  - Thread-safe concurrent processing

#### Export & Utilities
- **`IPAExporter.swift`**: Export functionality
  - JSON export with ISO8601 dates
  - CSV export with proper escaping
  - NSSavePanel integration
- **Shell Scripts**: Command-line tools
  - `analyze-ipa.sh`: Single IPA analysis
  - `batch-analyze-ipa.sh`: Batch processing with CSV output

### How It Works

#### IPA Analysis Flow

1. **File Selection**
   - User selects IPA via file picker, drag-and-drop, or CLI
   - File URL is passed to `IPAAnalyzer` actor

2. **Extraction** (`extractIPA`)
   - IPA file is a ZIP archive containing the app bundle
   - Extracted to temporary directory using `unzip` command
   - Cleanup handled automatically with `defer`

3. **Profile Location** (`findProvisioningProfile`)
   - Recursively searches extracted contents
   - Locates `.mobileprovision` file(s)
   - Typically found at: `Payload/YourApp.app/embedded.mobileprovision`

4. **Profile Parsing** (`parseProvisioningProfile`)
   - Provisioning profile is CMS-signed plist
   - Extracts XML plist from binary wrapper
   - Parses plist using `PropertyListSerialization`
   - Extracts key information:
     - `ExpirationDate` and `CreationDate`
     - `TeamName` and `TeamIdentifier`
     - `Entitlements.application-identifier` (Bundle ID)
     - `ProvisionedDevices` array (UDIDs)
     - `Entitlements.get-task-allow` (determines Development vs Ad Hoc)

5. **Icon Extraction** (`extractAppIcon`)
   - Searches app bundle for icon files
   - Checks `Info.plist` for icon configuration
   - Tries multiple naming patterns and scales (@2x, @3x)
   - Returns PNG data if found

6. **Data Storage**
   - Creates `IPAInfo` model on Main Actor (SwiftData requirement)
   - Populates with parsed data
   - Inserts into SwiftData `ModelContext`
   - Automatically persists to disk

#### Profile Type Detection

```swift
if get-task-allow == true {
    type = "Development"
} else if ProvisionedDevices.count > 0 {
    type = "Ad Hoc"
} else if ProvisionedDevices.isEmpty {
    type = "App Store"
} else {
    type = "Enterprise"
}
```

#### Expiration Status Logic

- **Valid**: `expirationDate > now + 30 days`
- **Expiring Soon**: `0 < days <= 30`
- **Expired**: `days < 0`

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

- **SwiftUI**: Declarative UI framework for native macOS interface
- **SwiftData**: Model management and data persistence
- **Swift Concurrency**: Actor-based IPA analysis for thread safety
- **AppKit Integration**: 
  - `NSOpenPanel` for file picking
  - `NSSavePanel` for export
  - `NSWorkspace` for "Show in Finder"
  - `NSPasteboard` for clipboard operations
  - `NSImage` for icon display
- **Foundation**: Property list parsing, file management, data handling
- **Shell Scripting**: Bash scripts with color-coded output

### Provisioning Profile Structure

IPAspect parses the following information from `.mobileprovision` files:

| Key | Description | Type |
|-----|-------------|------|
| `ExpirationDate` | When the profile expires | Date |
| `CreationDate` | When the profile was created | Date |
| `TeamName` | Developer team name | String |
| `TeamIdentifier` | Developer team ID array | [String] |
| `Entitlements.application-identifier` | Full app bundle identifier with team prefix | String |
| `ProvisionedDevices` | Array of device UDIDs (Ad Hoc/Development only) | [String]? |
| `Entitlements.get-task-allow` | Indicates Development profile | Bool |
| `Entitlements.*` | Various app capabilities and entitlements | Various |

### File Formats

#### Provisioning Profile (.mobileprovision)
```
┌─────────────────────────────┐
│   CMS Signature Wrapper     │
│  (Binary data for signing)  │
├─────────────────────────────┤
│     <?xml version="1.0"?>   │
│     <plist version="1.0">   │
│     <dict>                   │
│       <key>TeamName</key>    │
│       <string>...</string>   │
│       ...                    │
│     </dict>                  │
│     </plist>                 │
│   (XML Property List Data)  │
└─────────────────────────────┘
```

#### IPA Structure
```
MyApp.ipa (ZIP archive)
├── Payload/
│   └── MyApp.app/
│       ├── Info.plist
│       ├── embedded.mobileprovision
│       ├── MyApp (binary)
│       ├── AppIcon60x60@2x.png
│       ├── AppIcon60x60@3x.png
│       └── ... (other assets)
├── iTunesArtwork
└── META-INF/ (optional)
```

## Troubleshooting

### Common Issues

#### "No provisioning profile found in IPA"

**Possible causes:**
- The file is not a valid IPA
- The IPA is corrupted or incomplete
- The IPA doesn't contain an embedded provisioning profile
- The IPA was created with unusual packaging

**Solutions:**
1. Verify the file is a valid IPA:
   ```bash
   file your-app.ipa
   # Should output: your-app.ipa: Zip archive data
   ```
2. Try extracting manually to check contents:
   ```bash
   unzip your-app.ipa -d extracted
   find extracted -name "*.mobileprovision"
   ```
3. Re-export the IPA from Xcode with proper settings:
   - Ensure "Rebuild from Bitcode" is set appropriately
   - Select correct provisioning profile during export
   - Verify profile is not expired

#### "Failed to parse provisioning profile data"

**Possible causes:**
- The provisioning profile format is invalid
- The embedded plist is corrupted
- Unexpected profile structure

**Solutions:**
1. Check the profile manually:
   ```bash
   # Extract the profile
   unzip your-app.ipa -d temp
   # View the profile (macOS will decode it)
   security cms -D -i temp/Payload/*.app/embedded.mobileprovision
   ```
2. Verify profile in Xcode:
   - Open Xcode → Preferences → Accounts
   - Select your team → Manage Certificates
   - Download latest profiles

#### App won't open/analyze IPA

**Possible causes:**
- File permissions issues
- File extension mismatch
- File is not a valid ZIP/IPA

**Solutions:**
1. Check file extension: `.ipa` (case-insensitive)
2. Verify file permissions:
   ```bash
   ls -la your-app.ipa
   # Ensure you have read permissions
   ```
3. Test if it's a valid ZIP:
   ```bash
   unzip -t your-app.ipa
   ```

#### Command-line script not working

**Possible causes:**
- Script doesn't have execute permissions
- Missing required commands (`unzip`, `security`, `PlistBuddy`)
- Path to IPA contains special characters

**Solutions:**
1. Make script executable:
   ```bash
   chmod +x analyze-ipa.sh
   ```
2. Verify required tools are available:
   ```bash
   which unzip security
   # Both should return paths
   ```
3. Use absolute paths:
   ```bash
   ./analyze-ipa.sh "$(pwd)/your-app.ipa"
   ```

#### SwiftData persistence issues

**Symptoms:**
- Analysis history not persisting between launches
- App crashes on startup

**Solutions:**
1. Reset app data (delete SwiftData store):
   ```bash
   # Close the app first
   rm -rf ~/Library/Containers/com.yourteam.IPAspect/Data/Library/Application\ Support/
   ```
2. Check for disk space
3. Verify app has proper file system permissions

### Performance Tips

- **Large IPAs**: Analysis time scales with IPA size (typically 1-3 seconds)
- **Batch Processing**: Use command-line tools for 10+ IPAs
- **Icon Extraction**: Disable if not needed (modify `IPAAnalyzer.swift`)
- **History Management**: Periodically delete old analyses to keep database lean

## Future Enhancements

IPAspect has a solid foundation and many potential improvements:

### Planned Features
- [ ] **Automatic Notifications**: macOS Notification Center alerts for expiring profiles
- [ ] **Profile Comparison**: Diff view comparing two versions of the same app
- [ ] **Certificate Details**: Extract and display certificate chain information
- [ ] **Entitlements Viewer**: Comprehensive view of app capabilities and permissions
- [ ] **Version History**: Track changes over time for same bundle ID
- [ ] **Watch App**: Quick glanceable profile checks on Apple Watch
- [ ] **Menu Bar Mode**: Background monitoring with menu bar app

### Integration Ideas
- [ ] **Apple Developer Portal API**: Automatic profile renewal and management
- [ ] **Slack/Discord Webhooks**: Team notifications for expiring profiles
- [ ] **CI/CD Integration**: GitHub Actions, GitLab CI, Bitrise plugins
- [ ] **Cloud Sync**: iCloud sync for analysis history across Macs
- [ ] **Team Sharing**: Collaborative analysis database

### Advanced Features
- [ ] **Entitlements Comparison**: Compare capabilities between IPAs
- [ ] **Size Analysis**: Break down IPA size by component
- [ ] **Framework Detection**: List embedded frameworks and their versions
- [ ] **Localization Check**: Detect supported languages
- [ ] **Privacy Manifest**: Parse and display Privacy Info plist
- [ ] **App Thinning**: Analyze which device variants are included

### Already Implemented ✅
- [x] IPA extraction and parsing
- [x] Provisioning profile analysis
- [x] App icon extraction
- [x] SwiftData persistence
- [x] JSON/CSV export
- [x] Batch processing CLI
- [x] Drag and drop support
- [x] Context menus and swipe gestures
- [x] Status indicators and progress bars

## Contributing

Contributions are welcome! Here's how you can help:

### Ways to Contribute
1. **Bug Reports**: Open an issue with detailed reproduction steps
2. **Feature Requests**: Suggest new features with use cases
3. **Code Contributions**: Submit pull requests with improvements
4. **Documentation**: Improve guides and add examples
5. **Testing**: Test on different macOS versions and report issues

### Development Setup
```bash
# Clone the repository
git clone <repository-url>
cd IPAspect

# Open in Xcode
open IPAspect.xcodeproj

# Build and run
# Press ⌘R in Xcode
```

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for consistency (if available)
- Add comments for complex logic
- Write descriptive commit messages

### Before Submitting PR
- [ ] Test on macOS 14.0+
- [ ] Ensure code compiles without warnings
- [ ] Update documentation if needed
- [ ] Add tests for new features (if applicable)

## License

[Add your license here - MIT, Apache 2.0, etc.]

## Support

### Getting Help
- 📖 **Documentation**: Read [QUICKSTART.md](QUICKSTART.md) and [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
- 🐛 **Issues**: Report bugs via GitHub Issues
- 💬 **Discussions**: Ask questions in GitHub Discussions
- 📧 **Contact**: [Add contact information]
### Useful Resources
- [Apple Developer Documentation - Code Signing](https://developer.apple.com/documentation/xcode/code-signing)
- [Provisioning Profile Format](https://developer.apple.com/documentation/bundleresources/information_property_list)
- [IPA File Structure](https://en.wikipedia.org/wiki/.ipa)

## Acknowledgments

Built with ❤️ using modern Apple technologies:
- Swift 5.9+
- SwiftUI & SwiftData
- Swift Concurrency (Actor model)
- macOS Sonoma (14.0+)

Special thanks to the Swift community and Apple's comprehensive documentation.

---

**IPAspect** - Inspect Your IPAs with Clarity 🔍

