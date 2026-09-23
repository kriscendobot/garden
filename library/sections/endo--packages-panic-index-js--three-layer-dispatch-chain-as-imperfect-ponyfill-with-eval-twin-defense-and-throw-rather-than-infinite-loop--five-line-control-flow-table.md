---
title: §Five-line-control-flow-table
source: endo packages/panic/{index.js,README.md,SECURITY.md,CHANGELOG.md}
source-slug: endo--packages-panic
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal]
keywords:
  - ponyfill-vs-shim distinction
  - Eval Twin Problem
  - registered-symbol vs novel-subclass
  - three-layer dispatch chain
  - infinite-regress check
  - throw-rather-than-infinite-loop
  - lastResortError as identity check (forgeable + non-forgeable both honestly named)
  - prepare-commit-transactional-pattern as canonical use-case
  - Don't Remember Panicking TC39 proposal
  - PanicEndowmentSymbol following passStyleOfEndowmentSymbol precedent
  - default-erroneous-exit + no-ambient-normal-exit
  - historical-note-explaining-why-ambient-panic-no-longer-loses-security
related:
  - endo--packages-pass-style (sibling: PassStyleOfEndowmentSymbol precedent + Eval Twin Problem)
  - endo--packages-errors (panic README: makeError/X/q template tag)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: also cites Eval Twin defenses + qp-vs-q template tag pair)
  - endo--packages-init-and-lockdown (cycle 183: two-phase init also depends on SES primordials)
parent: endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop
---

| Layer | Branch condition | Action | Notes |
| --- | --- | --- | --- |
| 0 | `globalThis.console.error` is function | log diagnostic via `console.error('Panic', err)` | §best-effort-not-required-for-correctness; fall through afterward |
| 1 | `globalThis[PanicEndowmentSymbol]` is function | `globalThis[PanicEndowmentSymbol](err)` | §the-Eval-Twin-safe-delegation-path; expected for swingset-liveslots |
| 2 | `globalThis.process` exists and `.abort` is function | `globalThis.process.abort()` | §the-Node-path; non-zero exit code |
| 3 | `typeof globalThis.panic === 'function'` AND `panic !== globalThis.panic` | `globalThis.panic(err)` | §the-Moddable-XS-path; §infinite-regress-defense via identity check |
| 4 | (fallthrough) | `throw lastResortError` | §the-last-resort; violates spec but documented |

Layer 0 is *not* gated — it always runs first if the predicate matches, then falls through to the next four layers (which are mutually exclusive `else if` branches). §Diagnostic-logging-is-orthogonal-to-termination-strategy: §even-if-termination-fails-the-diagnostic-was-recorded.

§TODO-in-the-source for §Moddable-XS-print-function: the team knows there's a path to add a logging-fallback for XS but can't reliably distinguish `print` in Moddable from `print` in browsers. §Honest-named-deferred-work.
