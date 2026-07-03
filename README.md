# Garden bulletin

_As of 2026-07-03T11:13:10Z_

## Latest

A single completion landed since the last bulletin: the [gardener-scaler journal-worktree gitdir repair](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair.md) finished, the first of a self-heal cluster now working through the fallout of the garden root moving from `/home/kris/garden2` to `/home/kris`, which orphaned the standing journal worktrees. Eight sibling repairs remain in flight — hardening `common.sh`'s `journal_remote()` and the worktree-keeper against dangling and stale gitdir pointers across the comment-watcher, deadmail, follow-up, gardener, issue-inbox, mirror-closer, and orchestrate services — so a maintainer should expect the crash-looping journal-worktree services to quiet as those land. Feature work is otherwise steady: the xs2rust-endor Rust port is mid-build on stage 3 (arrays and the iteration protocol), and the todo queue is empty with 27 PRs still parked for kriskowal's review.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 20h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 7d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 42d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 42d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 44d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 43d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 43d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (8)
- [`self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-journal-worktree-dangling-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-journal-worktree-dangling-gitdir.md) — Repair the dangling $GARDEN_ROOT/journal worktree pointer that crash-loops ev...
- [`self-heal-fix-garden-deadmail-journal-worktree-dangling-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-deadmail-journal-worktree-dangling-gitdir.md) — The garden root moved from /home/kris/garden2 to /home/kris, orphaning the sh...
- [`self-heal-fix-garden-follow-up-journal-remote-dangling-gitdir-fallback`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-follow-up-journal-remote-dangling-gitdir-fallback.md) — Harden scripts/jobs/common.sh:journal_remote() so a dangling/unreadable $GARD...
- [`self-heal-fix-garden-gardener-journal-worktree-dangling-gitdir-repair`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-gardener-journal-worktree-dangling-gitdir-repair.md) — Harden the journal-worktree access path in scripts/jobs/common.sh so a dangli...
- [`self-heal-fix-garden-issue-inbox-journal-worktree-dangling-gitdir-repair`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-issue-inbox-journal-worktree-dangling-gitdir-repair.md) — In scripts/jobs/journal-worktree-keeper.sh, upgrade the keep_journal_worktree...
- [`self-heal-fix-garden-mirror-closer-stale-journal-worktree-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-mirror-closer-stale-journal-worktree-gitdir.md) — Harden the standing-journal-worktree self-heal against a **stale worktree git...
- [`self-heal-fix-garden-orchestrate-journal-worktree-stale-gitdir-repair`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-orchestrate-journal-worktree-stale-gitdir-repair.md) — Harden scripts/jobs/journal-worktree-keeper.sh to detect and repair a stale/d...
- [`xs2rust-endor-build-stage3-arrays`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3-arrays.md) — Builder: xs2rust-endor stage 3 (3/7) — arrays and the iteration protocol (PR ...

### tada (1056)
- [`self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair.md) — Completion report
- [`xs2rust-endor-press-20260703-105001`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260703-105001.md) — Press check-in report (tick 10:50Z)
- [`deadmail-20260703T085843Z-03844c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260703T085843Z-03844c.md) — Completion report
- [`improve-ci-watcher-transient-net-source-skip`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-ci-watcher-transient-net-source-skip.md) — Completion report
- [`improve-set-schedule-validate-preflight-exists`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-set-schedule-validate-preflight-exists.md) — Report
- … and 1051 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`xs2rust-endor-metering-doctrine-accuracy-over-parity`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-metering-doctrine-accuracy-over-parity.md) — _normal_ · xs2rust-endor: revise the metering doctrine to accuracy-over-parity
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...

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
