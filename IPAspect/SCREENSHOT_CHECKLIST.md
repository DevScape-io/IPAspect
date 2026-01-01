# Quick Screenshot Capture Checklist

Use this as a quick reference when you're ready to capture screenshots for IPAspect documentation.

## Prerequisites

- [ ] IPAspect app built and running
- [ ] 4-5 sample IPA files ready (with different profiles)
- [ ] macOS screenshot tools available (⌘⇧4)
- [ ] Optional: ImageOptim installed for compression

## Sample Data Needed

Analyze these types of IPAs first:

1. **Valid/Green** - App Store profile, 200+ days remaining
2. **Expiring/Orange** - Ad Hoc profile, 10-20 days remaining, 3-5 devices
3. **Expired/Red** - Development profile, expired 30+ days ago
4. **With Icon** - At least one IPA with extractable app icon
5. **With Devices** - Ad Hoc or Development with provisioned devices list

## Screenshot 1: Banner Image

**File**: `Screenshots/banner.png`  
**Size**: 1280×640px  

```bash
# Steps:
1. Launch IPAspect
2. Analyze 4-5 different IPAs
3. Select an interesting IPA (Ad Hoc with devices)
4. Resize window to ~1200px wide
5. Press ⌘⇧4 → Space → Click window
6. Open in Preview → Tools → Adjust Size → 1280×640
7. Save as Screenshots/banner.png
```

✅ **Checklist**:
- [ ] Shows full app window
- [ ] Sidebar has 4+ IPAs with different status colors
- [ ] Detail view is visible and readable
- [ ] App icons showing
- [ ] Professional appearance
- [ ] No personal information visible

---

## Screenshot 2: Main Window

**File**: `Screenshots/main-window.png`  
**Size**: 1200×800px  

```bash
# Steps:
1. Window should show sidebar + detail view
2. Select IPA with interesting details
3. Press ⌘⇧4 → Space → Click window
4. Resize if needed (Tools → Adjust Size in Preview)
5. Save as Screenshots/main-window.png
```

✅ **Checklist**:
- [ ] Sidebar shows 3-5 IPAs
- [ ] Mix of status indicators (🟢🟠🔴)
- [ ] App icons visible
- [ ] Detail view showing complete profile
- [ ] Toolbar visible (+ button, Export menu)
- [ ] Status card visible
- [ ] Profile information section visible

---

## Screenshot 3: Detail View

**File**: `Screenshots/detail-view.png`  
**Size**: 700×900px (approx)  

```bash
# Steps:
1. Select IPA with provisioned devices (Ad Hoc or Development)
2. Take full window screenshot
3. Crop to just the detail pane (right side)
4. Remove extra whitespace
5. Save as Screenshots/detail-view.png
```

✅ **Checklist**:
- [ ] Shows header with app icon
- [ ] Status card with indicator and days remaining
- [ ] Progress bar visible
- [ ] Profile Information section complete
- [ ] Provisioned Devices section (if available)
- [ ] Copy buttons visible on device IDs
- [ ] All text readable

---

## Screenshot 4: Terminal Output

**File**: `Screenshots/cli-output.png`  
**Size**: 800×600px  

```bash
# Steps:
1. Open Terminal
2. cd /path/to/IPAspect
3. Run: ./analyze-ipa.sh /path/to/sample.ipa
4. Wait for complete output
5. Press ⌘⇧4 → Space → Click Terminal window
6. Save as Screenshots/cli-output.png
```

✅ **Checklist**:
- [ ] Shows command execution
- [ ] Complete output visible
- [ ] Color coding visible (green, yellow, red, blue)
- [ ] Profile information section visible
- [ ] Expiration status visible
- [ ] Device list (if applicable)
- [ ] "✓ Analysis complete" visible

---

## Post-Processing

### 1. Check File Sizes
```bash
ls -lh Screenshots/*.png

# If any file > 500KB, compress:
```

### 2. Compress (Optional)
```bash
# Using ImageOptim (drag files into app)
# OR
pngquant --quality=80-90 Screenshots/*.png
```

### 3. Verify All Files
```bash
ls Screenshots/
# Should show:
# - banner.png
# - main-window.png
# - detail-view.png
# - cli-output.png
```

---

## Update Documentation

### 1. Remove TODO Comments

Edit **README.md** and **QUICKSTART.md**:

```markdown
# Remove these lines:
*TODO: Add screenshot showing...*

# Keep these lines:
![Alt Text](Screenshots/filename.png)
```

### 2. Add Captions

Replace TODOs with descriptive captions:

```markdown
![Main Window](Screenshots/main-window.png)
*IPAspect interface showing analyzed IPAs with status indicators and detailed profile information*
```

### 3. Test Locally

- Open README.md in Markdown viewer
- Verify all images display correctly
- Check that captions are meaningful

---

## Commit to Git

```bash
# Add all screenshots
git add Screenshots/*.png

# Update docs (remove TODOs)
git add README.md QUICKSTART.md

# Commit
git commit -m "Add documentation screenshots

- Main window with sidebar and detail view
- Detail view showing profile information
- Terminal output with color-coded analysis
- Banner image for README header"

# Push
git push origin main
```

---

## Final Verification

Visit your GitHub repository and check:

- [ ] All images display in README.md
- [ ] All images display in QUICKSTART.md
- [ ] Images are clear and readable
- [ ] No broken image links
- [ ] Captions are descriptive
- [ ] No TODO comments remain

---

## Troubleshooting

**Images not showing on GitHub?**
- Check file paths (case-sensitive)
- Verify files are committed and pushed
- Clear browser cache

**Images look blurry?**
- Retake on Retina display
- Ensure high DPI setting
- Don't over-compress

**File size too large?**
- Use ImageOptim or pngquant
- Reduce dimensions slightly
- Remove unnecessary transparency

---

## Optional: Animated GIFs

### Drag and Drop GIF

```bash
# Using GIPHY Capture or Kap:
1. Start recording
2. Drag IPA file onto sidebar
3. Wait for analysis
4. Stop recording
5. Export as Screenshots/drag-drop.gif
```

### Swipe to Delete GIF

```bash
1. Start recording
2. Swipe left on IPA row
3. Tap delete button
4. Stop recording
5. Export as Screenshots/swipe-delete.gif
```

Add to docs:
```markdown
![Drag and Drop](Screenshots/drag-drop.gif)
*Drag IPA files directly onto the sidebar for instant analysis*
```

---

## Quick Commands Reference

```bash
# macOS Screenshot Shortcuts
⌘⇧3          # Full screen
⌘⇧4          # Selection
⌘⇧4 + Space  # Window capture
⌘⇧5          # Screenshot app

# Resize with sips
sips -Z 1200 screenshot.png

# Compress with pngquant
pngquant --quality=80-90 *.png

# Check sizes
du -h Screenshots/*.png

# Git workflow
git add Screenshots/
git commit -m "Add screenshots"
git push
```

---

## Time Estimate

- **Preparing sample IPAs**: 10-15 minutes
- **Capturing 4 screenshots**: 10 minutes
- **Post-processing**: 5 minutes
- **Updating documentation**: 5 minutes
- **Total**: ~30-35 minutes

---

## Tips for Success

1. **Lighting**: Use light mode for better documentation readability
2. **Window Size**: Keep consistent across screenshots
3. **Data**: Use realistic but anonymized sample data
4. **Focus**: Make sure key elements are clearly visible
5. **Quality**: Better to retake than use blurry screenshot

---

## Need Help?

Refer to:
- 📖 **SCREENSHOTS_GUIDE.md** - Comprehensive guide
- 📁 **Screenshots/README.md** - Requirements reference
- 🤔 **Issues** - Ask questions on GitHub

---

**Ready? Start with Screenshot 1 (Banner) and work your way through the list!** 🚀
