---
title: §Prepare-commit-transactional-pattern as canonical use-case
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

The README's primary worked example is the §all-or-none transaction:

```js
function transaction() {
  // prepare phase with no side effects, which might exit early with `return`
  // or `throw`. Such an early exit is the "none" of "all or none" side effects.
  prepare();
  try {
    // commit phase, where exit by `throw` must not happen, so all side effects
    // expressed by normal *local* control-flow happen.
    localSideEffect1();
    localSideEffect2();
  } catch (err) {
    // Neither "all" or "none" happened, leaving behind unrecoverable corrupt
    // local data, which therefore must not be observable to user code.
    panic(Error(`unrecoverable transaction fail due to ${err}`));
  }
}
```

§Prepare-commit-with-panic-on-mid-commit-throw is the §canonical-pattern-for-using-panic-correctly. The comment explicitly aligns:
- §prepare-phase: early exit OK (= "none" side of all-or-none)
- §commit-phase: §should-be-straight-line-no-control-flow §to-make-set-of-side-effects-clear
- §exception-in-commit: §unrecoverable-state-must-not-be-observable → `panic`

The pattern matches cycle 162's Ken-properties (§atomic-checkpoint) and cycle 194's daemon-endo-rust-sqlite (§re-prepare-instead-of-caching-Statement) — three different libraries, three different storage layers, three implementations of the same §all-or-none-transactional-discipline. The §panic-as-the-escape-hatch-for-when-commit-detects-impossible-state is the contribution @endo/panic makes to the pattern.

The README then offers an §upgrade-path: if `@endo/errors` is also available, use `makeError(X${...}${q(err)})` for §better-diagnostic-on-the-ses-console. §Cross-package-composition is named.
