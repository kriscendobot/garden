---
created: 2026-06-28
updated: 2026-06-28
author: gardener
---

# Skill: emoji-favicon

Render a browser-tab favicon from a single emoji with **no asset file, no build
step, and no extra network request**. The favicon is an inline SVG data URI in
the document head: the emoji is drawn as SVG `<text>`, so the browser paints it
from the platform emoji font. This is the technique the Emoji Quest web app uses
(`https://play.emojiquest.app/`).

A [web-designer](../../roles/web-designer/AGENT.md) reaches for this when a design
calls for an emoji-branded tab icon; a
[web-builder](../../roles/web-builder/AGENT.md) implements it.

## When to use

- A web frontend wants a recognizable tab icon and the brand is (or can be) a
  single emoji.
- You want to avoid committing a binary `.ico` / `.png`, wiring a favicon build
  step, or paying a second request on page load.
- The icon should track application state at runtime (a game piece, a status
  glyph): the data URI is a string, so the runtime variant swaps it live.

## The technique (static, in the document head)

A single `<link rel="icon">` whose `href` is an `image/svg+xml` data URI holding
an inline SVG with one `<text>` node:

```html
<link
  rel="icon"
  href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 10 10%22><text y=%228%22 font-size=%228%22>🧙</text></svg>"
/>
```

The pieces that matter:

- **`data:image/svg+xml,...`** is the raw SVG inline, **not** base64. The SVG
  source is the data URI body verbatim, so it stays human-readable and diffable.
- **`%22` is a URL-encoded double quote.** The whole data URI sits inside an HTML
  attribute already delimited by `"`, so every `"` *inside* the SVG must be
  encoded as `%22` (or the SVG attributes must use single quotes). `<`, `>`, and
  the emoji itself pass through unencoded in every current browser.
- **`viewBox="0 0 10 10"` with `<text y="8" font-size="8">`** sizes one glyph to
  fill the box. The `y` is the text baseline, not the top, so it sits a little
  below `font-size`; tune `y` so the glyph is vertically centered for your
  chosen viewBox (a common alternative is `viewBox="0 0 100 100"` with
  `font-size="90"` and `y=".9em"`).
- **`xmlns="http://www.w3.org/2000/svg"` is required.** Without the namespace the
  browser will not parse the data URI as SVG.

No `<head>` asset, no manifest entry, no second request: the icon is part of the
HTML the page already shipped.

## The runtime variant (emoji chosen by application state)

When the emoji depends on state (the active game piece, a build-status glyph),
set the link from script. Build the SVG as a template string and
`encodeURIComponent` it so quoting is handled for you:

```js
function setEmojiFavicon(emoji) {
  const svg =
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">` +
    `<text y=".9em" font-size="90">${emoji}</text></svg>`;
  let link = document.querySelector('link[rel="icon"]');
  if (!link) {
    link = document.createElement('link');
    link.rel = 'icon';
    document.head.appendChild(link);
  }
  link.href = 'data:image/svg+xml,' + encodeURIComponent(svg);
}
```

`encodeURIComponent` over-encodes slightly (it encodes characters a browser would
accept raw), which is harmless and removes the hand-encoding footgun. Keep the
`xmlns` in the string.

## Procedure

1. **Pick the emoji.** One grapheme. A multi-codepoint emoji (a profession with a
   zero-width-joiner sequence, a skin-tone modifier) works as long as the source
   file is saved UTF-8; verify it survives the editor and the minifier.
2. **Compose the SVG** with `xmlns`, a square `viewBox`, and one `<text>` node
   sized to fill the box. Start from `viewBox="0 0 100 100"`,
   `font-size="90"`, `y=".9em"` and nudge if the glyph clips or floats.
3. **Encode for the attribute.** Static form: replace each `"` inside the SVG with
   `%22`. Runtime form: `encodeURIComponent` the whole SVG string.
4. **Place the `<link rel="icon">`** in `<head>` (static) or append it from script
   (runtime).
5. **Verify** per the checklist below before treating it as done.

## Verification

- Load the page and confirm the tab shows the emoji (not the browser's default
  globe / broken-icon).
- Check at least one Chromium browser and one Firefox; both have supported SVG
  favicons for years.
- Hard-reload to clear a cached default favicon.
- If the page sets the icon at runtime, confirm the initial server-rendered
  `<head>` still carries a sensible default so the tab is not blank before
  script runs.

## Limitations (call these out in the design)

- **SVG data-URI favicons cover the browser tab icon only.** They do **not**
  satisfy `apple-touch-icon` (iOS home-screen) or a PWA manifest's `icons`
  array, both of which still want raster PNGs at fixed sizes. A design that needs
  full platform coverage pairs this technique with a small set of generated PNGs
  and says so; this skill is not a whole icon pipeline.
- **The glyph is rendered by the viewer's emoji font**, so the same emoji looks
  different across platforms (Apple vs Noto vs Segoe). That is usually fine for a
  tab icon; note it if pixel-exact branding is a requirement.
- **Old browsers** (legacy Edge, anything pre-2018-ish) ignore SVG favicons and
  fall back to the default. Provide a raster `favicon.ico` fallback only if those
  user agents are in scope.

## Output

The deliverable is the `<link rel="icon">` (and, for the runtime variant, the
`setEmojiFavicon`-shaped helper) landed in the project's HTML/entry module, plus
a design note recording the chosen emoji, the viewBox/font-size tuning, and the
platform-coverage limitation above.

## Notes from the field

(Append; terse and dated.)

- _2026-06-28_: initial write (issue `kriskowal/garden#12`). Technique transcribed
  verbatim from `play.emojiquest.app` served HTML: `viewBox="0 0 10 10"`,
  `<text y="8" font-size="8">`, inner quotes as `%22`, inline (not base64) SVG.
