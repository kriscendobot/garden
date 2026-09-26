PR #392 is now `MERGEABLE`, base still correctly targets `design/gateway-package-phase-3` (#389's head), rebased onto its new head `c7307a12a9`. `UNSTABLE` reflects pending/known-flaky CI (the Node-24.x/better-sqlite3 infra bug), not a conflict.

## Completion report

**Restacked PR #392 (gateway phase-4) onto PR #389's (phase-3) new rebased head.**

- **Parent confirmed, not assumed:** PR #389's new head is `c7307a12a9` (`feat(gateway): separate admin sock from bootstrap sock…`). Phase-4's old parent was `d9cd280815`; rebased the 3 phase-4-unique commits with `git rebase --onto c7307a12a9 d9cd280815`.
- **Type porting was required (not just conflict resolution).** The `llm` rewrite that #389 sits on relocated the gateway type layout from inline `@typedef`s in `index.js` into `packages/gateway/src/types.ts`. Phase-4's diff added `getOcapnHandler` to the `Gateway` type and imported `OcapnWebSocketHandler`. I ported those additions:
  - `index.js`: resolved to the new `types.js`-import style (dropped the now-relocated inline `Gateway`/`GatewayPowers` typedefs entirely); kept the `/** @import { OcapnWebSocketHandler } from './src/ocapn-ws.js' */` line since index.js still annotates a local `OcapnWebSocketHandler` variable.
  - `types.ts`: added `import type { OcapnWebSocketHandler } from './ocapn-ws.js'` and the `getOcapnHandler(): Promise<OcapnWebSocketHandler>` member on the `Gateway` type — the correct home now that the type lives there.
  - `config.js` auto-merged cleanly: new phase-3 already carried the `ocapnWebSocket` default + `captpRelay→ocapnWebSocket` validation; phase-4's `ocapnWebSocket→sockBootstrap` validation slotted in with no duplication.
  - `yarn.lock` conflict resolved by taking the base and regenerating (`yarn install --mode update-lockfile`) so phase-4's added `@endo/stream` workspace dep is recorded, in its own `chore: Update yarn.lock` commit.
- **Local-verify (`packages/gateway`):** `tsc` clean (0 errors); `eslint` 0 errors (9 pre-existing warnings, none new); **176 tests passed** (includes phase-4's new `test/ocapn-ws.test.js` on top of the phase-3 suite).
- **Force-pushed** `design/gateway-package-phase-4`. **New head SHA: `82bc60ba12115e0d1563c0475086dc9e6a6ef5bf`.**
- **PR state:** base still `design/gateway-package-phase-3`, `mergeable: MERGEABLE` (conflicts resolved, not deferred). `mergeStateStatus: UNSTABLE` = pending/known-flaky CI (Node-24.x/better-sqlite3 infra bug), not a merge conflict.

**Follow-up:** the next child in the phase-2..12 restack cascade is a separate orchestrated job (do not restack beyond #392). It can cite phase-4's new head `82bc60ba12` as its parent.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr392-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1933054 cached reads)
- Output: 20681 tokens
- Cost: $2.1712659999999997
- Wall-clock: 323s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
