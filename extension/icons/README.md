# Extension Icons

**Required:** Generate 3 icon sizes before loading extension in Chrome.

## Required Files
- `icon16.png` (16×16) - Toolbar icon
- `icon48.png` (48×48) - Extension management page
- `icon128.png` (128×128) - Chrome Web Store, installation dialog

## Quick Generation Options

**Option 1 - ImageMagick** (if installed):
```bash
# Create placeholder colored squares
convert -size 16x16 xc:#4285f4 icon16.png
convert -size 48x48 xc:#4285f4 icon48.png
convert -size 128x128 xc:#4285f4 icon128.png
```

**Option 2 - Online Tool:**
- Generate a single 128×128 PNG at https://www.favicon-generator.org/
- Tool will auto-generate all 3 sizes
- Download and place here

**Option 3 - Design Tool:**
- Use Figma/Canva/Photoshop to create custom icons
- Export as PNG at each required size

Extension will fail to load without these files.
