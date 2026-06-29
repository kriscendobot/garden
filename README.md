# Garden bulletin

_As of 2026-06-29T19:23:35Z_

## Latest

Two new reliability jobs landed in flight, both hardening the gardener against `timeout`-killed handlers: one to classify an rc124 handler timeout as an external kill, and one to ensure `--kill-after` actually prevents a gardener wedge. A shepherd is driving CI to green on [kriscendobot/agoric-sdk#7](https://github.com/kriscendobot/agoric-sdk/pull/7). On the completed side, the scholar's preflight gained a broadcast-actionability filter (so it stops acting on non-actionable markers), a scholar library cycle closed, the garden#9 attention directive was handled, and the ymax0 XS stack-overflow investigation produced a symbolicated trace. The board is otherwise drained — nothing waiting in todo — and ten of 29 parked PRs still sit on kriskowal's review, the oldest being [endo#3137](https://github.com/endojs/endo/pull/3137) (`.ts` runtime modules) at 14 days and the long-tail design/test PRs [endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) and [endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) past 39 days.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 11h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 10h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
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
- [`improve-classify-handler-timeout-rc124-as-external-kill`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-classify-handler-timeout-rc124-as-external-kill.md) — In scripts/jobs/gardener.sh + scripts/jobs/common.sh: a handler killed by its...
- [`improve-timeout-kill-after-prevents-gardener-wedge`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-timeout-kill-after-prevents-gardener-wedge.md) — In scripts/jobs/gardener.sh:144 the handler runs under timeout --signal=TERM ...
- [`shepherd-kriscendobot-agoric-sdk-pr7`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/shepherd-kriscendobot-agoric-sdk-pr7.md) — Shepherd kriscendobot/agoric-sdk PR #7 — drive CI to green

### tada (577)
- [`investigate-ymax0-xs-overflow-symbolicated-stack-trace`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/investigate-ymax0-xs-overflow-symbolicated-stack-trace.md) — Completion report
- [`deadmail-issue-comment-4835251662`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4835251662.md) — Completion report — deadmail-issue-comment-4835251662
- [`kriskowal-garden-pr9-8e3123c4`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-8e3123c4.md) — Completion report — kriskowal-garden-pr9-8e3123c4 (attention directive, garde...
- [`improve-scholar-preflight-broadcast-actionability-filter`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-scholar-preflight-broadcast-actionability-filter.md) — Completion report
- [`scholar-library-cycle-20260629-163514`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260629-163514.md) — Completion report
- … and 572 more

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
