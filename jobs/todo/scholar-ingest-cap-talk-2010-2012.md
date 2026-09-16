---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest cap-talk: 2010-2012 (and the 2009 Aug-Nov remainder)

Continues `scholar-ingest-cap-talk-2009-2012` and its remainder
(`scholar-ingest-cap-talk-2009-2012-remainder`, 2026-09-16). The source index
`library/sources/cap-talk-2009-2012.md` now sections all of 2009's fetchable
standout threads (Q1 plus the April/June/July/December remainder) and anchors
2009-January through December plus a partial 2010-2012 anchor set
(2010-October, 2011-April, 2011-May, 2011-June, 2011-July). The next free
`cap-talk-open-questions` number is 45.

Remaining work, oldest-first, respecting the per-cycle budget (~3-5 sources or
~25 section writes; post a further remainder if it overflows one cycle):

- **Section 2009-August through 2009-November.** These bundles are already
  SHA-256 anchored in the index but hit transient Internet-Archive *content*
  fetch failures during the remainder cycle, so they were anchored but not
  sectioned. Re-fetch via `scripts/jobs/fetch-source.sh` (the redirect `2id_`
  form works; the Wayback availability/CDX APIs were rate-limited — retry the
  bundle directly, spacing attempts) and section their standout threads.
- **Anchor and section all of 2010, 2011, 2012.** Only a handful of 2010-2012
  months are anchored so far (see the index's "Monthly bundle anchors
  (2010-2012)" table); most are neither anchored nor sectioned, and the anchored
  ones are not yet sectioned. Fetch each `<year>-<Month>.txt.gz`, add its SHA-256
  row, and section oldest-first following the `source_kind: mailing-list-archive`
  shape and the per-thread multi-author attribution the existing cap-talk
  sections use.
- **2012-October specifically** still failed to fetch across four attempts this
  cycle (transient Internet-Archive connection failures) and is NOT yet anchored;
  re-fetch and anchor it.
- Add each new section's row to the source index's per-month survey table and
  Sections table, the relevant topic/concept Sections tables (via
  `scripts/jobs/insert-sections-table-row.sh`), and (for genuinely open disputes)
  `library/topics/cap-talk-open-questions.md`.
- Continue cross-linking Endo-relevant ideas into
  `journal/projects/endo/cap-talk-capability-provenance.md`.

NOTE: the post-2016 Google Groups era remains not fetchable from the sandbox
(documented in `cap-talk-1998.md`); flag the gap if reached.
