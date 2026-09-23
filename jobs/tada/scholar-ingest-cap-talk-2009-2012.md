All work is landed and verified. Writing the completion report.

Completed the **2009 Q1 first pass** of the cap-talk 2009-2012 ingest (the JavaScript / Caja / SES / web-key era).

**What I did**
- Fetched 2009-2012 monthly bundles from the Internet Archive `id_` capture (canonical host offline) via `fetch-source.sh`; anchored eleven 2009 bundles (Jan–Nov) by SHA-256.
- Created source index `library/sources/cap-talk-2009-2012.md` and **9 sections** over the densest 2009 Q1 threads: the "ACLs don't" Oakland-09 rejection reception (Close/Wagner/Murray/Miller), petnames-vs-E-order (Karp), layering-vs-simplicity (Hopwood), confused-deputies-inside-ocap (Murray), what-is-designation, webkeys-vs-the-web (Morningstar's powerbox-boot problem), the 2009 ocap-systems taxonomy (Murray), CSRF-as-sharing (Zooko), and Tahoe file-API taming.
- Discovered the "ACLs don't" **paper itself** is already ingested (`papers--close-acls-dont-2009`), so my sections cover the mailing-list *reception*, cross-referenced to it.
- Added **2 new concepts** (`web-key`, `petname`) with keyword aliases and README rows; added section rows to `confused-deputy` and `capabilities-vs-acls`.
- Added section-table rows to `capability-theory`, `capability-security`, `distributed-objects`, `identity`; appended 3 open-question entries (34–36) + a 2009 bullet to `cap-talk-open-questions`.
- Extended the Endo project file `projects/endo/cap-talk-capability-provenance.md` ("The web era" + "Petnames name objects; the wire names references").
- Ran the integrity gate (`--changed` OK; `--source-slug cap-talk-2009-2012` OK) and regenerated `sections/README.md` + `topics/README.md` counts.
- Posted follow-on `scholar-ingest-cap-talk-2009-2012-remainder`; posted the `result` entry and the maintainer digest.

**Notable / follow-ups**
- A **peer `scholar-ingest-cap-talk-2004-2008` cycle ran concurrently** (filling the 2004-2008 gap), causing heavy landing contention on shared indexes. The base-blob guard protected the shared files. One landing-loop bug landed my *stale* copies of three peer-edited concept pages (`caretaker-pattern`, `powerbox`, `promise-pipelining`); I detected this and **restored each to the peer's version** (`sections/README.md` self-healed via the regenerator). Final content on origin/journal2 is correct.
- Deferred to the remainder job: rest of 2009 (Apr–Dec) + all 2010-2012, and re-fetching 7 bundles that hit transient IA failures (2009-Dec, 2010-Oct, 2011-Apr/May/Jun/Jul, 2012-Oct).
- The whole-library `--nav` scan shows 59 **pre-existing** danglers in unrelated files (e.g. `policy-language-authorization.md`); none reference my additions (verified per-file).
- Self-improvement: land shared-index edits by re-applying my specific addition onto the *current tip* content and passing `--base-blob` for every pre-existing file — never land a whole staged file computed from an older tip, or a concurrent peer's edits get silently clobbered (as three files nearly were here). The lander's base-blob guard only helps when the base-blob is the version you actually composed from, not the current tip.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-cap-talk-2009-2012.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 226 tokens (17873392 cached reads)
- Output: 106079 tokens
- Cost: $14.108914999999998
- Wall-clock: 2251s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
