# Garden bulletin

_As of 2026-06-30T03:39:36Z_

## Latest

Work this cycle concentrated almost entirely on [endo-but-for-bots#548](https://github.com/endojs/endo-but-for-bots/pull/548): several review directives completed (reviews 0ce05d3a, 3acbe409, 77a2abe1 and two earlier passes), and a finalize-and-merge ("conduct") job is now in flight to curate and land it — so #548 is the PR to watch for an imminent merge. Two garden-infra fixes also entered progress: deduping the duplicate jobs the comment-watcher mints for inline-bearing reviews, and stopping a single long mid-job gardener from aborting a `deploy-garden`. Nothing new is parked for review; the maintainer queue still holds 29 PRs, the oldest of note being [endo#3137](https://github.com/endojs/endo/pull/3137) (TS runtime modules, 14d) and [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays, 4d).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 19h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 18h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 14d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 39d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 40d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (7)
- [`endojs-endo-but-for-bots-pr548-27e1734a`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr548-27e1734a.md) — attention directive on endojs/endo-but-for-bots PR #548
- [`endojs-endo-but-for-bots-pr548-conduct`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr548-conduct.md) — Finalize (curate → merge) endojs/endo-but-for-bots PR #548
- [`endojs-endo-but-for-bots-pr548-review-442a7f55`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr548-review-442a7f55.md) — Review directive on endojs/endo-but-for-bots PR #548
- [`endojs-endo-but-for-bots-pr548-review-5345a514`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr548-review-5345a514.md) — Review directive on endojs/endo-but-for-bots PR #548
- [`garden-comment-watcher-dedup-inline-review-comment-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-comment-watcher-dedup-inline-review-comment-jobs.md) — Garden infra: comment-watcher mints duplicate jobs for inline-bearing reviews
- [`garden-deploy-defer-long-mid-job-gardener`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-deploy-defer-long-mid-job-gardener.md) — deploy-garden: stop a single long mid-job gardener from aborting (and fleet-p...
- [`scholar-ingest-langchain-langgraph-remainder-3`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-langchain-langgraph-remainder-3.md) — Scholar: finish the LangChain + LangGraph library ingest (remainder 3)

### tada (628)
- [`endojs-endo-but-for-bots-pr548-review-77a2abe1`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr548-review-77a2abe1.md) — Completion report — endojs-endo-but-for-bots-pr548-review-77a2abe1
- [`endojs-endo-but-for-bots-pr548-review-3acbe409`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr548-review-3acbe409.md) — Completion report: PR #548 review (review 4597007634, comment on line 144)
- [`endojs-endo-but-for-bots-pr548-review-0ce05d3a`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr548-review-0ce05d3a.md) — Completion report
- [`endojs-endo-but-for-bots-pr548-de62d521`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr548-de62d521.md) — Completion report
- [`endojs-endo-but-for-bots-pr548-7d53248c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr548-7d53248c.md) — Completion report
- … and 623 more

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
