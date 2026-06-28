---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T18:09:01Z
---
# scholar-ingest-erights-10: six ELib concurrency sub-hub child chapters ingested

Completed the erights-10 set. The ELib `elib/concurrency/` chapter is now FULLY
INGESTED (hub + five erights-8 children + four erights-9 mechanics chapters + two
erights-9 sub-hub maps + these six erights-10 sub-hub child chapters).

## Sources ingested (6 new, each 1 section)

The Four Layers of When sub-hub children (all four are unwritten upstream stubs,
"*** To be written"; ingested for their place in the four-layer map and their Endo
lineage, with the content SHA-256 as a freshness anchor):

- `erights--elib-concurrency-when-ref-when` (Layer 1, References as Observables;
  SHA d943520d3936, 6474 bytes) -> 1 section.
- `erights--elib-concurrency-when-reactors` (Layer 2, The When* Reactors;
  SHA b39e64ddb55a, 6714 bytes) -> 1 section.
- `erights--elib-concurrency-when-catch` (Layer 3, the when-catch Syntactic
  Shorthand; SHA 6f664b3f644a, 6698 bytes) -> 1 section. The direct ancestor of
  `E.when` / the promise-reaction combinators / `Promise.then`.
- `erights--elib-concurrency-when-joiners` (Layer 4, Joining Multiple Resolutions;
  SHA 73d5b78c4795, 6531 bytes) -> 1 section.

EIO sub-hub children (real content):

- `erights--elib-concurrency-eio-goals` (EIO Design Goals; SHA b8492e10dce4, 22110
  bytes) -> 1 consolidated section: the requirements/preferences charter
  (non-blocking, InStream/OutStream fail-stop model, composability via
  pipes/filters/opto-isolation/backpressure).
- `erights--elib-concurrency-eio-obtaining` (Obtaining Elements from an InStream;
  SHA 5ffca11a5097, 26471 bytes) -> 1 consolidated section: the `obtain/5`
  primitive and its 2*2*3*2 = 24-cell input-operation taxonomy
  (reading/skipping/peeking/checking x NOW/WAIT/LATER); LATER returns a vow, the
  ancestor of async-iterator pull.

All six re-fetched and re-confirmed via `fetch-source.sh` (served by the erights.org
GitHub Pages mirror); SHAs matched the anchors recorded by erights-9.

## "Queued" -> "ingested" flips

- Sub-hub map sections `...-when-index--four-layers-of-when-map` and
  `...-eio-index--eio-non-blocking-io-map`: child lists now link to the ingested
  child sections; notes flipped from "queued for scholar-ingest-erights-10".
- Sub-hub source files `...-when-index` and `...-eio-index`: the "Child chapters
  (queued ...)" tables flipped to "Child chapters (ingested)" linking each child
  source.
- Hub map section `...-index--event-loop-reference-map` and hub source
  `...-index`: notes now record the `elib/concurrency/` chapter as fully ingested.

## Indexes touched

- `sources/README.md`: +6 rows (the two sub-hub rows' "queued for erights-10"
  flipped to "ingested in erights-10").
- Topic pages: `e-language` +6 (38->44), `eventual-send` +6 (92->98),
  `streams` +2 (the two EIO sections). The two sub-hub map rows' "queued" abstracts
  flipped to "ingested" on e-language and eventual-send.
- `topics/README.md` counts: e-language 38->44, eventual-send 92->98, streams 35->37
  (a peer scholar had corrected the streams count 13->35 mid-cycle, reconciling the
  long-standing silent drift this job flagged; my +2 brings it to the true 37).

## Integrity gate + sections index

- `library-link-check.sh --source-slug` PASSED (exit 0) on all six new clusters and
  on the three touched parent clusters (index, when-index, eio-index), run against a
  fresh detached worktree off the current origin/journal2 tip.
- `regenerate-sections-index.sh` regenerated and landed `sections/README.md`; all
  six new section slugs verified present.

## Landing discipline

Every content file landed via `land-journal-edit.sh` (producer-clone, synced to
tip). The live `journal/` worktree was stale on arrival (the documented hazard) and
was used read-only; all authoritative reads went through `git show origin/journal2`.
Shared indexes were rebuilt from a re-fetched tip immediately before landing to
avoid clobbering concurrent peers.

## Follow-ups / flags (not this job)

- The `elib/concurrency/` chapter is complete; no part-11 needed.
- Still open from erights-8/-9: a `--nav` library-link-check sweep reported ~20
  pre-existing dangling nav links (endo-but-for-bots--llm-designs-* cluster,
  concepts/polaris.md, concepts/powerbox.md, sources/endo--designs-daemon-persistence.md)
  warranting a separate library-link cleanup job.
- topics/README count drift remains a live hazard (streams was 13 vs actual 35 this
  cycle before a peer corrected it): a deterministic topics-README-count
  reconciliation check (recount each topic page's main Sections-table rows, compare
  to the README count column) would prevent recurrence. Carried forward.
- Optional concept-axis growth carried forward unchanged (vat, reference-mechanics,
  quasi-literal concept pages; finalizing the draft e-data-types concept).

Self-improvement: the topics/README count column drifts silently (this cycle: streams
13 vs true 35) and a peer happened to fix it mid-flight; the recurring fix is a
deterministic recount-vs-README-count check. Routing that lesson to the fleet per
self-improvement (one-line) rather than landing it myself, since it is a scripts/
addition outside scholar scope.
