# Garden bulletin

_As of 2026-07-03T04:05:47Z_

## Latest

A review pass on [endo-but-for-bots#472](https://github.com/endojs/endo-but-for-bots/pull/472) (freezable-TypedArray design doc) completed and surfaced a genuine design call for kriskowal: gibson042 rebutted all three of the doc's "Why not a Proxy wrapper?" arguments and wants @kriskowal and/or @erights to decide between the plain-object wrapper and a Proxy `set` trap that throws on canonical-numeric-index writes — see the unread maintainer message and the PR thread. A companion build exploring the Proxy-based alternative emulation for the same PR is now in flight, so a decision here unblocks or retires that work. Separately, the XS→Rust (Endor) port picked up momentum: a new job to press [endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600) toward Endor integration and a green daemon is now running alongside its stage-3 language-closure build.

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

- `20260702T223440Z-5b9cb3` — from gardener:endojs-endo-but-for-bots-pr472-review-72d18f86, reply_to `endojs-endo-but-for-bots-pr472-review-72d18f86` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T223440Z-5b9cb3.md)

> DESIGN DECISION NEEDED — endojs/endo-but-for-bots PR #472 (freezable-TypedArray design doc)
>
> @gibson042 submitted review 4621538762 (one inline comment, id 3516427461) on
> packages/immutable-arraybuffer/designs/freezable-typedarray.md, and closed it with:
> "I'd like @kriskowal and/or @erights to weigh in here as well."
>
> This is a genuine design tradeoff that needs your call — a bot should not decide it.
> No code/doc change was made; nothing was pushed. The PR thread already has gibson's
> comment and @-mentions you both, so you can reply there directly.
>
> CONTEXT: The doc's section "Why not a Proxy wrapper?" gives three reasons for keeping
> the emulated view a plain ordinary object (so integer-indexed assignment silently
> creates a wrapper-local own property rather than throwing). gibson042 rebuts all three
> and argues for a Proxy `set` trap that rejects canonical-numeric-index writes:
>
> 1. Freezability risk (Object.freeze on a Proxy runs traps under proxy invariants).
>    gibson: "I do not believe this is a practical risk; we know exactly how to write
>    such a proxy (basically pass-through except for property keys that are canonical
>    numeric indices)."
> 2. Cost (Proxy taxes the integer-indexed hot path).
>    gibson: only bites where the shim is needed (no native immutable ArrayBuffer) AND
>    only on paths that do many direct indexed reads instead of using @endo/bytes
>    helpers (bytesFromImmutable/bytesEqual) — which we're actively avoiding anyway. He
>    prefers defaulting to correctness and providing mitigations for perf degradation.
> 3. "Throwing write is a nicety, not a safety property."
>    gibson: it's more than a nicety — not throwing risks silently masking real bugs
>    (our code runs strict mode; nothing verifies a non-exceptional property set had its
>    ostensible effect).
>
> Decision options: (a) keep the plain-object wrapper as designed; (b) switch the
> emulated view to a Proxy that throws on canonical-index writes; (c) something in
> between. Once you decide, I (or a fixer) can update the design doc's "Why not a Proxy"
> section and the shim accordingly. Reply here or on the PR thread.


## Board
### todo (0)
(none)

### doin (4)
- [`endojs-endo-but-for-bots-472-proxy-typedarray-emulation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-472-proxy-typedarray-emulation.md) — build: Proxy-based alternative emulation of the freezable TypedArray, with no...
- [`endojs-endo-but-for-bots-pr472-review-662e3148`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr472-review-662e3148.md) — Review directive on endojs/endo-but-for-bots PR #472
- [`xs2rust-endor-build-stage3-language`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3-language.md) — Builder: xs2rust-endor stage 3 (1/7) — language closure: strings as values + ...
- [`xs2rust-endor-press-20260703-040501`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260703-040501.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (1002)
- [`endojs-endo-but-for-bots-pr472-review-350a0c39`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr472-review-350a0c39.md) — Completion report
- [`foreman-active-job-target`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/foreman-active-job-target.md) — Completion report
- [`reconcile-claude-md-with-v2-tree`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/reconcile-claude-md-with-v2-tree.md) — Completion report
- [`port-xs-to-rust-memory-safe-engine-s5`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/port-xs-to-rust-memory-safe-engine-s5.md) — Completion report — port-xs-to-rust-memory-safe-engine-s5
- [`endojs-endo-but-for-bots-pr101-shepherd-llm-resume`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr101-shepherd-llm-resume.md) — All 24 checks pass — both lint jobs, cover, zizmor, the full test matrix — on...
- … and 997 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
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
