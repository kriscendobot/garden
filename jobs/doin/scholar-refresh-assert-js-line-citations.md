---
priority: low
posted_by: scholar-library-cycle-20260728-075002
source_slug: endo--packages-ses-src-error-assert-js
---
# Recompute the stale in-text line citations in the assert.js sections 1 and 3

Deferred remainder from the 2026-07-28 freshness refresh of
`library/sources/endo--packages-ses-src-error-assert-js.md`
(`bfa149b4` -> `0594e99f`, `endojs/endo` `packages/ses/src/error/assert.js`,
633 -> 649 lines).

That refresh recomputed every in-text `(lines N-M)` citation in **section 2**
(`...--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler--abstract.md`
and `--body.md`) against the new file, and bumped the authoritative
`source_lines:` frontmatter range on all 21 section files. It did **not** touch
the granular in-text citations in the other two sections, which are still offset
— they have been stale since the 2026-06-27 refresh (which deferred them for the
same reason) and are now offset further:

- `...--declassifiers-quote-bare-and-redacted-vs-unredacted-details--abstract.md` (2 citations)
- `...--declassifiers-quote-bare-and-redacted-vs-unredacted-details--body.md` (10 citations)
- `...--makeAssert-and-the-assert-function-family--abstract.md` (1 citation)
- `...--makeAssert-and-the-assert-function-family--body.md` (16 citations)

Section 1's numbers are offset by the `@import`-block growth in `bfa149b4`;
section 3's by that plus the +16 lines `0594e99f` added inside section 2.

Task: read `packages/ses/src/error/assert.js` at `0594e99f` from the local bare
clone `worktrees/endojs-endo.git`, and correct each in-text citation in those
four files to the actual line numbers. Verify each one against the file rather
than applying a uniform offset — the 2026-06-27 refresh already found that some
were approximate at the *original* ingest (`quote` recorded at 70 vs actual 68),
so a blanket shift would preserve those errors. The `source_lines:` frontmatter
on all 21 files is already correct (1-212 / 214-522 / 524-649); do not change it.

Low priority: cosmetic navigation accuracy, not a correctness gate. Land through
`land-journal-edit.sh` and re-run the step-8 integrity gate as usual.

---
claim:
  host: ps23-garden-f65473ae
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-28T17:03:09Z
