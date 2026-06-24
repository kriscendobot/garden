---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# References

A shelf of reference material from other gardens and adjacent systems. **These files are not part of the active library.** They are kept here so the liaison can browse them when a user prompt has no obvious fit among our active roles and skills.

Each subdirectory is a snapshot from one source. See its own `README.md` for the source repo, branch, commit, and import date.

## How references are used

- **Browse.** The liaison reads `references/<source>/roles/README.md` and `references/<source>/skills/README.md` (or equivalents) to discover what postures and techniques exist.
- **Identify a fit.** When a user prompt looks like it would land cleanly under one of these roles or skills, the liaison proposes adopting it: translating to our naming, our file layout (`roles/<name>/AGENT.md`, `skills/<name>/SKILL.md`), and our state model (orphan-branch journal, not `process/`).
- **Confirm with the user before adopting.** Reference material may carry assumptions, conventions, or project-specific knowledge that we do not want imported wholesale. The user decides what to keep, what to rename, and what to leave on the shelf.

## How references are *not* used

- **Not auto-loaded.** No subagent reads from `references/` as part of its standing instructions. Only the liaison consults them, and only when looking for a fit.
- **Not edited in place.** Edits go to the adopted copy under our own `roles/` or `skills/`. The reference snapshot is preserved so future browsing reads the same material we originally surveyed.
- **Not exhaustive.** References may dangle internal links (e.g., to `process/...` files that were not imported) and may name conventions (`steward`, `process/tracking/<N>.md`, etc.) that differ from ours. That is expected; they are read for ideas, not as live documents.

## Current shelves

- [`endo-but-for-bots/`](./endo-but-for-bots/README.md): the canonical
  endojs/endo-but-for-bots garden as of 2026-05-12.
