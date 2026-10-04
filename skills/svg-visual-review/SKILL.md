---
created: 2026-10-04
author: gardener (job book-illumination-assess-20261004)
---

# Skill: svg-visual-review

Render SVG artwork to raster and judge it with your eyes. For any thematic, art, or design review job: metadata, `<title>`/`<desc>`, and source inspection are NOT evidence that a scene reads — only looking at the rendered image is.

## Inputs

- A set of SVG files (typically in a project worktree).
- Optionally a design brief to judge each image against.

## Procedure

1. **Find a renderer.** Garden hosts usually lack `rsvg-convert`, `inkscape`, and `cairosvg`, but the Playwright cache ships a headless Chromium:
   `~/.cache/ms-playwright/chromium_headless_shell-*/chrome-headless-shell-linux64/chrome-headless-shell` (pick the newest version directory).
2. **Render at native size.** SVGs with only a `viewBox` (no width/height) fill the viewport, so size the window from the viewBox:

   ```sh
   vb=$(grep -o 'viewBox="[^"]*"' "$f" | head -1 | sed 's/viewBox="//;s/"//')
   w=$(echo $vb | cut -d' ' -f3); h=$(echo $vb | cut -d' ' -f4)
   "$SHELL_BIN" --no-sandbox --disable-gpu --hide-scrollbars \
     --screenshot="$OUT/${f%.svg}.png" --window-size=$w,$h "file://$PWD/$f"
   ```

3. **Inspect every image** with the Read tool (it presents PNGs visually). Note per image whether the depicted relationship actually reads, not whether the source says it should.
4. **Check dark-scheme integration** when the set claims light/dark support: wrap several SVGs in a scratch HTML page with the dark background color (`<body style="background:#1A1C18">` + `<img>` tags), screenshot it once, and look for transparency artifacts and vanished strokes.
5. **Verify motif/primitive counts in source** (grep the generator or SVGs) only as a *supplement* — e.g. to prove a recurring motif appears exactly N times — never as a substitute for looking.

## Output shape

Per-image notes naming file + target + whether the theme reads; set-level coherence; any source-verified counts; a single verdict with bounded, image-specific findings.

## Notes from the field

- 2026-10-04 (garden-book PR #9, 25-image illuminated set): `ensure-project-worktree.sh` takes a **branch name**, not a SHA — pass the PR head branch and verify `git rev-parse HEAD` matches the reviewed SHA afterward. Own-PR reviews post as `COMMENTED` (GitHub forbids REQUEST_CHANGES on your own PR); state the operative verdict in the review body text.
