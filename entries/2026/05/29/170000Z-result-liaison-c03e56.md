---
ts: 2026-05-29T17:00:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/endo--packages-eventual-send-src-track-turns-js.md
---

# liaison cycle 90 result — track-turns.js ingest

Comments-lane ingest (cycle 90, **eighth comment-fragment ingest**, per the three-lane rotation after cycle 89's chat-lane).

Ingested `endojs/endo: packages/eventual-send/src/track-turns.js` at file-specific commit `86d983a0fbd1c16089953eecabaec28e85defed5` (last touched 2025-05-12 by Mark S. Miller). Three argument-cluster sections from the 117-line file:

1. `module-disclaimers-and-env-option-gates` (lines 1-31) — cyclic-dependency / not-in-scope-before-lockdown disclaimer forcing `globalThis.assert` lazy access instead of static imports; meta-level-privilege framing for *deliberate* global mutable state (the one exception to this module's no-observably-mutable-state norm); two env-option gates `TRACK_TURNS=enabled` for the feature and `DEBUG=track-turns` for verbose console output.
2. `closure-hoisting-and-bidirectional-error-annotation` (lines 33-76) — closure-hoisting discipline as practice-driven HandledPromise-retention mitigation; bidirectional error annotation (synchronous throws via try/catch + asynchronous rejections via Promise.catch); the *must-capture-this-now* timing rule for the detailsNote string; `THROWN to top of event loop` vs `REJECTED at top of event loop` log distinction; finally-clear of hiddenPriorError for inter-turn hygiene.
3. `sending-event-causes-receiving-events-causal-model` (lines 78-117) — the trackTurns JSDoc's causal model: *the call to trackTurns is itself a sending event, that occurs in some call stack in some turn number at some event number within that turn; each call to any of the returned TurnStartFns is a receiving event that begins a new turn; this sending event caused each of those receiving events*. Inert-fallback guard (3 conditions: ENABLED false / globalThis undefined / globalThis.assert missing); `Caused by:` chain via annotateError; TurnStarterFn this-free typedef constraint.

## Pick rationale

Per cycle 89 notes-for-next-cycle, comments-lane candidates were `packages/patterns/src/keys/checkKey.js` (lower density), `packages/marshal/src/marshal-justin.js` (utility code), `packages/exo/src/exo-makers.js`, `packages/captp/src/captp.js`, and `packages/eventual-send/src/track-turns.js`.

URL-style comment-density survey on `endojs/endo@FETCH_HEAD`:
- `exo-makers.js`: 242 lines / 70 comments (29% — mostly JSDoc parameter blocks).
- `captp.js`: 1012 lines / 258 comments (25%) — *too large for one cycle*, would need multi-cycle plan.
- `track-turns.js`: 117 lines / 42 comments (36% — highest density) — Mark Miller-authored; three coherent argument clusters with no padding.

**track-turns.js was the cohesion-over-density winner** despite being the smallest of the eight comment-fragment ingests so far. The file's 117 lines decompose cleanly to three coherent argument-cluster sections, each load-bearing for one structural concept (deliberate-mutable-state-as-meta-level-privilege; bidirectional-error-annotation-with-must-capture-this-now-timing; sending-event-causes-receiving-events causal-DAG).

## Three drafting-lessons confirmed (plus one observation)

1. **Bare-clone verification before drafting upheld.** All five candidates verified to exist; comment-density survey then drove the pick.
2. **Per-section commit discipline upheld** — each section committed as written, not batched. Cycle-67 mitigation continues to apply.
3. **Cohesion-over-density discipline upheld** — three sections rather than one or two, but each section is a coherent self-contained argument cluster. The 117-line file's cohesion-density justifies the 3-section budget.
4. **Source-slug duplicate-check (cycle 89's new discipline) upheld** — checked `library/sources/endo--packages-eventual-send-src-*` before drafting; no prior ingest.

## Library state after cycle 90

- Sources: 136 (was 135) — adds the track-turns.js comment-fragment source.
- Sections: 579 (was 576) — adds 3 sections.
- Topics: 27 (unchanged) — threading into eventual-send (62 → 65), errors (24 → 26), hardened-javascript (94 → 95), capability-theory (31 → 32).
- Concepts: 44 (unchanged) — cohesion-over-density continues to defer concept-page creation.
- Keywords: ~1820 (was ~1740) — added ~80 aliases tied to this module's vocabulary.

## Cross-source linkage

This ingest links to multiple prior threads:

- **`endo--packages-marshal-src-marshal-js--error-diagnostic-priority`** (cycle 74) — marshal-side complement: why the stack is deliberately not put on the wire. Track-turns' diagnostic-only state pairs with marshal's stack-omission policy.
- **`endo--packages-pass-style-src-error-js--*`** (cycle 87) — the pass-style error-validation surface, also Mark-authored. The three-section pass-style/error.js ingest paired the three-section track-turns.js ingest in their host-configuration-aware capability discipline.
- **`papers--miller-tribble-shapiro-concurrency-among-strangers-2005--{promise-pipelining, partial-failure-and-when-catch}`** (cycles 65 / 67) — the eventual-send pipeline; track-turns instruments the causal annotations across the pipelined chain and the partial-failure broken-reference rejections.
- **`papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules`** (cycle 85) — the formal Hoare logic with the *METH-CALL-2* postcondition; track-turns' sending-event-causes-receiving-events DAG is the runtime operational counterpart.
- **`papers--close-acls-dont-2009--*`** (cycle 88) — Tyler Close's ACL critique. The causality-link discipline in track-turns is structurally similar to Close's §2.6 *capability-identity-equality enables delegation-chain tracking*.

## Notes for next cycle (91)

Three-lane rotation pointer advances to **papers-lane**.

Future paper-lane candidates per cycle 88 / 89 discovery (Agoric mirror's unexplored papers):
- *Comparative Ecology: A Computational Perspective* (Huberman / Hogg) — companion to Markets and Computation 1988.
- *Incentive Engineering for Computational Resource Management* — agoric-systems companion.
- *Robust and Compositional Verification of Object Capability Patterns* — Drossopoulou-adjacent, may overlap with cycle 85.
- *Automated Analysis of Security-Critical JavaScript APIs* (Taly et al 2011) — early SES verification.
- *Tahoe-LAFS* — Wilcox-O'Hearn et al distributed-file-storage capability paper.
- *The Digital Path: Smart Contracts and the Third World* (Stiegler + Miller 2002) — needs URL probe.
- **Robust Composition** (Miller PhD 2006) — 250-page thesis; multi-cycle plan pending; maintainer call when to begin.

Future chat-lane candidates:
- All currently-known chat designs ingested. New chat-lane cycles will need bare-clone listing of `origin/design/chat-*` branches against `library/sources/` for any newly-merged designs.

Future comments-lane candidates after cycle 91:
- `packages/exo/src/exo-makers.js` (verified present; comment density mostly JSDoc; partial-rationale value).
- `packages/patterns/src/keys/checkKey.js` (verified present; lower density).
- `packages/marshal/src/marshal-justin.js` (verified present; utility-code).
- `packages/captp/src/captp.js` (verified present but 1012 lines; would need multi-section selective ingest plan).
- New candidates to survey: `packages/lockdown/src/lockdown-shim.js`, `packages/ses/src/error/*.js` (the SES side of the error story), `packages/daemon/src/daemon-node.js`.

## Reminder of cycle-89's source-slug duplicate-check discipline

Before drafting, run `ls journal/library/sources/ | grep <slug-fragment>` to detect prior ingest. The duplicate-check is the cycle-89 lesson-learned that should now be standing cycle norm.
