# Quick Start Guide - IPAspect

## Getting Started in 5 Minutes

### 1. Build the App
```bash
# Open the project in Xcode
open IPAspect.xcodeproj

# Or build from command line
xcodebuild -project IPAspect.xcodeproj -scheme IPAspect -configuration Release
```

### 2. Run the App
- Press **⌘R** in Xcode, or
- Run the built app from `~/Library/Developer/Xcode/DerivedData/`

### 3. Analyze Your First IPA

**Method 1: Using the GUI**
1. Click the **+** button (or press **⌘O**)
2. Select an `.ipa` file
3. View the results in the detail pane

**Method 2: Using the Command Line**
```bash
# Make the script executable
chmod +x analyze-ipa.sh

# Analyze a single IPA
./analyze-ipa.sh /path/to/your/app.ipa

# Batch analyze multiple IPAs
chmod +x batch-analyze-ipa.sh
./batch-analyze-ipa.sh /path/to/ipa/directory output-report.csv
```

## What You'll See

### In the App
- **Sidebar**: List of all analyzed IPAs with status indicators
  - 🟢 Green = Valid (>30 days)
  - 🟠 Orange = Expiring Soon (<30 days)
  - 🔴 Red = Expired
  
- **Detail View**: Complete provisioning profile information
  - Expiration date and countdown
  - Team name and identifier
  - Bundle identifier
  - Profile type (Development, Ad Hoc, App Store)
  - List of provisioned devices (if applicable)

### In the Terminal
Color-coded output showing:
- Team information
- Bundle ID
- Profile type
- Creation and expiration dates
- Status (Valid/Expiring Soon/Expired)
- Provisioned devices

## Common Tasks

### Export Analysis Results
1. Click the **Export** menu in toolbar
2. Choose JSON or CSV format
3. Save the file

### Delete an Analyzed IPA
- Select the IPA in sidebar
- Press **Delete** or right-click → Delete

### Analyze Multiple IPAs
```bash
# Batch process all IPAs in a directory
./batch-analyze-ipa.sh ~/Desktop/IPAs

# Creates: ipa-analysis-YYYYMMDD-HHMMSS.csv
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
   - `⌘Delete` - Delete selected
   - `⌘W` - Close window
   - `⌘Q` - Quit app

2. **Batch Processing**
   - Use `batch-analyze-ipa.sh` for CI/CD pipelines
   - Export results and track expiration trends
   - Set up automated notifications for expiring profiles

3. **Export Data**
   - Export to CSV for spreadsheet analysis
   - Export to JSON for integration with other tools
   - Track historical data over time

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

Consider extending IPAspect with:
- Automatic notifications for expiring profiles
- Integration with Apple Developer Portal API
- Certificate chain validation
- Icon extraction and display
- Version history tracking
- Team collaboration features

Happy analyzing! 🎉
