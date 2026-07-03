# Garden bulletin

_As of 2026-07-03T04:21:57Z_

## Latest

Little moved at the file level this cycle, but two things merit a glance. Chiefly, a duplicate-job collision on [endo-but-for-bots#472](https://github.com/endojs/endo-but-for-bots/pull/472): two live gardeners independently claimed the same Proxy-based freezable-TypedArray emulation + Node/XS parity task (one the broader spec with benchmark and rebuttal, one the maintainer-directive version), and neither has pushed a branch yet — the second gardener has messaged to stand down in favor of the first, so no action is needed unless you'd prefer to split or reassign the work. Separately, the no-comment-banner cleanup on #472 landed: the `ebfb472-nobanner-orch` orchestration, its `ebfb472-remove-banner` child, and the garden-wide `garden-loop-banner-sweep` all completed, and the #472 review-triage pass finished. The xs2rust-endor (Endor) port continues its steady press ticks on [endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600), now working stage 3 language-closure work.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 13h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 6d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 42d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 42d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 43d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 42d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 43d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260703T042147Z-26d862` — from gardener:ebfb-pr472-proxy-typedarray-emulation-builder, reply_to `ebfb-pr472-proxy-typedarray-emulation-builder` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260703T042147Z-26d862.md)

> Duplicate-job collision flag (no action needed unless you want to intervene):
>
> Two live gardeners hold the SAME task — a Proxy-based freezable-TypedArray emulation + Node/XS parity tests for endojs/endo-but-for-bots PR #472:
> - `endojs-endo-but-for-bots-472-proxy-typedarray-emulation` (gardener 12, claimed 04:04Z) — broader spec (adds benchmark + three-objections rebuttal)
> - `ebfb-pr472-proxy-typedarray-emulation-builder` (gardener 14, me, claimed 04:16Z) — the maintainer-directive version
>
> Neither has pushed a branch/PR. I've messaged the peer proposing they keep it and I stand down (they claimed first and have the superset spec). I'll defer to them to avoid two competing PRs. If you'd rather I take it, or split the work, let me know.


## Board
### todo (0)
(none)

### doin (5)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`ebfb-pr472-proxy-typedarray-emulation-builder`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr472-proxy-typedarray-emulation-builder.md) — builder: Proxy-based freezable-TypedArray emulation + cross-platform (Node/XS...
- [`endojs-endo-but-for-bots-472-proxy-typedarray-emulation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-472-proxy-typedarray-emulation.md) — build: Proxy-based alternative emulation of the freezable TypedArray, with no...
- [`endojs-endo-but-for-bots-pr600-26d26f39`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr600-26d26f39.md) — attention directive on endojs/endo-but-for-bots PR #600
- [`xs2rust-endor-build-stage3-language`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3-language.md) — Builder: xs2rust-endor stage 3 (1/7) — language closure: strings as values + ...

### tada (1007)
- [`ebfb472-nobanner-orch`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb472-nobanner-orch.md) — orchestration ebfb472-nobanner-orch — complete
- [`garden-loop-banner-sweep`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-loop-banner-sweep.md) — Completion report
- [`ebfb472-remove-banner`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb472-remove-banner.md) — Completion report
- [`endojs-endo-but-for-bots-pr472-review-662e3148`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr472-review-662e3148.md) — Completion report — review-triage job endojs-endo-but-for-bots-pr472-review-6...
- [`xs2rust-endor-press-20260703-040501`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260703-040501.md) — Press check-in report — xs2rust-endor (PR #600), tick 04:05Z
- … and 1002 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`endojs-endo-but-for-bots-pr588-shepherd-llm-resume`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr588-shepherd-llm-resume.md) — _low_ · shepherd on endojs/endo-but-for-bots PR #588 (PARKED from doin — churn/near-p...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s6`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s6.md) — awaiting `xs2rust-endor-build-stage3` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
