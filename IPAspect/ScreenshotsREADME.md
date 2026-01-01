# Screenshots Guide

This directory contains screenshots for documentation.

## Required Screenshots

### 1. Banner Image
**File**: `banner.png`  
**Size**: 1280x640px (2:1 ratio)  
**Content**: Hero image showing the app with a polished, professional look  
**Tips**:
- Use a clean background
- Show both sidebar and detail view
- Include 2-3 analyzed IPAs with different status colors
- Ensure good contrast and readability

### 2. Main Window
**File**: `main-window.png`  
**Size**: 1200x800px  
**Content**: Full app window showing:
- Sidebar with multiple analyzed IPAs
- Different status indicators (green, orange, red)
- App icons displayed
- Selected IPA with detail view visible

**How to capture:**
1. Launch IPAspect
2. Analyze 3-5 different IPAs with varying expiration dates
3. Select one IPA to show details
4. Press ⌘⇧4, then Space, then click the window
5. Rename to `main-window.png`

### 3. Detail View
**File**: `detail-view.png`  
**Size**: 800x1000px  
**Content**: Close-up of the detail pane showing:
- Status card with expiration info
- Progress bar
- Profile information section
- Provisioned devices (if available)

**How to capture:**
1. Select an IPA with an interesting profile (Ad Hoc with devices)
2. Scroll to show all sections
3. Take a screenshot of just the detail pane
4. Crop to remove extra space

### 4. CLI Output
**File**: `cli-output.png`  
**Size**: 800x600px  
**Content**: Terminal showing:
- Running `analyze-ipa.sh` command
- Color-coded output
- Complete analysis results

**How to capture:**
1. Open Terminal
2. Run: `./analyze-ipa.sh path/to/sample.ipa`
3. Screenshot the terminal window
4. Ensure all colors are visible

## Screenshot Tips

### General Guidelines
- Use **light mode** for better readability in documentation
- Ensure **high resolution** (Retina/2x if possible)
- **Clean up** any personal information (team names, bundle IDs)
- Use **representative data** (not "Test App 123")
- Maintain **consistent styling** across all screenshots

### macOS Screenshot Shortcuts
- **⌘⇧3**: Full screen
- **⌘⇧4**: Selection
- **⌘⇧4 + Space**: Window capture (with shadow)
- **⌘⇧5**: Screenshot app with recording options

### Editing Screenshots
1. **Preview.app**: 
   - Open screenshot
   - Tools → Adjust Size (for resizing)
   - Tools → Annotate (for arrows/highlights)

2. **Pixelmator Pro** or **Affinity Photo**:
   - More advanced editing
   - Add text overlays
   - Adjust lighting/contrast

### Annotating (Optional)
- Add arrows to highlight key features
- Use circles to draw attention to important elements
- Add text labels for clarity
- Keep annotations minimal and professional

## Sample Data Preparation

Before taking screenshots, prepare sample IPAs:

1. **Valid Profile** (Green)
   - Expiration: 180+ days
   - Type: App Store
   - Name: "ProductionApp.ipa"

2. **Expiring Soon** (Orange)
   - Expiration: 15 days
   - Type: Ad Hoc
   - Name: "TestBuild.ipa"
   - Include provisioned devices

3. **Expired** (Red)
   - Expiration: -30 days (past)
   - Type: Development
   - Name: "OldDevelopment.ipa"

## Updating Documentation

After adding screenshots:

1. Remove the `*TODO: Add screenshot...*` comments
2. Verify all image links work:
   ```markdown
   ![Alt text](Screenshots/filename.png)
   ```
3. Commit screenshots with descriptive messages:
   ```bash
   git add Screenshots/
   git commit -m "Add documentation screenshots"
   ```

## File Checklist

- [ ] `banner.png` - Hero/banner image
- [ ] `main-window.png` - Full app interface
- [ ] `detail-view.png` - Detail pane close-up
- [ ] `cli-output.png` - Terminal output

## Notes

- Screenshots should be in PNG format for best quality
- Keep total size under 5MB for the entire directory
- Update this README if adding new screenshot types
- Consider adding a GIF or video for animated features (drag-and-drop, swipe gestures)

## Optional Enhancements

### Animated GIFs
Create short GIFs showing:
- Drag and drop functionality
- Swipe to delete gesture
- Analysis progress
- Export workflow

**Tools:**
- **GIPHY Capture** (free, easy)
- **Kap** (open source)
- **LICEcap** (cross-platform)

**Guidelines:**
- Keep under 10 seconds
- 30 fps, < 2MB file size
- Show one feature per GIF

### Dark Mode Screenshots
Consider adding dark mode variants:
- `main-window-dark.png`
- `detail-view-dark.png`

Users can toggle between them in documentation.

---

*This guide was generated for IPAspect documentation. Follow these steps to create professional, informative screenshots.*
