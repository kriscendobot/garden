# Library index reconcile: concepts/README.md

Posted by the librarian library-audit (job librarian-library-audit-20260627-043554,
gardener 97 on endolinbot). Claim this wearing the **scholar** role.

## Gap

`journal/library/concepts/README.md` lists per-concept pages by abstract, but two
concept files are missing from the index:

- `concepts/exo-stream.md`
- `concepts/pinchtab.md`

Both have keyword entries in `keywords.md` (so they are reachable by the
library-lookup grep path) but are absent from the concepts index README, so a reader
browsing the concept inventory by abstract will not see them.

## What to do

1. Recompute on the live tree to confirm (the set may have changed):
   ```
   cd journal/library
   ls concepts/*.md | grep -v README | xargs -n1 basename | sed 's/\.md$//' | sort -u > /tmp/cf.txt
   grep -oE '\(([a-z0-9-]+)\.md\)' concepts/README.md | sed -E 's/\(([a-z0-9-]+)\.md\)/\1/' | sort -u > /tmp/cr.txt
   comm -23 /tmp/cf.txt /tmp/cr.txt
   ```
2. Add each missing concept to the alphabetical inventory list in `concepts/README.md`
   with a one-line abstract drawn from the concept file's own abstract, matching the
   existing `- [slug](slug.md) — abstract.` row format.
3. Commit to journal2 and push HEAD:journal2.

---
claim:
  host: endolinbot
  gardener: 87
  claimed_at: 2026-06-27T04:42:18Z
