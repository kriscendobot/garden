# Garden bulletin

_As of 2026-06-30T02:14:42Z_

## Latest

I'll write the bulletin's "## Latest" section narrative.

Most of the recent movement centers on [kriskowal/garden#9](https://github.com/kriskowal/garden/pull/9), the ymax0 v320 XS value-stack overflow work: a fresh attention directive (`kriskowal-garden-pr9-77668dda`) is now in flight, while several prior PR #9 jobs completed — an attention directive (`26cd5976`), a refresh directive, and the snapshot-skill landing (`469d82c6`). The real-chain-state reproduction is fully staged (build host ready, both bundle JSONs built, driver written), setting up the parked `verify-ymax0-hex-fix-inquisitor` plan to confirm the `hex.js` `flatMap`→loop fix and `stackCount` snapshot compatibility once a maintainer promotes it. A dead-lettered issue comment (`deadmail-issue-comment-4839243615`) was also claimed for intent recovery. The job board is otherwise drained (todo empty), so the maintainer's main lever is the plan queue: four plans await go-ahead, including the ymax0 verification and the more speculative XS-to-Rust port.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 17h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 17h)
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

### doin (2)
- [`deadmail-issue-comment-4839243615`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-issue-comment-4839243615.md) — Dead-lettered message — pick up its intent
- [`kriskowal-garden-pr9-77668dda`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriskowal-garden-pr9-77668dda.md) — attention directive on kriskowal/garden PR #9

### tada (615)
- [`deadmail-issue-comment-4839140138`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4839140138.md) — Completion report — deadmail-issue-comment-4839140138
- [`kriskowal-garden-pr9-26cd5976`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-26cd5976.md) — Completion report: attention directive on kriskowal/garden#9
- [`reproduce-ymax0-v320-real-chain-state-20260630`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/reproduce-ymax0-v320-real-chain-state-20260630.md) — Everything is staged: build host ready, both bundle JSONs built, driver writt...
- [`kriskowal-garden-pr9-refresh`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-refresh.md) — Completion report: refresh directive on kriskowal/garden #9
- [`kriskowal-garden-pr9-469d82c6`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-469d82c6.md) — Completion report — kriskowal-garden-pr9-469d82c6 (attention directive on kri...
- … and 610 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

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
