All work is landed and verified. Writing the completion report.

---

## Completion report: scholar-ingest-cap-talk-2009-2012-remainder

**What I did.** Continued the cap-talk 2009-2012 ingest, sectioning the rest of 2009's *fetchable* standout threads and anchoring the missing bundles that were reachable this cycle. Internet-Archive rate-limiting was heavy; I worked around it by retrying the redirect `2id_` form directly.

**Sections written (5 new; source `section_count` 9 → 14):**
- 2009-April — `hiding-webkeys-from-the-address-bar` (Karp: authority-bearing webkeys must be hidden from users; the SCoopFS address-bar inbox-leak incident; the mashup tension).
- 2009-June — `defining-ambient-authority` (the Wikipedia/wiki.erights definitional thread; designation as the discriminator) and `origin-header-amplifies-ambient-authority` (Miller's CORS/Origin ambient-authority critique).
- 2009-July — `defensive-correctness-versus-consistency` (the "controversial article" thread).
- 2009-December — `reducing-ambient-user-authority-install-manifest`.
- 2009-May was a light month (8 msgs) → survey row only, no section.

**Concept authored:** `concepts/ambient-authority.md` — a genuine gap the June/December threads made load-bearing; added to `concepts/README.md` and `keywords.md`.

**Bundles anchored:** 2009-December (new) plus 2010-October, 2011-April, 2011-May, 2011-June, 2011-July (recorded in a new "Monthly bundle anchors (2010-2012)" table, anchored-not-yet-sectioned). **2012-October failed across 4 fetch attempts** and stays unanchored.

**Also touched:** `capability-security` (+5) and `capability-theory` (+2) Sections tables; open questions **43** (defensive-correctness liveness standard) and **44** (reduce-vs-eliminate ambient authority); concept back-rows on `web-key`, `confused-deputy`, `robust-composition-thesis`, `principle-of-least-authority`, `powerbox`; a new Endo-provenance section cross-linking the ambient-authority/defensive-consistency ideas.

**Follow-on posted:** `scholar-ingest-cap-talk-2010-2012` — owns 2009-Aug–Nov (anchored but content-fetch-failed), all of 2010-2012 sectioning, and the 2012-October + unlisted-months anchoring.

**Gate & indexes:** `library-link-check.sh --source-slug cap-talk-2009-2012` → OK; `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` regenerated and landed; topics-counts `--check` current. All 18 changed files landed through `land-journal-edit.sh`; a concurrent 2013-2016 peer scholar forced a re-sync + re-apply of 5 files (and re-numbered the open questions 37/38→43/44), re-landed cleanly.

**Deferred:** 2009-Aug–Nov sectioning; most 2010-2012 anchors + all 2010-2012 sectioning; 2012-October anchor; post-2016 Google Groups era (still not fetchable from the sandbox).

Self-improvement: The transient Internet-Archive failures cost most of the cycle's wall-clock — the availability/CDX APIs rate-limit hard, but the redirect `2id_` form succeeds on direct retry. `fetch-source.sh` could shortcut straight to the redirect form (skipping the availability+CDX probes) after the first 429/503 in a batch, or accept a `--redirect-only` flag, to make bulk monthly-bundle anchoring far faster and less flaky.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk-2009-2012-remainder.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 212 tokens (13638125 cached reads)
- Output: 88716 tokens
- Cost: $11.050379500000009
- Wall-clock: 1776s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
