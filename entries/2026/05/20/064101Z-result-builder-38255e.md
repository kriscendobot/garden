---
ts: 2026-05-20T06:41:01Z
kind: result
role: builder
worktree: dispatches/builder--043b52/project
repo: endojs/endo-but-for-bots
project: endo
---

# G7 of familiar-release: cross-platform icon projection automation

PR: https://github.com/endojs/endo-but-for-bots/pull/319 (draft)
Branch: `feat/familiar-icon-projection-automation` off `llm`.
Commit: `6a0f0b689` "feat(familiar): cross-platform icon projection automation + CI verify".

## What landed

1. Rewrote `packages/familiar/scripts/generate-icons.sh` as a
   cross-platform pipeline (Linux + macOS) using one toolchain:
   `rsvg-convert` (SVG to PNG), `png2icns` (libicns, for `.icns`),
   and `icotool` (icoutils, for `.ico`). Replaces the prior macOS-only
   pipeline that depended on `sips` + `iconutil` and could not be
   verified by CI.
2. Added `--check` mode: renders into a tempdir and compares against
   the checked-in `assets/` byte-for-byte. Non-zero exit on drift with
   a per-artifact summary. Sub-modes `--png-only`, `--ico-only`,
   `--icns-only` let CI run only the platform-relevant slice.
3. Added `.github/workflows/familiar-icons.yml`. Runs `--check` on
   `ubuntu-latest` when any of the icon-pipeline paths change (the
   SVG source, the checked-in artifacts, the regen script, or the
   workflow itself). Scoped path triggers keep the job off unrelated
   PRs.
4. Regenerated all artifacts under the new pipeline: seven PNGs
   (icon-16/32/64/128/256/512/1024.png), `icon.icns`, and `icon.ico`.
   Checked in as the new canonical inputs to `@electron/packager`.
5. Added an *Application icons* section to `packages/familiar/README.md`
   documenting the regen and CI verify story.

## Pipeline summary

| Output                                | Tool         | Linux pkg        | macOS pkg          |
| ------------------------------------- | ------------ | ---------------- | ------------------ |
| `assets/icon-{16,32,64,128,256,512,1024}.png` | `rsvg-convert` | `librsvg2-bin` | `librsvg` (brew)   |
| `assets/icon.icns`                    | `png2icns`   | `icnsutils`      | `libicns` (brew)   |
| `assets/icon.ico`                     | `icotool`    | `icoutils`       | `icoutils` (brew)  |

All three tools produce deterministic byte-identical outputs across
hosts when given the same SVG source. Local `--check` confirms the
regenerated artifacts match the source on this Linux host; the CI
workflow re-validates the same on every change.

## Gate results

- `yarn lint:eslint` (familiar): one pre-existing warning, no errors.
- `yarn lint:types` (familiar): clean.
- `yarn format`: no changes in the touched paths.
- Garden pre-push probes (no-ascii-banners, sentence-per-line-md,
  filename-no-stutter): pass on the diff. Other repo-wide probes
  (security-md-hash-uniform, no-inline-import-jsdoc) report pre-existing
  failures in unrelated packages.
- `shellcheck` on the new bash script: clean.

## Notes / follow-ups

- The icon.ico went from 32K to 302K because the new pipeline keeps
  full RGBA at the bundled sizes; the prior `magick convert -alpha
  off -colors 256` produced a smaller but visually lossy artifact.
  Acceptable given Windows 10/11 expectations for high-res Start
  menu / taskbar icons.
- The `.icns` went from 171K to 92K because libicns deduplicates and
  packs more compactly than iconutil.
- 64x64 is rendered as a checked-in PNG (the Linux flavor uses it
  via the iconset path) but is intentionally omitted from the .icns
  packing because libicns has no native icns type for 64; Apple's
  spec covers 16, 32, 128, 256, 512, 1024.
- 48x48 is bundled into the .ico but not checked in as a separate
  PNG; the script renders it on the fly into a scratch tempdir.
- A follow-up design pass could flip G7's row in
  `designs/familiar-release.md` from "Important" to "Done".

Self-improvement: nothing this time.
