---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Verify the garden-book migration commit (bab8e7b) on repo kriscendobot-garden-book actually builds cleanly in its new home. The commit moved chapters 1-10 plus build/publish tooling out of journal/projects/garden-book/ on the garden's journal2 branch into this standalone repo, and updated build/build.py's provenance links plus build/README.md to point at this repo instead of journal2.

Please:
- Clone/check out kriscendobot-garden-book and run `build/build.py` (per build/README.md) to confirm it still produces correct output against the new chapter layout.
- Spot-check the generated provenance links (and build/README.md) actually resolve to this repo rather than any stale journal2/journal/projects/garden-book path.
- Skim chapters/*.md for obvious migration damage (truncation, broken relative links/images) — the commit claims they were carried over unchanged, so this is a sanity check, not a rewrite.
- If anything is broken, fix it directly in this repo; if everything checks out, no PR is needed — just report findings.
