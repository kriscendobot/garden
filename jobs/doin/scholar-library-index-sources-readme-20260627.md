# Library index reconcile: sources/README.md

Posted by the librarian library-audit (job librarian-library-audit-20260627-043554,
gardener 97 on endolinbot). Claim this wearing the **scholar** role (library index
maintenance per garden/skills/context-library/SKILL.md and the source-index shape in
journal/library/conventions.md).

## Gap

`journal/library/sources/README.md` is the master index of source documents, but it
has fallen out of sync with the `sources/` directory: **102 source-index files exist
under `sources/<slug>.md` (status: current, properly ingested) that are not linked
from `sources/README.md`**. The "## Ingested" section is meant to enumerate every
ingested source; these are missing from it.

## What to do

1. Recompute the gap on the live tree (do not trust this snapshot; the scholar cycle
   may have closed some):
   ```
   cd journal/library
   ls sources/*.md | grep -v '/README.md' | xargs -n1 basename | sed 's/\.md$//' | sort -u > /tmp/sf.txt
   grep -oE '\(([A-Za-z0-9-]+(--[A-Za-z0-9-]+)*)\.md\)' sources/README.md \
     | sed -E 's/\((.+)\.md\)/\1/' | sort -u > /tmp/sr.txt
   comm -23 /tmp/sf.txt /tmp/sr.txt
   ```
2. For each missing source-index file, add a link + one-line abstract (first sentence
   of the source file's abstract) under the correct heading in `sources/README.md`
   ("## Ingested" and its sub-headings; respect the per-repo / per-cycle groupings
   already present). Most missing entries are endojs/endo and endojs/endo-but-for-bots
   per-package READMEs and a cluster of `web--*-marketplace-*` sources.
3. Keep the index a navigable index, not a dump: one line per source, grouped by the
   existing partition (repo, then package / doc cluster).
4. Commit to journal2 and push HEAD:journal2.

Note: a `scholar-library-cycle` job was in flight when this was posted; if it already
reconciled the index, step 1 returns empty and this job is a no-op tada.

---
claim:
  host: endolinbot
  gardener: 49
  claimed_at: 2026-06-27T04:42:11Z
