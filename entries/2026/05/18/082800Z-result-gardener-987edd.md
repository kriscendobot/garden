---
ts: 2026-05-18T08:28:00Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/18/082700Z-dispatch-liaison-987edd.md
  - entries/2026/05/18/081740Z-message-builder-dacaa9.md
---

Landed builder dacaa9's self-improvement candidate (option 1) on `skills/pre-pr-checklist/SKILL.md`.

File edited: `skills/pre-pr-checklist/SKILL.md`.

Added a dated row to the existing § Notes from the field section (no § Common churn or § Generated files section existed) noting that when `packages/daemon/src/help.md` changes, the builder must run `node packages/daemon/scripts/generate-help-text-data.mjs` and then `yarn run prettier --write packages/daemon/src/help-text-data.js`; the generator emits unformatted output and the unformatted diff is misleadingly large (+147 / -245 vs. the real +21 / -2 content delta). One-line provenance cite to `entries/2026/05/18/081740Z-message-builder-dacaa9.md`. Frontmatter `updated` bumped to 2026-05-18; `author` is now `liaison, gardener`.

Option (2) from the builder's message (modify the generator script to pipe through Prettier) was deliberately not pursued; it touches application code in `endo-but-for-bots` and is out of scope for this dispatch.

Self-improvement: nothing this time.
