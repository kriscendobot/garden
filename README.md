# Garden bulletin

_As of 2026-07-04T04:04:19Z_

## Latest

The XS→Rust (Endor) port advanced its only moving piece this cycle: the [stage-3b fundamentals follow-up](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3b-fundamentals-followup.md) completed, and the press tick reports the chain healthy and active. The board is otherwise quiet — no open, claimed, or blocked-through transitions.

The item that wants your attention is a **ruling escalation** sitting in the maintainer inbox, surfaced from a dead-lettered orchestrator message on the XS→Rust port. Design change 433797861 ("metering doctrine: accuracy over parity") demoted computron-vs-C-XS from a gate to advisory telemetry, but the test262 runner's `DualRun::is_bit_exact` still gates on computrons — so the doctrine and the enforced gate disagree. No garden code changed; this is a coordination carry-forward awaiting your call on whether `is_bit_exact` should be updated to match the new doctrine (unlocking option-b across the fleet, including the stalled bind bound-fn allocation cluster) or whether the port stays computron-exact-or-honest-skip and the design doc is treated as forward-looking only.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 7d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 18d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 43d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 43d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 44d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 43d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 44d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260704T033624Z-f6deea` — from gardener:deadmail-20260704T032953Z-2c9dd2, reply_to `deadmail-20260704T032953Z-2c9dd2` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T033624Z-f6deea.md)

> Ruling escalation (surfaced via a dead-lettered orchestrator message on the XS→Rust port, PR #600).
>
> A stage-3b child asked its now-completed orchestrator to rule on a doctrine conflict, and I picked
> up the dead-letter. I answered the child operationally (keep computron-exact-or-honest-skip), but
> the underlying mismatch is a maintainer call:
>
>   The design change 433797861 ("metering doctrine: accuracy over parity") demoted
>   computron-vs-C-XS from a gate to ADVISORY telemetry — result-correctness becomes the gate.
>   BUT the test262 runner still enforces the old rule: DualRun::is_bit_exact gates computrons.
>   So the doctrine and the actual gate disagree.
>
> Until is_bit_exact is updated to stop gating computrons, no child can ship the doctrine's
> "result-correct + advisory-divergent computrons" path without every such test reading as
> divergent (breaking the divergent=0 charter). Decision needed: do you want the runner's
> is_bit_exact changed to match the new doctrine (unlocking option-b across the fleet, incl. the
> bind bound-fn allocation cluster that's been the metering-calibration wall), or should the port
> stay computron-exact-or-honest-skip and the design doc be treated as forward-looking only?
>
> No garden code changed for this job — it was a coordination/ruling carry-forward.


## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (1126)
- [`xs2rust-endor-build-stage3b-fundamentals-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3b-fundamentals-followup.md) — Completion report
- [`improve-scheduler-surface-missing-preflight`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-scheduler-surface-missing-preflight.md) — I've verified the full picture. This job's requested feature is **already imp...
- [`xs2rust-endor-press-20260704-033505`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260704-033505.md) — Observe-and-defer tick complete: the xs2rust-endor chain is healthy and activ...
- [`deadmail-20260704T032953Z-2c9dd2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260704T032953Z-2c9dd2.md) — Completion report
- [`improve-journal-worktree-keeper-repair-missing-origin`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-journal-worktree-keeper-repair-missing-origin.md) — Completion report
- … and 1121 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...

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
