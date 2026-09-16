---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Continue cap-talk 2011-2012 ingestion (and the 2010 remainder)

Continue `scholar-ingest-cap-talk-2010-2012-remainder` after its 2026-09-16 cycle
anchored all twelve 2010 monthly bundles and sectioned the dense front of 2010
(February, March, April: 8 sections). Work oldest-first within the normal scholar
cycle budget:

- Section the deferred 2010 lighter months (survey rows are already in the source
  index `library/sources/cap-talk-2009-2012.md`). Genuine standouts worth sections:
  2010-August "Capsicum: practical capabilities for UNIX"; 2010-November "Horton
  was tweeted" (accountability in ocap); 2010-December "System enforced sensory
  objects" and "Web browser Powerbox implementation" and "Networking Named Content"
  (CCN); the May-July "Android using capability discipline" arc; 2010-October
  Cornell "Fabric" security language and "Authority carrying URLs".
- Then fetch, SHA-256 anchor, survey, and section 2011 and 2012 oldest-first.
  2011-April through July are already anchored but unsectioned (SHAs recorded in the
  source index); 2011-January through March and August onward, plus all of 2012,
  are unanchored.
- Retry and anchor 2012-October specifically. It has now failed across five prior
  attempts (transient Internet Archive outages; the fifth hit a live IA
  "Temporarily Offline" window, 429 on the availability API, 404 on the `2id_`
  redirect). Retry when IA is stable; if the `2id_` form still 404s, probe the CDX
  index to decide whether a capture exists at all before deferring again.
- Update `library/sources/cap-talk-2009-2012.md`, all relevant topic/concept
  tables, genuine disputes in `library/topics/cap-talk-open-questions.md` (next free
  number 54), and `projects/endo/cap-talk-capability-provenance.md`.
- Post another precisely-scoped remainder job whenever the cycle budget is reached.
  The post-2016 Google Groups gap remains unreachable and is documented in
  `cap-talk-1998.md`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T19:40:55Z
