# Garden bulletin

_As of 2026-06-30T05:15:59Z_

## Latest

I'll write the bulletin's "## Latest" section based on the input.

Since the deterministic dashboard shows recent completions and the current board state, let me synthesize what a maintainer should notice.

The engine fix for kriskowal/garden#17 landed — the native-XS `flatMap` value-stack overflow that broke ymax0 v320 was reproduced and resolved with a per-iteration `mxPop()` in `fxDefineAll`'s flatten path, shipped to [kriscendobot/moddable#1](https://github.com/kriscendobot/moddable/pull/1) and A/B-verified to clear the overflow at stock `stackCount=4096`; a follow-on plan to verify the fix and snapshot-compatibility via inquisitor is parked for go-ahead. Two builder threads completed on endo-but-for-bots — [#429](https://github.com/endojs/endo-but-for-bots/pull/429) and [#430](https://github.com/endojs/endo-but-for-bots/pull/430) — and [#57](https://github.com/endojs/endo-but-for-bots/pull/57) was rebased, with a parked plan to restage it onto the updated [#475](https://github.com/endojs/endo-but-for-bots/pull/475). [#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP cross-worker error tracing) advanced through its builder and is now freshly parked for review alongside [#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays). Currently in flight: a redesign of the byteArray Uint8Array-view approach and an attention directive on [#475](https://github.com/endojs/endo-but-for-bots/pull/475). The board is otherwise drained — zero jobs in `todo` — with the notable parked plans (`port XS to Rust`, `deploy minion.town to AWS`, foreman cross-host token aggregation) all awaiting maintainer authorization.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 23m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 14m)
- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 21h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 20h)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
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

### doin (2)
- [`ebfb-bytearray-uint8array-view-redesign`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-bytearray-uint8array-view-redesign.md) — design: byteArray maps a frozen Uint8Array view, not a bare immutable ArrayBu...
- [`endojs-endo-but-for-bots-pr475-a8a47b48`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr475-a8a47b48.md) — attention directive on endojs/endo-but-for-bots PR #475

### tada (671)
- [`endojs-endo-but-for-bots-pr429-248d107b`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr429-248d107b.md) — Completion report — endojs-endo-but-for-bots-pr429-248d107b
- [`endojs-endo-but-for-bots-pr57-rebase`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr57-rebase.md) — Completion report — endojs-endo-but-for-bots-pr57-rebase
- [`endojs-endo-but-for-bots-pr58-8585f202`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr58-8585f202.md) — I've launched the implementation. Current status: builder running in the back...
- [`issue-kriskowal-garden-17`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-kriskowal-garden-17.md) — Completion report — issue-kriskowal-garden-17
- [`endojs-endo-but-for-bots-pr430-b7b6a63e`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr430-b7b6a63e.md) — Completion report
- … and 666 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-ebfb-pr57-onto-475-restage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-ebfb-pr57-onto-475-restage.md) — _normal_ · restage endo-but-for-bots #57 onto the updated #475
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
