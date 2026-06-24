---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 319
created_at: 2026-05-22T23:01:00Z
last_appended_at: 2026-05-22T23:01:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#319

Created from the code-panel verdict (12 seats, in-band fallback) on `feat(familiar): cross-platform icon projection automation + CI verify (G7 of #231)`. The PR rewrites `packages/familiar/scripts/generate-icons.sh` as a cross-platform pipeline (rsvg-convert / png2icns / icotool), adds a `--check` mode, regenerates checked-in artifacts, and adds a `.github/workflows/familiar-icons.yml` workflow that runs `--check` on icon-pipeline path changes. One follow-up item deferred for revisit at merge time.

## Items

- [ ] **Visual diff of regenerated icons vs prior toolchain output.**
  **Source juror(s)**: barrister (aggregated post-panel).
  **Round**: 1.
  **Recommended action**: post-merge, a one-shot follow-up that renders the prior toolchain's icons (last known good from before commit `6a0f0b689`) and the new pipeline's icons side-by-side at every checked-in size (16, 32, 64, 128, 256, 512, 1024 px PNGs; the `.icns` extracted to PNGs; the `.ico` extracted to PNGs), and attaches the comparison as a PR comment or design-doc note. Confirms the PR body's "visually equivalent" claim is empirically grounded. The Electron packager treats the assets as opaque by basename so no consumer code changes; the visual diff is for maintainer confidence, not blocking. The artifact-extraction recipe: `magick icon.icns out_icns_%d.png` and `icotool -x icon.ico --output ico_extract/`.
