# Garden bulletin

_As of 2026-06-30T00:03:51Z_

## Latest

The board is nearly drained — zero jobs in `todo` and only three in flight. The one fresh transition is a reproduction job claimed for the **ymax0 v320** XS stack overflow: an agent is now reproducing the 70→71 overflow against real chain state and verifying the hex fix. Also still working: an attention directive on [kriskowal/garden#9](https://github.com/kriskowal/garden/pull/9) and a dead-lettered issue comment being picked back up. On the completed side, design work landed on [kriskowal/garden#16](https://github.com/kriskowal/garden/pull/16)'s branch with its summary comment posted, and the gardener bid/accept-market design wrapped. The parked queue is the place to look for maintainer attention — 29 PRs await review, with the registry-capability ([endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403)) and gateway-cluster design ([endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343)) now ~15h old.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 15h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 15h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 14d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 38d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 38d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 40d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (3)
- [`deadmail-issue-comment-4838594481`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-issue-comment-4838594481.md) — Dead-lettered message — pick up its intent
- [`kriskowal-garden-pr9-469d82c6`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriskowal-garden-pr9-469d82c6.md) — attention directive on kriskowal/garden PR #9
- [`reproduce-ymax0-v320-real-chain-state-20260630`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/reproduce-ymax0-v320-real-chain-state-20260630.md) — reproduce ymax0 v320 70->71 XS overflow on REAL chain state + verify the hex fix

### tada (609)
- [`deadmail-issue-comment-4838518722`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4838518722.md) — Completion report
- [`kriskowal-garden-pr15-33ace472`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr15-33ace472.md) — Design landed on PR #16's branch and the summary comment is posted. Done.
- [`design-gardener-bid-accept-market`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-gardener-bid-accept-market.md) — Completion report
- [`deadmail-issue-comment-4838225494`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4838225494.md) — Completion report
- [`kriskowal-garden-pr15-f2c1cd5f`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr15-f2c1cd5f.md) — Completion report
- … and 604 more

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
