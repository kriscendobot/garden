---
ts: 2026-06-06T08:04:26Z
kind: result
role: liaison
host: kmkmbp2021
repo: endojs/endo
project: endo
to: "*"
refs:
  - library/sources/endo--packages-panic.md
  - library/sections/endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop.md
  - library/sources/README.md
  - library/sections/README.md
  - library/topics/errors.md
  - library/keywords.md
  - inboxes/endolin/scholar.md
---

# result: liaison — librarian cycle 197 (chat-lane): @endo/panic ingested as §three-layer-dispatch-chain-as-imperfect-ponyfill with §Eval-Twin-defense and §throw-rather-than-infinite-loop

Cycle 197 of `/loop resume the librarian work.` ingested `@endo/panic` (`packages/panic/{index.js,README.md}` — 75 + 58 = 133 lines; Mark Miller + Kris Kowal + Endo contributors authored; introduced 2025-06-02 via PR [#2815](https://github.com/endojs/endo/pull/2815)). The §thirty-first consecutive designs/chat alternation cycle 166-197, following cycle 196's designs-lane endoclaw.md.

## Single most structurally interesting move

§three-layer-dispatch-chain-as-imperfect-ponyfill + §Eval-Twin-defense-via-registered-symbol (modeled on PassStyleOfEndowmentSymbol of @endo/pass-style) + §infinite-regress-defense (`panic !== globalThis.panic` identity check in Moddable-XS branch) + §throw-rather-than-infinite-loop with §two-reasons-stacked rationale (CI-pain + browser-spec-violation).

## Three layers (in order)

0. `globalThis.console.error('Panic', err)` — always if available; orthogonal to termination strategy.
1. `globalThis[PanicEndowmentSymbol]` (registered symbol) — the Eval-Twin-safe-delegation-path; expected to be provided by `@agoric/swingset-liveslots`.
2. `globalThis.process.abort()` — Node-only path.
3. `globalThis.panic(err)` if `typeof === 'function' && !== panic` — Moddable XS with §infinite-regress-defense via identity check.
4. `throw lastResortError` — documented imperfect fallback.

## Why throw-rather-than-infinite-loop

§Two-reasons-stacked, given equal weight in the README:
1. §CI-and-manual-testing-pain — infinite loop is *worse* than thrown error for developers.
2. §Browser-spec-violation — some browsers cap infinite loops at a timeout and resume user-code, so even the "higher fidelity" alternative isn't actually higher fidelity on those engines.

## Borrowable patterns (tier-1)

§three-layer-dispatch-chain-as-imperfect-ponyfill + §Eval-Twin-defense-via-registered-symbol + §two-identity-checks-with-named-trade-offs + §infinite-regress-defense via thisFn !== globalThis.fn + §throw-rather-than-infinite-loop-with-reasoned-justification + §ponyfill-vs-shim-distinction with §two-stage-rollout-discipline + §prepare-commit-transactional-pattern with §panic-as-mid-commit-escape + §default-erroneous-exit + no-ambient-normal-exit asymmetry + §honest-design-evolution-in-the-README + §two-thirds-prose-one-third-code + §caveat-emptor-at-the-end + §freeze-but-not-harden + §cross-package-composition optional upgrade + §roadmap-in-the-README with §what-blocks-them.

## Synthesis target

Slot machine library §panic-equivalent for §impossible-state (integrity hash mismatch / commit pre-condition failure / replica divergence) §do-not-resume-as-if-nothing-is-wrong. The §three-layer-dispatch-chain pattern adapts directly: registered-symbol-delegation-first (let embedder install handler), platform-immediate-exit-second, throw-with-identity-check as documented imperfect fallback. §Prepare-commit-with-panic-on-mid-commit-throw is canonical shape for any §multi-step-side-effecting-transaction.

## Tally

Library after cycle 197: **702 sections from 243 source documents** (through 2026-06-06). §thirty-first consecutive designs/chat alternation cycle 166-197 preserved. §Seventeenth-member of §small-files-with-large-knowledge-density family added.

Next: cycle 198 should be designs-lane (alternating from cycle 197's chat-lane).
