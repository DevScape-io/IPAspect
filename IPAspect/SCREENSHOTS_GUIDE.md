# Screenshots Guide for IPAspect Documentation

This guide explains how to capture and add screenshots to complete the documentation.

## Why Screenshots Matter

Good screenshots:
- Help users understand the UI before downloading
- Provide visual context for features
- Make documentation more engaging and professional
- Reduce support questions by showing expected behavior

## Required Screenshots

### 1. Banner/Hero Image
**Purpose**: Eye-catching header image for README  
**Location**: `Screenshots/banner.png`  
**Dimensions**: 1280×640px (2:1 aspect ratio)  

**What to show**:
- Full IPAspect window with attractive sample data
- Both sidebar and detail view clearly visible
- Multiple IPAs with different status colors (green, orange, red)
- Professional appearance with real-looking (but anonymized) data

**Capture steps**:
1. Prepare 4-5 analyzed IPAs with varying statuses
2. Select an IPA with interesting profile details
3. Position window to optimal size (~1200px wide)
4. Use ⌘⇧4 → Space → Click window for clean capture
5. Open in Preview → Tools → Adjust Size → 1280×640
6. Save as `Screenshots/banner.png`

---

### 2. Main Window Screenshot
**Purpose**: Show complete app interface  
**Location**: `Screenshots/main-window.png`  
**Dimensions**: 1200×800px minimum  

**What to show**:
- **Sidebar** with:
  - 3-5 analyzed IPAs
  - Mix of status indicators (🟢🟠🔴)
  - App icons visible
  - Different file names
  - Relative timestamps
- **Detail view** with:
  - Selected IPA information
  - Status card visible
  - Profile information section
  - At least partial device list (if applicable)
- **Toolbar** with:
  - + button
  - Export menu
  - Clean, uncluttered appearance

**Capture steps**:
```bash
# 1. Launch IPAspect
open IPAspect.app

# 2. Prepare sample data (analyze 3-5 IPAs)
#    - Include mix of Development, Ad Hoc, App Store types
#    - Include mix of Valid, Expiring Soon, Expired statuses

# 3. Select an interesting IPA (preferably Ad Hoc with devices)

# 4. Resize window to ~1200×800px

# 5. Capture window
# Press: ⌘⇧4, then Space, then click the window

# 6. Save as Screenshots/main-window.png
```

---

### 3. Detail View Close-up
**Purpose**: Show provisioning profile details  
**Location**: `Screenshots/detail-view.png`  
**Dimensions**: 700×900px approximately  

**What to show**:
- **Header section** with app icon and filename
- **Status card** showing:
  - Visual indicator (checkmark/warning/error icon)
  - Status text ("Valid", "Expiring Soon", or "Expired")
  - Days remaining
  - Expiration date
- **Progress bar** (if valid profile)
- **Profile Information** section with all fields:
  - Team Name
  - Team ID
  - Bundle ID
  - Profile Type
  - Creation Date
- **Provisioned Devices** section (if available):
  - Device count
  - List of UDIDs with copy buttons
  - "and X more..." text if >10 devices

**Capture steps**:
1. Select an Ad Hoc or Development IPA with provisioned devices
2. Take full window screenshot
3. Crop to just the detail pane (right side)
4. Remove extra whitespace at edges
5. Save as `Screenshots/detail-view.png`

---

### 4. Terminal/CLI Output
**Purpose**: Show command-line tool output  
**Location**: `Screenshots/cli-output.png`  
**Dimensions**: 800×600px minimum  

**What to show**:
- Terminal window with:
  - Command: `./analyze-ipa.sh SampleApp.ipa`
  - Complete output including:
    - Extraction progress (📦)
    - Profile information section
    - Expiration status with color coding
    - Device list (if applicable)
  - All colors visible (green, yellow, red, blue)

**Capture steps**:
```bash
# 1. Open Terminal.app

# 2. Navigate to IPAspect directory
cd /path/to/IPAspect

# 3. Run analysis script
./analyze-ipa.sh /path/to/sample.ipa

# 4. Resize terminal to show complete output

# 5. Screenshot terminal window
# Press: ⌘⇧4, then Space, then click Terminal window

# 6. Save as Screenshots/cli-output.png
```

---

## Preparing Sample Data

### Creating Sample IPAs

To create representative screenshots, you need sample IPA files with different characteristics.

#### Option 1: Use Real IPAs (Recommended)
If you have existing IPA files from your development:
1. Choose 3-5 different apps
2. Ensure they have different profile types and expiration dates
3. **Anonymize** sensitive information if sharing publicly

#### Option 2: Export from Sample Project
1. Create/open any Xcode project
2. Archive the app (Product → Archive)
3. Export with different provisioning profiles:
   - Development
   - Ad Hoc (add test devices)
   - App Store

#### Sample Data Characteristics

Create IPAs with these profiles:

| IPA Name | Type | Status | Days Remaining | Devices |
|----------|------|--------|----------------|---------|
| ProductionApp.ipa | App Store | Valid | 200 | 0 |
| TestBuild.ipa | Ad Hoc | Expiring Soon | 15 | 5 |
| DevBuild.ipa | Development | Valid | 90 | 3 |
| OldApp.ipa | Ad Hoc | Expired | -45 | 10 |
| EnterpriseApp.ipa | Enterprise | Valid | 180 | 0 |

### Anonymizing Data

Before taking screenshots:

1. **Bundle IDs**: Use generic names
   - ❌ `com.acmecorp.secretproject`
   - ✅ `com.example.myapp`

2. **Team Names**: Use placeholder names
   - ❌ "ACME Corporation Inc."
   - ✅ "My Development Team"

3. **Device UDIDs**: 
   - Real UDIDs are fine (they're not sensitive)
   - Or use: `00008030-001234567890001E` pattern

4. **File Paths**: Keep generic
   - ❌ `/Users/john.doe/Desktop/SecretProject/`
   - ✅ `/path/to/sample.ipa`

---

## Screenshot Best Practices

### Technical Requirements
- **Format**: PNG (for quality and transparency)
- **Resolution**: Retina/2x (high DPI)
- **Color Mode**: RGB
- **Compression**: Medium (balance quality and file size)
- **Max File Size**: 500KB per screenshot (compress if needed)

### Visual Guidelines

#### ✅ DO
- Use **light mode** (better readability in docs)
- Show **real-looking data** (meaningful names)
- Keep window size **consistent** across screenshots
- Ensure **high contrast** and readability
- Show **diverse examples** (different profile types)
- Use **clean backgrounds** (remove desktop clutter)

#### ❌ DON'T
- Don't show **personal information** (real team names)
- Don't use **tiny windows** (hard to see details)
- Don't include **desktop clutter** (messy background)
- Don't use **dark mode** (unless specifically for dark mode docs)
- Don't show **error states** (unless documenting errors)
- Don't use **"Test App" or "Lorem Ipsum"** (use realistic names)

### Composition Tips

1. **Focus**: Make sure the subject is clear
2. **Spacing**: Leave some breathing room around edges
3. **Alignment**: Keep elements visually balanced
4. **Hierarchy**: Most important info should stand out
5. **Context**: Show enough to understand the feature

---

## Taking Screenshots on macOS

### Built-in Tools

#### Screenshot Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| ⌘⇧3 | Capture entire screen |
| ⌘⇧4 | Capture selection |
| ⌘⇧4 + Space | Capture window (with shadow) |
| ⌘⇧5 | Open Screenshot app |

#### Screenshot App (⌘⇧5)
Best for:
- Recording screen videos
- Timed captures
- Custom options (show/hide cursor, etc.)

### Editing Tools

#### Preview.app (Built-in)
**Best for**: Quick edits, resizing, annotations

```
1. Open screenshot in Preview
2. Tools → Adjust Size... (resize)
3. Tools → Annotate (add arrows, text)
4. File → Export (save as PNG)
```

#### Third-Party Tools

1. **Pixelmator Pro** ($40)
   - Professional image editing
   - Layer support
   - Advanced filters

2. **Sketch** ($99/year)
   - Vector editing
   - Perfect for mockups
   - Export at multiple sizes

3. **CleanShot X** ($29)
   - Enhanced screenshots
   - Annotations
   - Cloud storage

---

## Post-Processing

### Resizing Screenshots

Using **Preview.app**:
```
1. File → Open (select screenshot)
2. Tools → Adjust Size
3. Set dimensions (maintain aspect ratio)
4. Resolution: 144 DPI (Retina) or 72 DPI (standard)
5. File → Export → Save as PNG
```

Using **sips** (command line):
```bash
# Resize to specific width (maintains aspect ratio)
sips -Z 1200 screenshot.png

# Resize to exact dimensions
sips -z 800 1200 screenshot.png
```

### Compressing Images

Using **ImageOptim** (free):
```
1. Download from imageoptim.com
2. Drag screenshots into app
3. Automatically compresses without quality loss
```

Using **pngquant** (command line):
```bash
# Install
brew install pngquant

# Compress
pngquant --quality=80-90 screenshot.png
```

### Adding Annotations

Using **Preview.app**:
```
1. Tools → Annotate
2. Click arrow/text/shape tools
3. Add highlights to key features
4. Keep minimal and professional
5. Use consistent colors (e.g., red arrows)
```

**Annotation Guidelines**:
- Use sparingly (only for important highlights)
- Consistent style (same arrow type, colors)
- Professional colors (avoid neon or garish colors)
- Clear, readable text
- Don't cover important UI elements

---

## Adding Screenshots to Documentation

### 1. Place Files

```bash
# Create Screenshots directory if needed
mkdir -p Screenshots

# Move/copy screenshots
cp ~/Desktop/main-window.png Screenshots/
cp ~/Desktop/detail-view.png Screenshots/
cp ~/Desktop/cli-output.png Screenshots/
cp ~/Desktop/banner.png Screenshots/
```

### 2. Update README.md

Replace TODO comments with actual images:

```markdown
# Before
![Main Window](Screenshots/main-window.png)
*TODO: Add screenshot showing sidebar and detail view*

# After
![Main Window](Screenshots/main-window.png)
*IPAspect main window showing analyzed IPAs with status indicators*
```

### 3. Update QUICKSTART.md

Same process - replace TODO comments with captions.

### 4. Verify Links

```bash
# Check if all image files exist
ls -la Screenshots/

# Expected files:
# - banner.png
# - main-window.png
# - detail-view.png
# - cli-output.png
```

### 5. Test Locally

View README.md in a Markdown viewer:
- **Typora** (WYSIWYG Markdown editor)
- **Marked 2** (Markdown preview app)
- **VS Code** with Markdown preview
- **GitHub** (push and view online)

### 6. Optimize File Sizes

```bash
# Check current sizes
du -h Screenshots/*.png

# If any file > 500KB, compress:
pngquant --quality=80-90 Screenshots/*.png
```

---

## Checklist

Before committing screenshots:

- [ ] All 4 required screenshots created
- [ ] Images are PNG format
- [ ] Images are high resolution (Retina/2x)
- [ ] No personal/sensitive information visible
- [ ] Sample data looks realistic and professional
- [ ] File sizes are reasonable (<500KB each)
- [ ] Images are clear and readable
- [ ] Consistent visual style across all screenshots
- [ ] README.md updated with actual images (TODOs removed)
- [ ] QUICKSTART.md updated with actual images (TODOs removed)
- [ ] Screenshots committed to git
- [ ] Documentation renders correctly on GitHub

---

## Git Commands

```bash
# Add screenshots
git add Screenshots/

# Commit
git commit -m "Add documentation screenshots

- Main window showing IPA analysis interface
- Detail view with profile information
- CLI tool output with color coding
- Hero banner image for README"

# Push
git push origin main
```

---

## Optional Enhancements

### Animated GIFs

Show dynamic features:

**Drag and Drop GIF**:
```
1. Open GIPHY Capture or Kap
2. Start recording
3. Drag IPA file onto sidebar
4. Wait for analysis complete
5. Stop recording
6. Export as GIF
7. Save as Screenshots/drag-drop.gif
```

**Swipe to Delete GIF**:
```
1. Start recording
2. Swipe left on IPA row
3. Tap delete button
4. Show confirmation
5. Export as Screenshots/swipe-delete.gif
```

### Dark Mode Screenshots

Create alternative dark mode versions:
```
Screenshots/
├── main-window.png         (light mode)
├── main-window-dark.png    (dark mode)
├── detail-view.png         (light mode)
└── detail-view-dark.png    (dark mode)
```

Toggle in documentation:
```markdown
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Screenshots/main-window-dark.png">
  <img src="Screenshots/main-window.png" alt="Main Window">
</picture>
```

### Video Walkthrough

Create a 30-second app demo:
1. Use QuickTime Player → File → New Screen Recording
2. Show: opening app, analyzing IPA, viewing details, exporting
3. Edit in iMovie or Final Cut Pro
4. Upload to YouTube or Vimeo
5. Embed in README

---

## Troubleshooting

### Screenshots Look Blurry
**Solution**: Ensure you're on a Retina display or increase resolution

### File Size Too Large
**Solution**: Use ImageOptim or pngquant to compress

### Colors Look Different
**Solution**: Check your display color profile (System Preferences → Displays)

### Can't Capture Window with Shadow
**Solution**: Use ⌘⇧4 → Space (not ⌘⇧5)

---

## Examples from Other Projects

Study these well-documented projects:

1. **SF Symbols Browser**: Clean UI screenshots
2. **Dato**: Beautiful macOS menu bar app screenshots
3. **Xcode**: Apple's official screenshots (gold standard)
4. **Fork**: Git client with excellent documentation

---

**Need help?** Open an issue or refer to [Apple's macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos) for UI best practices.
