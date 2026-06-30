# Garden bulletin

_As of 2026-06-30T23:02:14Z_

## Latest

Two endo-but-for-bots threads closed out: a shepherd posted a status reply on [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284), closing that review loop, and the conductor on [endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) finished its phase and posted the next-phase hand-off. A new build picked up @endo/gateway Phase 1 (virtual-host content-tree resolution). Still in flight: the error-tracing push on [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (continuing toward acceptance criteria and answering kriskowal's question — note this one has only been parked ~1h), and review directives on [#284](https://github.com/endojs/endo-but-for-bots/pull/284) and [#343](https://github.com/endojs/endo-but-for-bots/pull/343) are still being worked. A garden-meta job is encoding the "an acknowledged comment earns a reply, not just a reactji" rule.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 17h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 40d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (5)
- [`ebfb-endo-gateway-phase-1-virtual-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-endo-gateway-phase-1-virtual-hosting.md) — Build — @endo/gateway Phase 1, Feature 2: virtual-host content-tree resolutio...
- [`ebfb-pr-58-continue-error-tracing-and-status`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr-58-continue-error-tracing-and-status.md) — PR #58 — continue error-tracing toward acceptance criteria + answer kriskowal...
- [`endojs-endo-but-for-bots-pr284-review-393eb60e`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr284-review-393eb60e.md) — Review directive on endojs/endo-but-for-bots PR #284
- [`endojs-endo-but-for-bots-pr343-review-c61577a1`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr343-review-c61577a1.md) — Review directive on endojs/endo-but-for-bots PR #343
- [`garden-encode-acknowledged-comment-needs-reply`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-encode-acknowledged-comment-needs-reply.md) — Encode: an acknowledged comment gets at least a reply comment, not just a rea...

### tada (708)
- [`ebfb-pr-343-conduct-and-post-next-phase`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-pr-343-conduct-and-post-next-phase.md) — Completion report — ebfb-pr-343-conduct-and-post-next-phase
- [`ebfb-pr-284-shepherd-status-reply`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-pr-284-shepherd-status-reply.md) — Comment posted. The loop is closed.
- [`garden-issue-9-mhofman-mainnet-repro-clarification`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-issue-9-mhofman-mainnet-repro-clarification.md) — Completion report
- [`agoric-sdk-fork-pr-7-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/agoric-sdk-fork-pr-7-shepherd.md) — Only ~3 minutes elapsed (now 22:45Z; job started 22:42:40, prior runtime ~19m...
- [`deadmail-issue-comment-4848329666`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4848329666.md) — Inbox empty. Status while the background run proceeds:
- … and 703 more

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
