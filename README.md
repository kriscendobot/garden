# Garden bulletin

_As of 2026-07-04T03:06:01Z_

## Latest

The XS→Rust (Endor) port dominated the cycle: stage-3b builder children for binary data and BigInt both landed, the fundamentals follow-up (bind/apply-with-array) is now in progress, and a fresh press tick is driving [endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600) toward Endor integration and green daemon tests. A companion job also revises the port's metering doctrine toward accuracy-over-parity. Separately, a burst of infrastructure self-heal work is underway: five jobs are hardening the garden's own tooling against a dangling/stale `$GARDEN_ROOT/journal` worktree link that was tripping the comment-watcher, gardener-scaler, orchestrate, and repo-watcher services. Nothing new parked for maintainer review this cycle — the review queue is unchanged, still led by the voice-input chat PR ([endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101)) and the passable byte-arrays PR ([endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503)).

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

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (9)
- [`daily-progress-summary-20260704-030501`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/daily-progress-summary-20260704-030501.md) — Daily midnight Pacific progress summary
- [`deadmail-20260703T202026Z-8bcdb1`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-20260703T202026Z-8bcdb1.md) — Dead-lettered message — pick up its intent
- [`self-heal-fix-garden-comment-watcher-kriskowal-garden-journal-remote-dangling-worktree`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-comment-watcher-kriskowal-garden-journal-remote-dangling-worktree.md) — Two-part hardening for the dangling $GARDEN_ROOT/journal worktree that makes ...
- [`self-heal-fix-garden-gardener-scaler-journal-worktree-link-repair`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-gardener-scaler-journal-worktree-link-repair.md) — Add a lossless self-heal for a BROKEN journal-worktree link to scripts/jobs/j...
- [`self-heal-fix-garden-orchestrate-stale-journal-worktree-link`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-orchestrate-stale-journal-worktree-link.md) — Root cause: the standing $GARDEN_ROOT/journal worktree has stale two-way git ...
- [`self-heal-fix-garden-repo-watcher-journal-remote-root-origin-fallback`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-repo-watcher-journal-remote-root-origin-fallback.md) — Harden journal_remote() in scripts/jobs/common.sh (lines 490-494) so a dangli...
- [`xs2rust-endor-build-stage3b-fundamentals-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3b-fundamentals-followup.md) — Builder: stage-3b child 4/9 — fundamentals follow-up (bind/apply-with-array/....
- [`xs2rust-endor-metering-doctrine-accuracy-over-parity`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-metering-doctrine-accuracy-over-parity.md) — xs2rust-endor: revise the metering doctrine to accuracy-over-parity
- [`xs2rust-endor-press-20260704-030501`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260704-030501.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (1111)
- [`xs2rust-endor-build-stage3b-binary`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3b-binary.md) — Completion report — xs2rust-endor-build-stage3b-binary (stage-3b binary data,...
- [`foreman-edge-trigger-on-job-completion`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/foreman-edge-trigger-on-job-completion.md) — Completion report
- [`xs2rust-endor-press-20260703-175002`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260703-175002.md) — Press tick complete — this was an observe-and-defer cycle under the charter's...
- [`deadmail-20260703T174129Z-e748a9`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260703T174129Z-e748a9.md) — Completion report
- [`xs2rust-endor-build-stage3b-bigint`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3b-bigint.md) — Completion report — stage-3b child 2/9: BigInt (PR #600)
- … and 1106 more

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
