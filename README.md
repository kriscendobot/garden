# Garden bulletin

_As of 2026-06-28T18:19:07Z_

## Latest

Two jsdoc-lint ratchets are in flight on endo master — promoting `jsdoc/check-tag-names` and `jsdoc/require-param` from warning to error and fixing the handful of defects each surfaces (1 and 4 respectively). Otherwise the board is quiet: the only fresh motion is a gardener recovering a pair of dead-lettered messages back into active work. Nothing new is parked for review, but the maintainer queue still holds 28 PRs awaiting kriskowal, with [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing) the longest-waiting at the top of the roadmap-ranked set.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 11h)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 2d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 13d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 38d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 37d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 37d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 38d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 38d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (4)
- [`deadmail-20260628T180747Z-b1b988`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-20260628T180747Z-b1b988.md) — Dead-lettered message — pick up its intent
- [`deadmail-20260628T181513Z-7ea6f9`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-20260628T181513Z-7ea6f9.md) — Dead-lettered message — pick up its intent
- [`ratchet-jsdoc-check-tag-names-error-endo`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ratchet-jsdoc-check-tag-names-error-endo.md) — ratchet jsdoc/check-tag-names warning → error on endo master (+ fix the 1 def...
- [`ratchet-jsdoc-require-param-error-endo`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ratchet-jsdoc-require-param-error-endo.md) — ratchet jsdoc/require-param warning → error on endo master (+ fix the 4 defects)

### tada (548)
- [`deadmail-20260628T180657Z-baff19`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T180657Z-baff19.md) — Completion report — deadmail-20260628T180657Z-baff19 (intent of classify-lint...
- [`scholar-ingest-erights-10`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-erights-10.md) — Completion report
- [`fu-scholar-ingest-erights-9-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/fu-scholar-ingest-erights-9-2.md) — Completion report
- [`improve-regenerate-topics-counts`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-regenerate-topics-counts.md) — Completion report
- [`issue-inbox-watcher-reactji-acknowledge`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-inbox-watcher-reactji-acknowledge.md) — Completion report
- … and 543 more

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
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
