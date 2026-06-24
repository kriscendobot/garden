---
job: 73bd83
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T23:02:00Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 319
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - fixer
refs:
  - entries/2026/05/22/230100Z-dispatch-general-contractor-449962.md
preconditions: []
---

One summary-fix item from the barrister round-1 panel on PR #319 (`feat(familiar): cross-platform icon projection automation + CI verify`).

## Item 1 — Call `require_tool rsvg-convert ...` at the top of `render_ico`

`packages/familiar/scripts/generate-icons.sh:120-122` declares `render_ico()` which uses `rsvg-convert` to render the 48-px (and other `ICO_SIZES`) PNGs into a private scratch dir, but does **not** call `require_tool rsvg-convert librsvg2-bin librsvg` first. `render_pngs` does (line 91); `render_icns` checks `png2icns` (line 101); `render_ico` only checks `icotool` (line 111).

Symptom on a host without `librsvg`: `./scripts/generate-icons.sh --ico-only` fails with a bash-level `command not found: rsvg-convert` instead of the friendly two-line install hint the rest of the script promises.

Fix (one-line addition at the top of `render_ico`, after `require_tool icotool ...`):

```bash
render_ico() {
  require_tool icotool icoutils icoutils
  require_tool rsvg-convert librsvg2-bin librsvg
  # The .ico bundles its own size set, ...
```

No test change needed; the friendly-error path is observable by `command -v rsvg-convert` failing on a host that omits the package.

## Disposition

`summary-fix`. One fixer dispatch addresses the one item. No panel re-run; the un-draft happens after the fixer pushes (or, since this PR's panel already terminated cleanly on round 1, the maintainer or steward may opt to land the fix as a follow-up edit after merge).
