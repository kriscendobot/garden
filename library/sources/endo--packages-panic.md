---
title: "@endo/panic — ponyfill for the TC39 'Don't Remember Panicking' proposal"
source-slug: endo--packages-panic
url: https://github.com/endojs/endo/tree/master/packages/panic
authors: [Mark Miller, Kris Kowal, Endo contributors]
repo: endojs/endo
path: packages/panic/{index.js,README.md,CHANGELOG.md,SECURITY.md,package.json}
total-lines: 75 (index.js) + 58 (README.md)
license: Apache-2.0
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/panic

Ponyfill (imperfect, by author admission) for the TC39 [Don't Remember Panicking](https://github.com/tc39/proposal-oom-fails-fast) proposal's `panic` function. The proposed `panic` immediately terminates the JavaScript agent (thread/vat/event-loop) so its internal data state becomes unobservable. JavaScript has no portable primitive that achieves that, so this ponyfill chains three increasingly-imperfect approximations and explicitly throws-rather-than-infinite-loops as the last resort.

## Provenance and version

- Introduced 2025-06-02 (v0.2.0) via PR [endojs/endo#2815](https://github.com/endojs/endo/pull/2815).
- Current at v1.0.1 (released 2025-06-17, version-only bump).
- Single `main`/`module`/`exports` entry pointing at `./index.js`; no per-platform variants yet (a `panic-shim` export is forecast for when the TC39 proposal advances).
- `@endo/swingset-liveslots` is expected to be the primary embedder providing a `globalThis[PanicEndowmentSymbol]` implementation; see [Agoric/agoric-sdk Draft PR #11173](https://github.com/Agoric/agoric-sdk/pull/11173).

## Three exports

1. **`panic(err = RangeError('Panic'))`** — the ponyfill function. Three-layer dispatch (registered symbol → process.abort → Moddable-XS global) with a console-error diagnostic first and `throw lastResortError` as the documented imperfect fallback. Frozen.
2. **`PanicEndowmentSymbol = Symbol.for('@endo panic')`** — the registered symbol the embedder uses to install a panic-handler. Registered (not local) symbol so all instances of the package in one agent share the same key. Modeled on `PassStyleOfEndowmentSymbol` of `@endo/pass-style`.
3. **`lastResortError`** — `ReferenceError('Should have already exited')` with `[PanicEndowmentSymbol]: 'Should have already exited'`. Frozen. Two identity-check shapes are documented: property-presence (forgeable but twin-safe) and `===`-comparison (non-forgeable but twin-vulnerable due to Eval Twin Problem).

## Key design moves

- **§ponyfill-vs-shim distinction** named explicitly in the README. §Two-stage-rollout-discipline: ponyfill first, shim later when the TC39 proposal advances. (At v1.0.1, the team has chosen not to ship the shim yet because the proposal is too early.)
- **§Eval Twin Problem** ([endojs/endo#1583](https://github.com/endojs/endo/issues/1583)) explicitly cited; registered-symbol mitigation modeled on `PassStyleOfEndowmentSymbol`. Trade-off named: forgeable marking is the necessary cost of being twin-safe.
- **§Three-layer-dispatch-chain-as-imperfect-ponyfill** ordering: (0) console diagnostic if available, (1) `globalThis[PanicEndowmentSymbol]`, (2) `globalThis.process.abort` (Node), (3) `globalThis.panic` if not self (Moddable XS), (4) `throw lastResortError`.
- **§Infinite-regress defense** via `panic !== globalThis.panic` identity check in the Moddable-XS branch — anticipates a future shim built on this ponyfill that installs itself at `globalThis.panic`. Without the check, the ponyfill would call itself transitively.
- **§Throw-rather-than-infinite-loop with reasoned justification** — README considers and rejects infinite-loop alternative on two grounds: (a) CI and manual-testing pain, (b) some browsers cap infinite loops and resume user-code, so even higher-fidelity emulation isn't safe.
- **§Prepare-commit-transactional-pattern** as the README's canonical worked example: prepare-phase (no side effects, may early-exit by return/throw), try-commit-phase (straight-line no-control-flow side effects), catch-panic-phase (`panic(...)` on unrecoverable state).
- **§Default-erroneous-exit + no-ambient-normal-exit** asymmetry — erroneous exit is ambient because, per §historical-note, the team realized infinite loops are already as bad as erroneous exits, so denying ambient erroneous exit buys no security; normal exit remains capability-granted.
- **§Honest-design-evolution-in-the-README** — explicit historical-note paragraph names the prior position alongside the current one.
- **§Caveat-emptor-at-the-end** of the README — users on platforms where the first two layers might fail must cope with possible resumption-of-user-mode-execution as best they can.
- **§Object.freeze discipline** on both `panic` and `lastResortError` — §freeze-but-not-harden (preparing-for-stabilize-doc pattern; cycle 146 sibling).
- **§Two-thirds-prose-one-third-code** comment density — 75 lines of index.js carry ~25 JSDoc/comment lines + 58 README lines for ~33 lines of execution.

## Three named future extensions

1. **§Shim-export** (`@endo/panic/panic-shim`) — deferred until TC39 proposal advances.
2. **§Platform-specific-immediate-exit-on-other-platforms** — Node's `process.abort` is the only one supported now; the README is open about adding more as they're identified.
3. **§Moddable-XS-print-function detection** — TODO comment in source notes the team can't reliably distinguish XS's `print` from browser's `print` for fallback logging.

## Ingest scope

Cycle 197 (chat-lane): full ingest of `index.js` + `README.md` + `package.json` + `CHANGELOG.md` excerpt + `SECURITY.md` excerpt. No section-file split — the package is structurally a single concept (the three-layer dispatch chain with Eval-Twin and infinite-regress defenses) so one section.

## Related material in the library

- **cycle 189 marshal-justin + marshal-stringify**: cited Eval Twin Problem defenses + qp/q template-tag pair (a different package using `@endo/errors` for diagnostics — the @endo/panic README recommends the same composition path).
- **`@endo/pass-style`**: precedent for the registered-symbol-via-`Symbol.for` pattern (PassStyleOfEndowmentSymbol).
- **`@endo/errors`**: panic README's optional-upgrade-path for better diagnostics.
- **cycle 187 shim+prepare-endo cluster**: two-stage rollout discipline parallel — explicit shim strategies named.
- **cycle 162 daemon-Ken-protocol-implementations**: §atomic-checkpoint semantics matched at a higher layer.
- **cycle 194 daemon-endo-rust-sqlite**: §re-prepare-instead-of-caching-Statement is another all-or-none invariant implemented in a different language and storage layer.
- **cycle 146 E.js**: §freeze-but-not-harden-the-proxy-target sibling-pattern.
