# Garden bulletin

_As of 2026-07-05T20:38:24Z_

## Latest

Recent work centered on endo-but-for-bots review activity: [endojs/endo-but-for-bots#595](https://github.com/endojs/endo-but-for-bots/pull/595) had a review unit fully addressed and a report-back completed, while a review directive on [endojs/endo-but-for-bots#592](https://github.com/endojs/endo-but-for-bots/pull/592) is in progress alongside a shepherd on [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288). Two decisions await the maintainer: the completed `design-streamlined-onboarding` design needs answers to its §5 open questions (especially Q2, the security-flavored auto-mode default) before its four build jobs can be posted as an orchestration, and the #595 probe published as [endojs/endo-but-for-bots#605](https://github.com/endojs/endo-but-for-bots/pull/605) came back with 7 gaps rather than the 5 paraphrased in the spec — with no `take`-semantics correctness hazard — so the liaison is asking whether a fresh probe on destructive one-shot `take` semantics is actually wanted. The Fable-driven garden-script review/fix pass and the xs2rust-endor stage-3b JSON-metering build continue.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 5d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 6d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 9d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 20d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 44d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 44d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 46d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 45d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 54d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260705T173845Z-99346f` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T173845Z-99346f.md)

> The design job `design-streamlined-onboarding` completed. The maintainer should review `designs/streamlined-onboarding.md` and answer its § 5 open questions — especially Q2, the auto-mode default, which is a security-flavored decision. The four § 6 build jobs are gated on that review and should be posted as an orchestration only after you answer.

- `20260705T203815Z-e614d3` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260705T203815Z-e614d3.md)

> On endojs/endo-but-for-bots PR #595 (probe published as PR #605, https://github.com/endojs/endo-but-for-bots/pull/605), the report-back surfaced a spec discrepancy: the job spec paraphrased 5 gaps including a "Gap 5 — destructive one-shot `take` semantics" correctness hazard, but the published probe actually has 7 gaps and no `take`-semantics gap. The gardener correctly did not invent the missing gap. Decision needed: do you specifically want a `take`-semantics analysis? If so, that is a genuinely new probe question rather than a report-back, and I can post it as a fresh probe job on your say-so.


## Board
### todo (0)
(none)

### doin (4)
- [`endojs-endo-but-for-bots-pr288-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr288-shepherd.md) — shepherd directive on endojs/endo-but-for-bots PR #288
- [`endojs-endo-but-for-bots-pr592-review-9e382ba1`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr592-review-9e382ba1.md) — Review directive on endojs/endo-but-for-bots PR #592
- [`fable-review-fix-garden-scripts`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/fable-review-fix-garden-scripts.md) — Fable: review the garden's scripts, serially fix discovered issues, push main2
- [`xs2rust-endor-build-stage3b-json-metering`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3b-json-metering.md) — Builder: stage-3b child 6/9 — JSON.parse + structured JSON.stringify metering...

### tada (1176)
- [`endojs-endo-but-for-bots-pr595-report-back`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr595-report-back.md) — Completion report
- [`endojs-endo-but-for-bots-pr595-review-b3285075`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr595-review-b3285075.md) — The review unit is fully addressed. Summary:
- [`deadmail-20260705T202239Z-177671`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260705T202239Z-177671.md) — Report
- [`deadmail-20260705T201849Z-c8ffed`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260705T201849Z-c8ffed.md) — Completion report
- [`endojs-endo-but-for-bots-pr592-review-2e32890c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr592-review-2e32890c.md) — Completion report
- … and 1171 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`endojs-endo-but-for-bots-pr288-review-330391eb-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr288-review-330391eb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #288 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr442-review-61c65980-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr442-review-61c65980-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #442 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr592-review-da7fef5e-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-review-da7fef5e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #592 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr595-review-0a6137f6-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr595-review-0a6137f6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #595 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr602-review-ec2efb27-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr602-review-ec2efb27-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #602 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-86120b5a-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-86120b5a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-review-51a40148-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-review-51a40148-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr604-review-f2d21a00-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr604-review-f2d21a00-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #604 (primary: endojs-endo-but-f...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...
- [`endojs-endo-but-for-bots-pr592-review-1050d7e9-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-review-1050d7e9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #592 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr592-review-2e32890c-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-review-2e32890c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #592 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr592-review-9e382ba1-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-review-9e382ba1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #592 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr595-review-b3285075-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr595-review-b3285075-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #595 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s7`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s7.md) — awaiting `xs2rust-endor-build-stage3b` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
