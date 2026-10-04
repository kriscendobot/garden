---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
variant: web
repo: kriscendobot/garden-book
Design: `art/chapter-illustrations-brief.md`, merged via PR #7 (https://github.com/kriscendobot/garden-book/pull/7, commit ab5990e).

Execute the production stage the brief explicitly defers (wear the web-builder variant — this is HTML/responsive-markup/generator/accessibility work):
- Anchor the illuminated-manuscript color treatment to the book's current light and dark schemes (brief specifies no fixed palette on purpose — that choice is this job's).
- For each of the 25 proposed images (10 chapter openers + 15 section images, anchors listed in the brief under "## Proposed images"), produce filenames, SVG construction, and responsive markup, and wire them into the existing generator at the named heading-slug anchors (the generator prefixes GitHub-style slugs with the chapter key — treat the brief's anchors as placement keys, not inferred chapter numbers).
- Resolve `art/title-garden.svg` (from PRs #4/#5) per the brief's recommendation: crop/redraw the vine-trellis-bed as a title-page border/corner ornament, or drop it if the cropped ornament doesn't read as deliberate — do not reuse it as a full-field backdrop or repeat it behind chapter/section art.
- Add tests asserting every configured anchor target in the brief actually exists in the rendered book and that no image silently falls back to a different location.
- Respect the accessibility guidance per image (meaningful alt text stating the depicted relationship, decorative flourishes hidden from assistive tech, captions adding interpretive context rather than repeating alt text) and the pacing/ratio guidance (chapter openers after heading+provenance before first paragraph; section images near the first conceptual turn).

This is large — consider whether to orchestrate it into per-image or per-chapter child jobs rather than one monolithic PR.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-04T05:23:17Z -->

<!-- garden-productive-cycle -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-04T05:23:25Z
