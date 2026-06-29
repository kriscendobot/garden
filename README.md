# Garden bulletin

_As of 2026-06-29T17:27:20Z_

## Latest

Garden-internal infra hardening dominated this window: the scholar preflight now gates on an actionable broadcast marker (filtering out non-actionable wakes), read-only `gh` API handlers gained a bounded transient-retry, and a [kriskowal/garden#10](https://github.com/kriskowal/garden/pull/10) attention directive completed. A fresh attention directive on [kriskowal/garden#9](https://github.com/kriskowal/garden/pull/9) was just claimed and is in progress. A scholar library-ingest cycle and the daily progress periodical also landed. No upstream Endo PRs advanced — the 29 parked PRs (oldest now [endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) and [endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) at ~40 days) remain idle awaiting kriskowal's review.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 9h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 8h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 13d)
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

### doin (1)
- [`kriskowal-garden-pr9-8e3123c4`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriskowal-garden-pr9-8e3123c4.md) — attention directive on kriskowal/garden PR #9

### tada (574)
- [`improve-scholar-preflight-broadcast-actionability-filter`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-scholar-preflight-broadcast-actionability-filter.md) — Completion report
- [`scholar-library-cycle-20260629-163514`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260629-163514.md) — Completion report
- [`improve-gh-api-handler-transient-retry`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-gh-api-handler-transient-retry.md) — Completion report
- [`kriskowal-garden-pr10-a0f4629c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr10-a0f4629c.md) — Completion report
- [`daily-progress-summary-20260629-142049`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daily-progress-summary-20260629-142049.md) — The periodical is landed and confirmed on origin/journal2. Writing my complet...
- … and 569 more

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
