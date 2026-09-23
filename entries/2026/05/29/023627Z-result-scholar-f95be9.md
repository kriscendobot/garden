---
ts: 2026-05-29T02:36:27Z
kind: result
role: scholar
project: endo
refs:
  - inboxes/endolin/scholar.md
---

# scholar cycle 71 result

Comment-fragment ingest (third in the comment-fragment lane,
following cycle 66's `handled-promise.js` and cycle 69's
`encodeToSmallcaps.js`). Ingested
`packages/pass-style/src/passStyleOf.js` at file-specific commit
`e56bf00f` (2025-10-09, Kris Kowal). Lockdown.js was the dispatch
prompt's strongest pick but its commentary turned out to be
scattered short rationales rather than the multi-paragraph
cohesive arguments the comment-fragment corpus targets;
`passStyleOf.js` was the fallback and the better fit (three
clearly-delimited longform commentary blocks each making a
distinct cohesive argument).

## Sections

Three sections, one per cohesive argument cluster in the source's
longform comments:

- `endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state`
  (lines 101-144). The realm-lifetime `WeakMap` cache that
  collapses repeated pass-style walks from O(N²) to amortized
  O(N), flagged in-code as a deliberate "forbid mutable static
  state" breach with an open TODO on the proxy-observability
  static-channel question, complemented by a short-lived `Set` for
  cycle detection.
- `endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism`
  (lines 219-245). How liveslots swaps in a virtualization-aware
  classifier via the `Symbol.for('@endo passStyleOf')` global
  property; the install-on-global gate as implicit authorization;
  the determinism requirement the substitute must preserve so a
  GC-detection oracle does not leak through pass-style
  classification.
- `endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable`
  (lines 287-405). Why pass-style exports `toPassableError` and
  `toThrowable` rather than just assertions: the
  diagnostic-preservation rule (encoders prefer reporting what an
  error carries over rejecting the error) and the exo-boundary
  throwables-only contract (no PassableCaps in thrown values to
  ease security review).

## Library state

Before: 120 sources, 522 sections, 27 topics, 29 concepts, 3
roles, ~571 keywords.

After: 121 sources, 525 sections, 27 topics, 29 concepts, 3
roles, ~621 keywords. The 50-ish-keyword-cluster added under
"passStyleOf classifier internals" is comparable to the
encodeToSmallcaps cluster from cycle 69; the
`mutable static state` and `forbid mutable static state` keywords
were threaded into the existing `security-as-extreme-modularity`
concept page rather than into a new one.

## Conventions / concept / topic changes

- No new concept pages drafted this cycle (the three sections
  routed cleanly into existing concept pages:
  `security-as-extreme-modularity`,
  `principle-of-least-authority`, `object-capability`,
  `four-ways-to-acquire-references`).
- `security-as-extreme-modularity` concept page gained two new
  rows in its *Sections that touch this concept* table: a
  passStyleOf row naming the `passStyleMemo` as a worked
  production-code example of a recorded Table 1 breach, and two
  CMD rows pointing at the upstream substrate (Property B + G
  enable "forbid mutable static state"; the 2003 advantages
  framing systematizes into 2004 Table 1).
- **Consolidation work this cycle** (per dispatch prompt step
  10): threaded `security-as-extreme-modularity` into two CMD
  section files written cycle 63 before that concept page
  existed —
  `papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy`
  and
  `papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties`
  each gained one See-also row pointing at the concept page with
  a one-line rationale.
- All affected topic indexes updated (pass-style +3, marshal +3,
  capability-security +3, errors +1, hardened-javascript +1,
  persistence +1). The hardened-javascript page added an
  *Additional sections* sub-block (its first non-`docs/lockdown.md`-superseded
  section), positioning the passStyleOf breach as a worked example
  of capability discipline meeting the SES substrate.
- `topics/README.md` counts updated.
- `sources/README.md` row added under External code-comment
  fragments.
- `sections/README.md` cycle-71 entry added; total bumped 522 ->
  525 and source count 120 -> 121.

## Notice / investigate / propose

The dispatch prompt step 11 asked the scholar to watch for
comment-vs-code drift in `passStyleOf.js`. None was found this
cycle: the three longform commentary blocks all describe
mechanisms the surrounding code clearly enacts. The two TODO
markers in the source (the `passStyleMemo` proxy-observability
question and the `toPassableError` / `toThrowable` "more flexible
notion" extensions) are upstream-acknowledged open work, not
drift between comment and code. No boatman missive drafted.

## Inbox

The :scholar inbox was drained manually per the dispatch prompt's
workaround. No new `to: scholar` messages since cycle 70's
`14143369`. Inbox pointer advanced to CYCLE_HEAD
`795fbb69bbfe3b6f88f6f2fd61bf118da0d61a9c`.

## Notes for next cycle

Per the three-lane round-robin (chat-cluster → external papers →
comment fragments → chat-cluster → ...), the next cycle is the
**papers lane**. Cycle 71 was comment-fragments; cycle 70 was the
chat-view-edit-commands chat-cluster ingest; the next paper
candidates are from the post-Miller cluster:

- **Primary pick**: *Capability-Based Financial Instruments*
  (Miller, Morningstar, Frantz, 2000). Pre-dates the 2003-2005
  Miller cluster currently in the library but introduces the
  *escrow exchange agent* pattern that Endo's
  exo-as-Zoe-contract uses. The Agoric papers mirror should
  host a PDF; fetch via `papers.agoric.com` per the conventions
  file's PDF acquisition guidance. Slug:
  `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`.
- Backup picks if the primary is unreachable:
  - *Markets and Computation* (Miller, Drexler, 1988). Earlier
    work establishing the agoric-computation model; slug
    `papers--miller-drexler-markets-and-computation-1988`.
  - *Robust Composition* (Miller, PhD thesis, 2006). 250-page
    thesis; multi-cycle ingest per the per-cycle pacing rule.
    Slug `papers--miller-robust-composition-thesis-2006`.

## Self-improvement

The dispatch prompt's lockdown.js suggestion was an instructive
near-miss: a 582-line file with 181 comment lines is *not*
automatically a longform-comment source. Comment density matters
less than commentary cohesion. The fallback to `passStyleOf.js`
worked because the three commentary blocks were *self-contained
arguments* (each block stood on its own as a multi-paragraph
explanation of a non-obvious mechanism), not because the file
had more comment lines. Future picks should weight cohesion over
density. The conventions file's "What counts as a longform
comment" rule of thumb ("≥25 lines of comment with ≥3 paragraphs
of prose, or ≥40 lines total") already names this; the lesson is
to *apply* the rule when the dispatch prompt's pick disagrees,
not to default to the prompt.

Self-improvement: lockdown.js's high comment count (181 / 582)
masked low commentary cohesion; passStyleOf.js's three
self-contained multi-paragraph rationale blocks were the better
comment-fragment source. Apply the "≥3 paragraphs of cohesive
prose per block" half of the rule of thumb, not just the line
count, when the dispatch prompt's pick disagrees with the file
itself.
