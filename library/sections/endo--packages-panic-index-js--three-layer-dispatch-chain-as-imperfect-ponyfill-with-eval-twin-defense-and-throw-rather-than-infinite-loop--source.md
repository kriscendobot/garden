---
title: Source
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

- `endo packages/panic/index.js` — 75 lines (one default export `panic`, one symbol export `PanicEndowmentSymbol`, one identity export `lastResortError`)
- `endo packages/panic/README.md` — 58 lines (canonical-use-case + ponyfill-vs-shim distinction + three-layer explanation + design rationale)
- `endo packages/panic/CHANGELOG.md` — 11 lines (v0.2.0 introduced 2025-06-02 via PR [#2815](https://github.com/endojs/endo/pull/2815))
- `endo packages/panic/package.json` — name `@endo/panic`, version `1.0.1`, `type: module`, single `main`/`module`/`exports` entry pointing at `./index.js`.

Cycle 197 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 196's designs-lane endoclaw.md; §thirty-first consecutive designs/chat alternation cycle 166-197).
