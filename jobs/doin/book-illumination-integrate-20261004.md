---
role: web-designer
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# INTEGRATE the approved illuminations into the garden-book edition (kriscendobot/garden-book)

Repository: `kriscendobot/garden-book` (scope is only this repo: no upstream repos, no fleet or budget config). Supervisor: `book-illumination-supervisor-after-revise-20261004`, and its successor `book-illumination-supervisor-after-integrate-20261004` reviews, merges, and publishes your PR. Production sentinel: `book-illumination-supervisor-20261004`.

## Starting state

- `main` is at `32cf2348503fa8f9e13c7c7be9ebb3ff5db3702f`, the merge of https://github.com/kriscendobot/garden-book/pull/9. It holds 25 approved illumination SVGs under `art/illumination-*.svg`, their generator `art/generate-illuminations.mjs`, `art/MANIFEST.md`, and the design brief `art/chapter-illustrations-brief.md`. Each SVG carries its target heading anchor. The palette has 13 colors, and the set covers light and dark.
- The images passed the required Fable thematic review (https://github.com/kriscendobot/garden-book/pull/9#pullrequestreview-5404453977) plus one bounded revision (https://github.com/kriscendobot/garden-book/pull/9#issuecomment-5977019166, verified at https://github.com/kriscendobot/garden-book/pull/9#issuecomment-5977056231). Two cosmetic residuals in `ch9-hanging-library` are accepted, and the art is NOT to be revised again in this job.
- The current generator is the portable JavaScript build: `node build/build.mjs chapters out`, with `build/render-book.mjs`, `build/styles.css`, and `build/intro.html`. Live edition: https://g2d5d5z6x25qmf43fhv5tm4zmv4ozbxgk5gtke3mkrydrojehaea.ocap.site/
- https://github.com/kriscendobot/garden-book/pull/8 (copy-edit) is open on another base and is not yours. If it merges first, rebase onto it.

## Work

1. Get an isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/garden-book main`. Then pin a frozen base `main-32cf234` per `skills/frozen-base-branch` and branch `book-illumination-integrate` from it.
2. **Weave the images where they improve pacing.** Do not mechanically top every section. Use the brief's per-image placement notes (`art/chapter-illustrations-brief.md`, "Coverage and integration notes") and `art/MANIFEST.md` anchors. Chapter openers go at chapter heads, and section figures go where they break up long text or illuminate the idea at hand. If an image hurts pacing in place, say so in the PR body and choose a better nearby spot; don't drop it silently. Integrate through the generator (`build/render-book.mjs` / `build/build.mjs` or the chapter sources), never by hand-editing the build output.
3. **Inline-safe SVG behavior.** Clips run under a strict CSP (`style-src 'self'`, no inline style). Keep presentation attributes only, ID prefixes that stay unique when inlined, and no external references or scripts. Any CSS goes in `build/styles.css`.
4. **Accessibility.** Keep each image's `<title>`/`<desc>` and give it meaningful alt text and a caption (a `figure`/`figcaption` or the book's margin-note idiom). Don't encode meaning in color or vertical position alone, per the brief.
5. **Old background (brief section "Existing first-edition background").** Remove the full-field `art/title-garden.svg` backdrop treatment. Try a tighter title-page-only border or corner illumination built from its right-hand vine, trellis, and lower bed. If that still reads as a faint generic garden rather than a deliberate frame, remove it entirely. Never repeat it behind chapter or section art. Record which outcome you chose, and why, with a screenshot-backed note in the PR body. The interim garden-bed figure may stay only if the new chapter 2 opener doesn't already replace it.
6. **Reproducible build verification.** Run `npm ci && npm test && node build/build.mjs chapters out` from clean, twice, and confirm byte-identical output (record the sha256 of `out/index.html` and `out/styles.css`). Add or extend tests where integration logic changed.
7. **Actual browser checks (required; record the evidence).** Load the built `out/index.html` in headless Chromium (Playwright; the cache is at `~/.cache/ms-playwright/`) at **phone width (390×844)** and **desktop (1440×900)**, in both **light and dark** `prefers-color-scheme`. That is four configurations. For each one:
   - **Horizontal overflow:** `document.documentElement.scrollWidth <= clientWidth`, plus no figure, SVG, or caption wider than its container.
   - **Vertical overflow:** no clipped figures, and no SVGs with runaway heights.
   - **Text/image contrast:** text over or next to art meets WCAG AA. Images stay legible against the dark background, with no vanished strokes and no transparency halos.
   - **Readability and responsive placement:** at phone width, margin figures and notes fold inline without covering text.
   Take screenshots of the title page, at least two chapter openers, and two section figures in each configuration, and look at them (the Read tool shows PNGs; see `skills/svg-visual-review`). Put a results table in the PR body: the configuration, the measurements, pass/fail, and anything you fixed. Keep the check script in the repo if it's reusable (for example `test/browser-check.mjs`), but don't commit screenshots or build output.
8. Open a **DRAFT** PR against `main-32cf234` only through `scripts/jobs/gardening/ensure-pr.sh`. **Do not merge and do not publish**: the supervisor successor does both. When finished, send the PR URL, head SHA, and verification summary to `book-illumination-supervisor-after-integrate-20261004` with `scripts/jobs/inbox-send.sh`.

Self-improvement: follow the standing skill at the end of every claim.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-04T05:50:21Z
