---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T18:21:29Z
---
# Result: scholar-ingest-cap-talk-2009-2012 (2009 Q1 first pass)

Ingested the JavaScript / Caja / SES / web-key era of the cap-talk archive,
first pass covering **2009 Q1** (January-March), the densest run of the era.

## Source
- **New source index** `library/sources/cap-talk-2009-2012.md` (`source_kind:
  mailing-list-archive`), anchoring eleven 2009 monthly bundles (Jan-Nov) by
  SHA-256, fetched from the Internet Archive `id_` capture via fetch-source.sh
  (canonical host offline). 2009-December + 2010-2012 deferred (several hit
  transient IA connection failures; the remainder cycle re-fetches + anchors).

## Sections written (9, all 2009 Q1)
- `cap-talk-2009-2012--acls-dont-paper-rejected-oakland-09` (Jan) — the list
  reception of Tyler Close's "ACLs don't" after its Oakland-09 rejection; the
  paper itself is the already-ingested `papers--close-acls-dont-2009` cluster.
- `cap-talk-2009-2012--petnames-versus-e-order` (Jan) — Karp's open question.
- `cap-talk-2009-2012--what-sustained-interest-layering-vs-simplicity` (Jan) —
  Hopwood: remove layers, don't add them (security as extreme modularity).
- `cap-talk-2009-2012--confused-deputies-in-capability-systems` (Feb) — Murray:
  confused deputies inside ocap via missing capability input-validation.
- `cap-talk-2009-2012--what-is-designation` (Feb).
- `cap-talk-2009-2012--webkeys-vs-the-web` (Mar) — Morningstar's powerbox-boot
  problem.
- `cap-talk-2009-2012--taxonomy-of-object-capability-systems` (Mar) — Murray's
  2009 live-ocap-systems taxonomy.
- `cap-talk-2009-2012--solve-csrf-unforgeable-not-unshareable` (Mar) — Zooko.
- `cap-talk-2009-2012--file-api-taming-tahoe` (Mar) — name-free file caps.

## Concepts (2 new) + concept cross-links
- New: `concepts/web-key.md`, `concepts/petname.md` (+ `keywords.md` aliases,
  `concepts/README.md` rows).
- Rows added to `concepts/confused-deputy.md` (×2) and
  `concepts/capabilities-vs-acls.md` (×1).

## Topic pages touched
- Section rows added to `capability-theory` (×4), `capability-security` (×7),
  `distributed-objects` (×1), `identity` (×1).
- `cap-talk-open-questions.md`: appended entries 34 (petnames-vs-E-order), 35
  (confused-deputies-in-ocap), 36 (browser powerbox / webkeys), plus a 2009
  bullet under the founding Equivalence question.

## Project cross-links
- `projects/endo/cap-talk-capability-provenance.md`: added "The web era" and
  "Petnames name objects; the wire names references" sections; updated the era
  range pointer and closing job list.

## Indexes
- `sources/README.md` row added; `sections/README.md` and `topics/README.md`
  counts regenerated (final landing step, both idempotent lands).

## Integrity gate
- `library-link-check --changed`: OK (no new danglers).
- `library-link-check --source-slug cap-talk-2009-2012`: OK.
- The whole-library `--nav` scan reports 59 PRE-EXISTING danglers in unrelated
  files (e.g. `topics/policy-language-authorization.md`); none reference this
  cycle's additions (verified with `--files` over every file I touched).

## Concurrency note
- A peer `scholar-ingest-cap-talk-2004-2008` cycle ran simultaneously and
  advanced many shared files. Landing collided repeatedly; the base-blob guard
  protected the shared indexes. One landing loop bug landed my STALE copies of
  three concept pages the peer had just edited (`caretaker-pattern`, `powerbox`,
  `promise-pipelining`); I detected and RESTORED each to the peer's version
  (`sections/README.md` self-healed via the regenerator). All final content on
  origin/journal2 is correct.

## Follow-on
- Posted `scholar-ingest-cap-talk-2009-2012-remainder`: section 2009-April
  onward + all of 2010-2012, anchor the 7 transient-failure bundles.

## Deferred
- Rest of 2009 (Apr-Dec) and all 2010-2012 (owned by the remainder job).
- 2004-2008 gap was filled concurrently by the peer job.
- post-2016 Google Groups era still not fetchable from the sandbox.
