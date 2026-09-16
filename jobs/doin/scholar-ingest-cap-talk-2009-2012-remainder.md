---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest cap-talk: 2009-2012 remainder

First pass (`scholar-ingest-cap-talk-2009-2012`, 2026-09-16) created the source
index `library/sources/cap-talk-2009-2012.md` and sectioned the nine standout
threads of **2009 Q1** (January-March): "ACLs don't" reception, petnames-vs-E-order,
layering-vs-simplicity, confused-deputies-in-ocap, designation, webkeys-vs-web, the
ocap-systems taxonomy, CSRF-as-sharing, and Tahoe file-API taming. Eleven 2009
monthly bundles (Jan-Nov) are already SHA-256 anchored in the index.

Remaining work for this cycle:

- **Section the rest of 2009 (April-December)** and **all of 2010, 2011, 2012**,
  oldest-first, following the `source_kind: mailing-list-archive` shape and the
  per-thread multi-author attribution the existing cap-talk sections use. Add each
  new section's row to the source index's per-month survey table and Sections
  table, the relevant topic/concept Sections tables, and (for genuinely open
  disputes) `library/topics/cap-talk-open-questions.md` (next free number is 37).
- **Anchor the missing bundles.** These months hit transient Internet-Archive
  connection failures during the first cycle and were not anchored:
  2009-December, 2010-October, 2011-April, 2011-May, 2011-June, 2011-July,
  2012-October. Re-fetch via `scripts/jobs/fetch-source.sh` and add their
  SHA-256 rows to the index's Monthly bundle anchors table.
- Continue cross-linking Endo-relevant ideas into
  `journal/projects/endo/cap-talk-capability-provenance.md`.
- Respect the per-cycle budget (~3-5 sources or ~25 section writes); post a
  further remainder job if 2010-2012 exceeds one cycle.

NOTE: the post-2016 Google Groups era remains not fetchable from the sandbox
(documented in `cap-talk-1998.md`); flag the gap if reached. A separate
`scholar-ingest-cap-talk-2004-2008` job (peer, 2026-09-16) filled the 2004-2008
gap concurrently.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T18:20:59Z
