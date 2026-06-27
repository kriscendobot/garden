# scholar: reindex library/sections/README.md (stale backstop index)

The flat sections backstop index `library/sections/README.md` has drifted from
its file set. As of 2026-06-27:

- Actual section files: 5826
- Linked in README: 5430 (unique)
- Unindexed (orphan) section files: ~398
- README header still claims "Total section files: 5561" — stale count.

The ~398 unindexed children span the corpus, concentrated in: cask (173),
endo-but-for-bots (86), collections (36), endo (32), frb (31), garden (22),
web (9), gtor (9).

Note this is the *backstop* index only — the primary entry points
(topics/README.md, sources/README.md) are clean and current; sources and
topics/concepts indexes were verified clean during cycle
scholar-library-cycle-20260627-065049. So this is low-urgency hygiene, not a
correctness gap in the main lookup paths.

Work to do:
1. Regenerate `library/sections/README.md` so every existing
   `library/sections/*.md` child appears under its source-slug header, preserving
   the curated per-parent "(index)" descriptions already present on parent rows.
2. Update the header "Total section files:" count to match.
3. Verify zero orphans / zero dangling (the two existing "dangling" links —
   `daemon-os-sandbox-plugin.md`, `endoclaw-oauth.md` — are verbatim quotes of
   upstream design-doc cross-references inside section descriptions, NOT library
   index links; leave them as-is).

This likely exceeds one scholar cycle's section-write budget; split across cycles
by source-slug if needed.
