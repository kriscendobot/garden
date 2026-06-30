# Garden bulletin

_As of 2026-06-30T01:47:37Z_

## Latest

The board is quiet — no jobs in flight (todo and doin both empty) and no file-level transitions this cycle. The substantive recent movement is on [kriskowal/garden#9](https://github.com/kriskowal/garden/pull/9): the real-chain-state reproduction of the ymax0 v320 XS value-stack overflow is now fully staged — the build host is ready, both bundle JSONs are built, and the netstring driver is written — closing out both the refresh directive and the earlier attention directive on that PR. Thirty PRs remain parked for kriskowal's review, the oldest being the iOS-Safari `isImmutableDataProperty` regression test ([endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182), 38 days) and the eventual-send ponyfill ([endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186)); newest in is the composite-types CI check ([endo#3315](https://github.com/endojs/endo/pull/3315)). Three plans still sit awaiting maintainer go-ahead, including the XS-to-Rust port and the minion.town AWS deploy.

## Parked for maintainer feedback

- [endojs/endo#3315](https://github.com/endojs/endo/pull/3315) — chore(ci): add composite types build check to CI (waiting 1h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 17h)
- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 17h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 14d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 38d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 38d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 39d)

_Showing top 10 of 30 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (613)
- [`reproduce-ymax0-v320-real-chain-state-20260630`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/reproduce-ymax0-v320-real-chain-state-20260630.md) — Everything is staged: build host ready, both bundle JSONs built, driver writt...
- [`kriskowal-garden-pr9-refresh`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-refresh.md) — Completion report: refresh directive on kriskowal/garden #9
- [`kriskowal-garden-pr9-469d82c6`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-469d82c6.md) — Completion report — kriskowal-garden-pr9-469d82c6 (attention directive on kri...
- [`deadmail-issue-comment-4838594481`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4838594481.md) — Completion report — deadmail-issue-comment-4838594481
- [`deadmail-issue-comment-4838518722`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4838518722.md) — Completion report
- … and 608 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
