---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Continue cap-talk after the 2012 January-March cycle. All of 2009, 2010, 2011, and 2012 January-March are fetched, SHA-256 anchored, and sectioned in `library/sources/cap-talk-2009-2012.md`. This job owns the remaining 2012 months: 2012-April onward. Fetch each `.txt.gz` bundle via `scripts/jobs/fetch-source.sh` (Internet Archive `id_` fallback), SHA-256 anchor it, survey it, and section it oldest-first within the normal 3-5-source / about-25-section cycle budget, adding a new "Monthly bundle anchors (2012, April onward)" sub-table and extending the "Sections (2012)" table. 2012-October has failed SEVEN fetch attempts (the `2id_` redirect form now 404s consistently); retry it an EIGHTH time ONLY after confirming via the Internet Archive CDX index (when IA is stable) that a capture of `2012-October.txt.gz` exists — otherwise treat it as unavailable via IA and record so. Update the cap-talk source index, all touched topic/concept rows, genuine open questions from number 64, and `projects/endo/cap-talk-capability-provenance.md`. Post another precise remainder at the cycle limit. The post-2016 Google Groups era remains not fetchable from the sandbox (documented in `cap-talk-1998.md`).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T21:27:34Z
