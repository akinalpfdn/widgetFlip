# Widget Flip — localized App Store screenshots

Captions translated into 17 languages for the iPhone 6.5-inch (**1242 × 2688**) and 13-inch iPad (**2048 × 2732**) slots. Layout, colours and app screenshots are the English sets in `../en-US-6.5` and `../en-US-ipad-13`; only the text changes. The app UI inside the screenshots stays English by decision.

## Upload

Each language folder has `6.5/` and `ipad-13/` with the same three files, uploaded in this order: `01-home-screen.png`, `02-widget-sizes.png`, `03-flip-history.png`. `preview.png` is a contact sheet for review; do not upload it.

| Folder | App Store Connect localization |
|---|---|
| `tr` | Turkish |
| `es-MX` | Spanish (Mexico) |
| `es-ES` | Spanish (Spain) |
| `pt-BR` | Portuguese (Brazil) |
| `de` | German |
| `fr` | French, **and** French (Canada) |
| `it` | Italian |
| `nl` | Dutch |
| `sv` | Swedish |
| `pl` | Polish |
| `ru` | Russian |
| `ja` | Japanese |
| `ko` | Korean |
| `zh-Hans` | Chinese (Simplified) |
| `zh-Hant` | Chinese (Traditional) |
| `ar` | Arabic |
| `vi` | Vietnamese |

English (U.K.), (Australia) and (Canada) use the English sets.

## Edit and render

Translations live in `copy.json`. In `h1`, `\n` is a line break on both devices, `¦` breaks only on iPhone, and `{…}` is the gold highlight.

```sh
node marketing/app-store/localized/render.mjs          # all languages
node marketing/app-store/localized/render.mjs de ja    # selected languages
```

The renderer loads the English `index.html` for each device, swaps in the translation, and shrinks a headline only when it would run into the artwork (the log prints the scale used). It also keeps the "tap" label on one line where possible, never splits CJK words, and mirrors text and size captions for Arabic. Output is checked for exact dimensions and no alpha. Requires Chrome, Playwright and Sharp, the same as the English renderers (`CODEX_NODE_MODULES` overrides the dependency path).

Home Screen terms follow iOS 26.5's own localizations (for example *Home-Bildschirm*, *ekran główny*, *Màn hình chính*). Translations were not reviewed by native speakers.
