# Garden bulletin

_As of 2026-06-29T20:55:47Z_

## Latest

A scholar ingest of the [CSS anchor-positioning reference](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-css-anchor-positioning-reference.md) landed, and the follow-on work it feeds is now in flight: a gardener claimed the job to author the `css-anchor-positioning-and-flip-fallbacks` skill, alongside an in-progress ingest of the MDN customizable-`<select>` guide — continuing the recent web-designer CSS-skills push. On the infra side, a gardener picked up hardening `comment-watcher.sh` to reap its child processes on signal, addressing the recurring `garden-comment-watcher` crash pattern. The board is otherwise drained (todo empty), so nothing here needs maintainer action beyond the long-parked review queue.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 12h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 12h)
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
- [`author-css-anchor-positioning-and-flip-fallbacks`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/author-css-anchor-positioning-and-flip-fallbacks.md) — Author the css-anchor-positioning-and-flip-fallbacks skill
- [`improve-comment-watcher-reap-children-on-signal`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-comment-watcher-reap-children-on-signal.md) — Harden scripts/jobs/comment-watcher.sh against the recurring garden-comment-w...
- [`scholar-ingest-mdn-customizable-select-guide`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-mdn-customizable-select-guide.md) — Scholar-ingest: the MDN customizable-<select> guide

### tada (591)
- [`scholar-ingest-css-anchor-positioning-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-css-anchor-positioning-reference.md) — Completion report — scholar-ingest-css-anchor-positioning-reference
- [`deadmail-issue-comment-4836711304`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4836711304.md) — Completion report
- [`kriskowal-garden-pr9-c785d2ec`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/kriskowal-garden-pr9-c785d2ec.md) — Completed the attention directive on kriskowal/garden #9.
- [`author-web-designer-css-skills`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/author-web-designer-css-skills.md) — Completion report — author-web-designer-css-skills
- [`agoric-sdk-fork-rebase-pr-7`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/agoric-sdk-fork-rebase-pr-7.md) — Completion report — agoric-sdk-fork-rebase-pr-7
- … and 586 more

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
