All steps complete: 20 files landed, both projected indexes regenerated, result journaled, maintainer digest delivered, and the 2002-2003 follow-on posted. The `claude -p` gardener spine performs the doin→tada transition from my report plus the completion signal, so I'll finish with the report and signal rather than invoke `complete-job.sh` (which would risk a double-complete).

---

## Completion report

**Job:** `scholar-ingest-cap-talk-2000-2003` — ingest the 2000-2003 era of the cap-talk archive.

**What I did.** Delivered a faithful first pass of the era, oldest-first: the reachable **2000-2001** slice, landed as source-index `library/sources/cap-talk-2000-2001.md` with **10 sections**. The 2002-2003 Miller-paper era is deferred to a posted follow-on (a full cycle's budget was reached at 2000-2001).

**Acquisition.** The canonical host is offline and archive.org's availability API was rate-limiting hard (429/503). The reliable path was a CDX query to enumerate captured `.txt.gz` bundles + timestamps, then a direct Wayback `id_` original-bytes fetch per bundle (validated as real gzip). Five bundles anchored sections (2000-July `52cc13f4`, 2000-August `d7fb39c7`, 2000-November `77a32016`, 2001-July `7e0ec8b2`, 2001-August `76388b8a`); 2001-November was fetched, surveyed, and found to carry only list-admin/off-topic mail (no section). Some captures duplicate the bundle body; I ingested the first copy.

**Sections (10):** capability-representation (partitioned/tagged/password taxonomy); confinement (SW model vs E immutability vs keybits); the-TCB-is-not-singular; KeyKOS/EROS practical model for a newcomer; a-capability-is-behavior-not-an-object-reference; process-allocation-branding-and-minimal-TCB; off-line-representation-vs-on-line-protocol; two-threads-of-capability-thinking (OS vs lambda); reviewing-Hanson's-Goo (why-not-SPKI); authorization-certificates-are-all-around-us.

**Indexing.** Rows added to topics capability-theory (+6), capability-security (+10), revocation (+1), captp (+1); concepts card-keys (+1), object-capability (+2); sources/README (+1). Extended `cap-talk-open-questions` (notion 2 and two new notions: is SPKI a capability system; resume-key security-or-bug-catching). Grew `projects/endo/cap-talk-capability-provenance.md` with three Endo-relevant subsections (off-line-vs-on-line → CapTP/OCapN two-layer shape and SPKI verdict; behavioral-reference → Far/Remotable facets; lambda lineage + confinement-by-immutability → SES harden).

**Verification (real-execution evidence):** `library-link-check.sh --changed` = OK (every checked link resolved to a committed file, cluster `cap-talk-2000-2001` all `ok`); `regenerate-topics-counts.sh --check` reported only stale counts (no missing topic page), then `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` each landed their projected index on origin/journal2. All 20 content files reported "landed on origin/journal2" by the producer-clone lander.

**Follow-ups.** Posted `scholar-ingest-cap-talk-2002-2003` (the Miller-paper era) with acquisition notes and a request to re-enumerate for any 2000-2001 months the partial CDX pass missed. Result entry `entries/2026/09/16/161004Z-result-scholar-3dda12.md`; maintainer digest delivered.

Self-improvement: the reusable lesson is that the Wayback availability API rate-limits during bulk mailing-list-archive ingest, so CDX-enumerate-then-direct-`id_`-fetch is the reliable path and some captures duplicate the body; worth encoding into `fetch-source.sh`/conventions for future archive cycles (routed via the follow-on job notes and this result rather than landed by me).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk-2000-2003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (16535114 cached reads)
- Output: 78577 tokens
- Cost: $13.280131999999996
- Wall-clock: 2194s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
