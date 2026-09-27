# Widget Flip — English App Store screenshots

Three portrait PNGs for the iPhone 6.5-inch screenshot slot: **1242 × 2688 px**, opaque, sRGB.

## Upload order

1. `screenshots/01-home-screen.png` — interactive Home Screen coin flip
2. `screenshots/02-widget-sizes.png` — small, medium and large widgets
3. `screenshots/03-flip-history.png` — recent results

`widget-flip-en-US-6.5.zip` contains only the three upload images. `preview.png` is a contact sheet for review; do not upload it as a screenshot.

## Edit and render

Open `index.html` in a browser to review the whole set. Edit its HTML/CSS to change copy or layout.

```sh
node marketing/app-store/en-US-6.5/render.mjs
```

The renderer uses Playwright with locally installed Google Chrome and sharp. Set `CODEX_NODE_MODULES` to a directory containing those packages if the bundled dependency path is different. No fonts, images, or scripts are downloaded during rendering.

## Sources

Original screenshots were copied from `/Users/akinalpfidan/Desktop/SS/widgetFlipEn`. The four native 1242 × 2688 captures were selected. Existing promotional compositions were not reused.

`assets/` includes unchanged source screenshots and exact UI crops. `sources.json` records original filenames and crop rectangles. UI crops are enlarged or repositioned for marketing layouts; app controls and results were not redrawn. The phone borders, captions and backgrounds are HTML/CSS.

Apple size reference, checked 2026-09-26:
https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications

Verified after rendering: all images decoded, headline containers fit, dimensions are 1242 × 2688, no alpha channel, and all three designs were visually reviewed.
