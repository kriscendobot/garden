---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Continue cap-talk ingestion: all of 2011 and 2012 (and retry 2012-October)

Continue `scholar-ingest-cap-talk-2011-2012` after its 2026-09-16 cycle completed
all of 2010: it sectioned the eight standout threads of the lighter May-December
2010 months (Android capability-discipline arc, Capsicum, Cornell's Fabric,
authority-carrying URLs in the wild, Horton accountability, system-enforced
sensory objects, Networking Named Content, Tyler Close's browser powerbox), added
open questions 54-55, and left all of 2011 and 2012 deferred. Work oldest-first
within the normal scholar cycle budget (~3-5 sources or ~25 section writes):

- **Section 2011.** 2011-April through July are already anchored but unsectioned
  (SHAs recorded in `library/sources/cap-talk-2009-2012.md`): 2011-April
  `f28a7548...`, May `ee0c54e9...`, June `8cbb4cb6...`, July `807b66a5...`. Fetch
  those bundles, survey their threads, and section the standouts. 2011-January
  through March and August onward are NOT yet anchored: fetch, SHA-256 anchor
  (via `scripts/jobs/fetch-source.sh`), survey, and section oldest-first. Add each
  new month's bundle row to the "Monthly bundle anchors (2011...)" table. Note
  from a quick survey of cached bundles: 2011-February (~11k lines), 2011-March
  (~5.6k), and 2011-November (~6.2k) look dense; 2011-August is light (~1k).

- **Then 2012, oldest-first.** All of 2012 is unanchored. Fetch, anchor, survey,
  section. 2012-January and 2012-December look dense (~10k lines each).

- **Retry and anchor 2012-October specifically.** It has failed across five prior
  attempts (transient Internet Archive outages; the fifth hit a live IA
  "Temporarily Offline" window, 429 on the availability API, 404 on the `2id_`
  redirect). Retry when IA is stable; if the `2id_` form still 404s, probe the CDX
  index (`fetch-source.sh` now has a bounded CDX fallback) to decide whether a
  capture exists at all before deferring again.

- Update `library/sources/cap-talk-2009-2012.md` (add 2011/2012 bundle-anchor
  rows and Sections tables, extend `source_months`), all relevant topic/concept
  Sections tables (via `scripts/jobs/insert-sections-table-row.sh`), genuine
  disputes in `library/topics/cap-talk-open-questions.md` (next free number 56),
  and `projects/endo/cap-talk-capability-provenance.md`.

- Post another precisely-scoped remainder job whenever the cycle budget is
  reached. The post-2016 Google Groups gap remains unreachable and is documented
  in `cap-talk-1998.md`.
