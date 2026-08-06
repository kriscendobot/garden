---
model: opus
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T15:09:51Z cleared=none -->

---
model: opus
---
# Refactor: consolidate test262 fixtures (`@endo/test262-runner` + endor-vm cases) into one annotation-driven corpus with parameterized pass/fail expectations

**Repo:** `endojs/endo-but-for-bots`, PR arc `xs2rust-endor` (#600). **Gate: go-ahead** —
follow-up refactor, maintainer-triggered; not a press tick. Directive: @kriskowal
(liaison relay, 2026-07-26).

## Problem

test262 fixtures live in **two divergent places** today:

1. **`packages/test262-runner`** (`@endo/test262-runner`) — the full upstream
   test262 corpus under `test262/test/**`, driven by `test262-harness` v10 across
   three hosts: `test262:xs` (`xst`, `--features-include ses-xs-parity`, prelude
   `prelude/xs.js`), `test262:node` (`node`, `prelude/node.js`), and
   `test262:endor` (`scripts/run-endor-host.js`). The harness reads each case's
   **metadata annotations** (the test262 frontmatter: `flags` — `onlyStrict` /
   `noStrict` / `raw` / `module` / `async`, `includes`, `negative` phase+type,
   `features`, `es5id`/`es6id`).
2. **`rust/engine/endor-262/cases`** — the endor-vm dual-run harness's own
   hand-curated cases (`built-ins/`, `language/`, `regressions/`), maintained
   separately from the corpus above, with pass/fail knowledge encoded implicitly
   in Rust (skip reasons self-named by unsupported opcode/built-in).

Maintaining two fixture sets means the endor-vm inner loop and CI's
harness-driven runs can drift: a case the harness knows about may be absent from
the crate cases, and the crate's implicit skip taxonomy is not visible to the
harness's expectation accounting.

## Goal

**One source of truth** for test262 fixtures, consumed by both the endor-vm
dual-run harness and the CI `test262-harness` hosts, keyed off the **harness
annotations** already in each case, with **explicit lists of tests expected to
pass and fail parameterized by (host/engine, strict-mode, feature-set / roadmap
stage).**

## Sketch of the work (to be refined at promotion)

1. **Adopt the upstream corpus as the single fixture root.** The endor-262
   dual-run harness reads cases from `packages/test262-runner/test262/test/**`
   (or a committed manifest derived from it) instead of `endor-262/cases`. Keep
   `endor-262/cases/regressions` only for genuinely endor-specific regressions
   that have no upstream analogue; migrate `built-ins`/`language` cases that
   duplicate upstream to references into the corpus.
2. **Parse the harness annotations once, share the parse.** Factor the test262
   metadata parse (flags/includes/negative/features/esNid) into a shared reader
   both the Rust harness and `run-endor-host.js` consume, so strict/sloppy
   expansion, `includes` resolution, and `negative` handling are identical to
   `test262-harness`'s.
3. **Explicit, parameterized expectation lists.** Replace implicit Rust skip
   knowledge with committed **expected-pass / expected-fail (and expected-skip)**
   lists, keyed by (engine ∈ {xst, node, endor}, mode ∈ {strict, sloppy},
   feature-set / roadmap stage). A run is green iff observed outcomes match the
   list for its parameters; a newly-passing "expected-fail" or newly-failing
   "expected-pass" is the signal (ratchet), not a silent pass-rate. This
   subsumes the current honest-skip ledger (`typeof
   Uint8Array.prototype[Symbol.iterator]`, strict frozen AT-write, `toFixed(101)`
   RangeError, `String.replace` string-pattern, verbatim-lastIndex-slot) into
   machine-checked lists.
4. **Wire the differential oracle through the same lists.** The
   endor-vm-vs-C-XS dual run and the CI `xst`/`node`/`endor` hosts all report
   against the same parameterized expectations, so parity (or observable
   deviation) is one comparison, not two bespoke ones.

## Why now (the end-state this is groundwork for)

This consolidation is the prerequisite for the maintainer's target end-state
(separate parked plan `decommission-cxs-rust-default-xst-ci-parity`): once the
port is complete, `c/moddable` and the C-binding Endor variant are removed, the
Rust VM becomes default, and **parity is established only through the `xst`
binary downloaded from Moddable in CI, run under `test262-harness`** to maintain
parity or at least observable deviation. That end-state needs exactly one
annotation-driven corpus with parameterized expectations — this refactor builds
it while both engines still exist to cross-check.

## Acceptance

- endor-vm dual-run harness and CI hosts read ONE corpus + shared annotation
  parser; no duplicated case trees (regressions excepted, documented).
- Committed parameterized expected-pass/fail/skip lists; CI is green iff observed
  == expected; ratchet surfaces both directions.
- The existing honest-skip ledger is fully represented as list entries.
- No net change to what actually passes today (pure refactor + expectation
  externalization), proven by a before/after run at a pinned tip.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T15:09:56Z
