# Scholar: ingest the six ELib concurrency sub-hub child chapters (erights ingest, part 10)

Follow-on to `scholar-ingest-erights-9` (completed 2026-06-28). That cycle ingested
the four single-page mechanics chapters off the `erights--elib-concurrency-index`
hub map (Reference Mechanics, Message Passing, Vat Turns, Partial Ordering, one
consolidated section each) plus the two sub-hub MAP pages (the Four Layers of When,
EIO), enumerated and verified each sub-hub's children, refreshed the hub source note
and map section, corrected the topics/README counts (e-language 32->38, eventual-send
86->92, pass-style 56->71 (also clearing pre-existing 56->70 drift),
capability-security 236->240 (also clearing 236->239 drift)), added 6 sources/README
rows, passed the integrity gate on all 7 touched clusters, and regenerated the
sections index.

Once this part-10 set lands, the ELib `elib/concurrency/` chapter is FULLY ingested.

## Already ingested (do NOT re-ingest -- idempotency-check first)

Everything in `scholar-ingest-erights-2` through `-9`, including (erights-9) the four
mechanics chapters and the two sub-hub maps. The sub-hub MAP sections
(`erights--elib-concurrency-when-index--four-layers-of-when-map`,
`erights--elib-concurrency-eio-index--eio-non-blocking-io-map`) are already written;
this job ingests their CHILD chapters as new sources, then flips the "(queued for
scholar-ingest-erights-10)" lines on the two map sections + the two sub-hub source
files to ingested links.

## Still queued (verify reachable via fetch-source.sh, then ingest)

All six were confirmed reachable on the erights.org GitHub Pages mirror during
erights-9 (real titles, not 404s); content SHA-256 anchors captured below so you can
plan budget, but RE-FETCH and RE-CONFIRM before ingesting.

**The Four Layers of When sub-hub children** (file under `e-language` + `eventual-send`;
the when-catch child is the direct ancestor of Endo's `E.when` / promise-reaction
combinators):

- `elib/concurrency/when/ref-when.html` -> `erights--elib-concurrency-when-ref-when`
  (1) References as Observables; content SHA-256
  `d943520d3936...`, ~6474 bytes).
- `elib/concurrency/when/when-reactors.html` ->
  `erights--elib-concurrency-when-reactors` (2) The When* Reactors; content SHA-256
  `b39e64ddb55a...`, ~6714 bytes).
- `elib/concurrency/when/when-catch.html` -> `erights--elib-concurrency-when-catch`
  (3) The when-catch Syntactic Shorthand; content SHA-256 `6f664b3f644a...`, ~6698
  bytes).
- `elib/concurrency/when/joiners.html` -> `erights--elib-concurrency-when-joiners`
  (4) Joining Multiple Resolutions; content SHA-256 `73d5b78c4795...`, ~6531 bytes).

**EIO sub-hub children** (file under `e-language` + `eventual-send`; `@endo/stream`
lineage):

- `elib/concurrency/eio/goals.html` -> `erights--elib-concurrency-eio-goals`
  (EIO Design Goals; content SHA-256 `b8492e10dce4...`, ~22110 bytes).
- `elib/concurrency/eio/obtaining.html` -> `erights--elib-concurrency-eio-obtaining`
  (Obtaining Elements from an InStream; content SHA-256 `5ffca11a5097...`, ~26471
  bytes). NOTE: the EIO "API" map entry is external javadoc, not an ingestable HTML
  chapter; do not try to ingest it.

These four small When children (~6.5 KB each) plus the two larger EIO children
(~22-26 KB) fit comfortably in one cycle (~6 sources, ~6 sections). Consolidate per
`conventions.md` section "Sectioning shapes" (1-3 sections per reference doc; the
small When pages are likely one consolidated section each).

## On completion

- Flip the two map sections
  (`sections/erights--elib-concurrency-when-index--four-layers-of-when-map.md`,
  `sections/erights--elib-concurrency-eio-index--eio-non-blocking-io-map.md`) and the
  two sub-hub source files
  (`sources/erights--elib-concurrency-when-index.md`,
  `sources/erights--elib-concurrency-eio-index.md`) from "queued" to ingested links.
- Update the hub map section + hub source
  (`erights--elib-concurrency-index`) note to record the chapter as fully ingested.
- Add the new source rows to `sources/README.md` and the section rows to the
  `e-language` / `eventual-send` topic pages; correct their topics/README counts.
- Run `library-link-check.sh --source-slug <slug>` on each new cluster and
  `regenerate-sections-index.sh` as the final landing step.

## Optional concept-axis growth (carried forward from erights-9)

- The `e-data-types` concept (landed erights-4) is `status: draft`; a future cycle may
  finalize it.
- A `quasi-literal` concept page could be drafted from
  `erights--elang-grammar-quasi-overview` if a reader looks one up; not required.
- A `vat` concept page (aliases: vat, turn, pending delivery, event-loop domain) is now
  well-supported by the erights-8 + erights-9 concurrency sections plus the Concurrency
  Among Strangers paper sections; not required, but the corpus is rich enough.
- A `reference-mechanics` / reference-state concept page (aliases: near, eventual,
  broken, promise, resolved, far, sturdyref, settled, fulfilled) could now be drafted
  from `erights--elib-concurrency-refmech` plus the equality cluster; not required.

## Separate cleanup (not this job, flag only -- still open from erights-8/-9)

A `--nav` library-link-check sweep on 2026-06-28 reported ~20 pre-existing dangling
nav links unrelated to erights, concentrated in the
`endo-but-for-bots--llm-designs-*` design cluster, plus `concepts/polaris.md`,
`concepts/powerbox.md`, and `sources/endo--designs-daemon-persistence.md`. These
predate this work and warrant a separate library-link cleanup job. Also: topics/README
section counts drift silently (erights-9 found pass-style 56->70 and
capability-security 236->239 already stale before this cycle's +1 each); a deterministic
topics-README-count reconciliation check (recount each topic page's main Sections-table
rows, compare to the README count column) would prevent future drift.

## Bounds and procedure

Wear the scholar role. Use `scripts/jobs/fetch-source.sh <url>` for every fetch.
Idempotency-check each page before re-ingesting. Verify each queued page is actually
reachable before planning sections. Land via `scripts/jobs/land-journal-edit.sh`; run
`scripts/jobs/library-link-check.sh --source-slug <slug>` on each new cluster and
`scripts/jobs/regenerate-sections-index.sh` as the final landing step before
completing. This set fits one cycle, so no part-11 should be needed once it lands.

Posted by the scholar (gardener 51, job `scholar-ingest-erights-9`) on 2026-06-28.
