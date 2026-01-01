# Quick Start Guide - IPAspect

Get up and running with IPAspect in just 5 minutes!

## Getting Started

### 1. Build the App
```bash
# Open the project in Xcod
open IPAspect.xcodeproj

# Or build from command line
xcodebuild -project IPAspect.xcodeproj -scheme IPAspect -configuration Release
```

### 2. Run the App
- Press **⌘R** in Xcode, or
- Run the built app from Applications folder

### 3. Analyze Your First IPA

**Method 1: Using the GUI (Recommended)**
1. Launch IPAspect
2. Click the **+** button in the toolbar (or press **⌘O**)
3. Select an `.ipa` file from the file picker
4. Wait for analysis to complete
5. View detailed results in the main window

**Method 2: Drag and Drop**
1. Launch IPAspect
2. Drag any `.ipa` file onto the app's sidebar
3. View the results instantly

**Method 3: Using the Command Line**
```bash
# Make the script executable (first time only)
chmod +x analyze-ipa.sh

# Analyze a single IPA
./analyze-ipa.sh /path/to/your/app.ipa

# Batch analyze multiple IPAs
chmod +x batch-analyze-ipa.sh
./batch-analyze-ipa.sh /path/to/ipa/directory
```

## What You'll See

### App Interface Overview

![IPAspect Main Window](Screenshots/main-window.png)
*TODO: Add screenshot showing sidebar with analyzed IPAs and detail view*

#### Sidebar
The left sidebar shows all analyzed IPAs with:
- **App Icon**: Extracted from the IPA (when available)
- **File Name**: The IPA filename
- **Status Indicator**: Color-coded expiration status
  - 🟢 **Green** = Valid (>30 days remaining)
  - 🟠 **Orange** = Expiring Soon (<30 days)
  - 🔴 **Red** = Expired
- **Expiration Info**: "Expires in X days" countdown
- **Analysis Date**: When the IPA was analyzed (relative time)

#### Detail View
The main detail pane displays comprehensive information:

**Profile Status Card**
- Visual status indicator with icon
- Days remaining (or days since expiration)
- Expiration date
- Progress bar showing profile lifetime

**Profile Information**
- Team Name
- Team ID
- Bundle Identifier
- Profile Type (Development, Ad Hoc, App Store, Enterprise)
- Creation Date

**Provisioned Devices** (for Ad Hoc and Development profiles)
- Device count
- List of device UDIDs
- Copy button for each device ID

![Detail View](Screenshots/detail-view.png)
*TODO: Add screenshot showing the detail view with profile information*

### Terminal Output

When using the command-line scripts, you'll see beautiful color-coded output:

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
  • 00008030-001234567890001E
  • 00008030-001234567890002E
  • 00008030-001234567890003E

✓ Analysis complete
```

## Common Tasks

### Export Analysis Results
IPAspect supports exporting your analysis data in two formats:

1. **Export as JSON**
   - Click the **Export** menu in toolbar → "Export as JSON..."
   - Choose save location
   - Perfect for programmatic processing and automation

2. **Export as CSV**
   - Click the **Export** menu in toolbar → "Export as CSV..."
   - Choose save location
   - Open in Numbers, Excel, or Google Sheets

**Exported CSV includes:**
- File Name
- Bundle ID
- Team Name
- Team ID
- Profile Type
- Creation Date
- Expiration Date
- Status (Valid/Expired)
- Days Until Expiration
- Has App Icon
- Analyzed Date

### Delete an Analyzed IPA
Multiple ways to remove IPAs from history:
- Select the IPA in sidebar → Press **⌘Delete**
- Right-click → "Delete"
- Swipe left on the IPA row → Tap red trash button

### Manage IPA Files
- **Show in Finder**: Right-click an IPA → "Show in Finder"
- **Export Message**: Right-click → "Export Message" (copies summary to clipboard)
- **View Details**: Right-click → "View Details" (selects and shows detail view)

### Analyze Multiple IPAs
```bash
# Batch process all IPAs in a directory
./batch-analyze-ipa.sh ~/Desktop/IPAs

# Specify custom output filename
./batch-analyze-ipa.sh ~/Desktop/IPAs my-report.csv

# Default output: ipa-analysis-YYYYMMDD-HHMMSS.csv
```

## Understanding the Results

### Profile Types
- **Development**: Used for testing on registered devices during development
- **Ad Hoc**: Used for distributing to specific devices outside the App Store
- **App Store**: Used for submitting to the App Store
- **Enterprise**: Used for internal distribution in organizations

### Expiration Status
- **Valid**: Profile is active with plenty of time remaining
- **Expiring Soon**: Less than 30 days until expiration (renew soon!)
- **Expired**: Profile is no longer valid (must be renewed)

### Why Expiration Matters
- **Expired Development profiles** prevent building to test devices
- **Expired Ad Hoc profiles** prevent app installation
- **App Store profiles** typically have 1-year validity
- Always renew before expiration to avoid distribution issues

## Troubleshooting

### "No provisioning profile found"
- The IPA might be corrupted
- The IPA might not have an embedded profile
- Try re-exporting from Xcode with the profile included

### "Failed to parse provisioning profile"
- The profile format might be invalid
- Try extracting the IPA manually to check its contents:
  ```bash
  unzip your-app.ipa -d extracted
  find extracted -name "*.mobileprovision"
  ```

### App won't open IPA
- Ensure the file has `.ipa` extension
- Check file permissions
- Verify the IPA is a valid ZIP archive

## Pro Tips

1. **Keyboard Shortcuts**
   - `⌘O` - Open/Analyze IPA
   - `⌘Delete` - Delete selected IPA
   - `⌘W` - Close window
   - `⌘Q` - Quit app

2. **Drag and Drop**
   - Drag `.ipa` files directly onto the sidebar for instant analysis
   - Works even when analyzing another IPA

3. **Context Menus**
   - Right-click any IPA for quick actions:
     - View Details
     - Show in Finder
     - Export Message (clipboard-ready summary)
     - Delete

4. **Swipe Actions**
   - Swipe left on any IPA in the sidebar for quick delete
   - Full swipe deletes immediately

5. **Batch Processing**
   - Use `batch-analyze-ipa.sh` for CI/CD pipelines
   - Export results to track expiration trends
   - Set up automated notifications for expiring profiles

6. **Data Persistence**
   - All analyzed IPAs are stored using SwiftData
   - Analysis history persists between app launches
   - App icons are cached for faster display

7. **Export Workflow**
   - Export to CSV for spreadsheet analysis and reporting
   - Export to JSON for integration with other tools or automation
   - Track historical data over time by keeping exported files

## Integration Ideas

### CI/CD Pipeline
```bash
# In your build script
./analyze-ipa.sh ./build/output/MyApp.ipa

# Check exit code
if [ $? -ne 0 ]; then
    echo "Profile analysis failed!"
    exit 1
fi
```

### Automated Monitoring
```bash
# Cron job to check profiles weekly
0 9 * * 1 /path/to/batch-analyze-ipa.sh /path/to/ipa/archive >> /var/log/ipa-check.log
```

### Team Dashboard
Export CSV to a shared location and import into your team dashboard for visibility into profile status across all apps.

## Need Help?

- Check the main [README.md](README.md) for detailed documentation
- Review [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for technical details
- Check the code comments for implementation specifics

## What's Next?

IPAspect is actively maintained and open to enhancements! Consider contributing or extending with:

**Potential Features:**
- Automatic notifications for expiring profiles (macOS Notification Center integration)
- Integration with Apple Developer Portal API for automatic renewal
- Certificate chain validation and detailed certificate info
- Entitlements analysis and comparison
- Version history tracking for the same bundle ID
- Team collaboration features (shared analysis databases)
- Watch app support for quick profile checks
- Menu bar app for background monitoring
- Profile comparison view (diff between versions)

**Already Implemented:**
- ✅ App icon extraction and display
- ✅ SwiftData persistence with full history
- ✅ JSON and CSV export
- ✅ Batch analysis tools
- ✅ Modern SwiftUI interface with native macOS design
- ✅ Actor-based concurrent processing
- ✅ Comprehensive error handling

## Contributing

Have ideas? Found a bug? Contributions are welcome!
- Check out [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for technical details
- Review the codebase and suggest improvements
- Add new features and submit pull requests

Happy analyzing! 🎉
