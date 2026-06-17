---
ts: 2026-06-17T21:45:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: bacf49
prs:
  - { repo: endojs/endo-but-for-bots, pr: 450, role: new }
refs:
  - entries/2026/06/17/203617Z-dispatch-designer-bacf49.md
  - entries/2026/06/17/203500Z-result-researcher-4151cb.md
---

# result: designer — PR #450 presence-severance-observation (retried after socket-error attempt)

PR #450 DRAFT, base llm, head
design/presence-severance-observation. Single file
`designs/presence-severance-observation.md` + designs/README
summary row.

## Load-bearing choices

- **Observer API: (a) `E.whenSevered(presence) →
  Promise<never>`**. Aligns with existing `Promise<never>`
  cancellation convention from `cli-http-client.md`;
  composes with `Promise.race`; sits on `E` because holders
  already import `E`. Options (b) HandledPromise method
  and (c) Exo facet rejected.
- **Vocabulary: "severance" as umbrella** (partition /
  abort / disconnect each name layer-specific facets;
  none covers all three sub-cases).

## Researcher's two verifications resolved

- **`handler.HAS` / `handler.DELETE`: imagined.** Handler
  protocol exposes only `get` / `applyMethod` /
  `applyFunction` (+ `*SendOnly` variants) per
  `packages/eventual-send/src/handled-promise.js:152,158,179`.
  Design does NOT extend the protocol; severance hook is a
  property on the handler value.
- **`whenAborted` / `whenDisconnected` in `@endo/captp`:
  absent.** `makeCapTP` returns `{abort, dispatch,
  getBootstrap, getStats, isOnlyLocal, serialize,
  unserialize}`. `CTP_DISCONNECT` handling at
  `captp.js:812` rejects `settlers`-map promises but
  produces no per-presence observable. Design lands
  `whenAborted` as a NEW field on the return triple +
  per-presence WeakMap fan-out.

## Open questions for maintainer

1. Severance concept page vs alias of existing partition /
   abort / disconnect vocabulary.
2. Re-binding semantics — design inherits
   `daemon-cross-peer-gc`'s reconnect-as-fresh-snapshot;
   `whenRebound` deferred.
3. Debouncing — left to consumer.
4. Cleanup ownership — caller-owned `Promise<never>`;
   rejected callback shape (callback risks
   error-path-cannot-depend-on-error-path violation).

## Designer self-improvement signal

When a dispatch prompt names a primitive the researcher's
library references do NOT corroborate, verification is a
first-class design deliverable (not a footnote). A future
`roles/designer/AGENT.md` *Notes from the field* row could
consolidate this with the 2026-06-09 consumer-smoke-test
row. (Recorded in designer's own result entry, not
forwarded as message — single observation, below threshold.)

Dispatch root torn down.
