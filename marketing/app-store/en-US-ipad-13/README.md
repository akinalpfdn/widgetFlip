# Widget Flip — English iPad App Store screenshots

Three portrait PNGs, **2048 × 2732**, opaque RGB/sRGB. This resolution is accepted for Apple's 13-inch iPad screenshot slot: [Apple screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications).

Upload in this order:

1. `screenshots/01-home-screen.png` — interactive Home Screen widget.
2. `screenshots/02-widget-sizes.png` — small, medium and large widgets.
3. `screenshots/03-flip-history.png` — recent flip history.

`widget-flip-en-US-ipad-13.zip` contains only these three upload-ready PNGs. `preview.png` is a contact sheet, not an upload image.

## Design and sources

Matches the approved iPhone set's headlines, dark/cream/gold palette and three distinct messages. Subtitles are 96 px semibold. Tablet frames preserve native iPad screenshot proportions. Widget and history detail views are exact crops of real screenshots; app UI is not recreated.

Home Screen sources come from `/Users/akinalpfidan/Desktop/SS/widgetFlipIpadEn`. The old promotional screenshot was excluded. The history screen was captured from the current app on an isolated iPad Air 13-inch (M3), iOS 26.5 simulator in English. Eight representative heads/tails entries were seeded only in that test simulator. No application source changes were needed. See `sources.json` for source files and crop coordinates.

## Re-render

Open `index.html` for the three-panel preview. Use `?shot=home`, `?shot=sizes`, or `?shot=history` for an individual full-size canvas.

```sh
node marketing/app-store/en-US-ipad-13/render.mjs
```

Requires Chrome, Playwright and Sharp. The renderer uses the installed Codex runtime by default; set `CODEX_NODE_MODULES` to a different node_modules path if needed. It verifies output dimensions and opacity.
