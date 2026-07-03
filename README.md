# Garden bulletin

_As of 2026-07-03T16:28:14Z_

## Latest

The garden spent this interval self-healing its own plumbing: the last of a fleet-wide sweep to repair dangling journal-worktree gitdir links landed, with the `garden-issue-inbox-keeper` fix completing and joining already-finished siblings that hardened the foreman, proxy, repo-watcher, and comment-watcher against the same stale-gitdir failure. Three jobs remain in flight — another self-heal to make `journal-worktree-keeper.sh` rebuild a broken journal worktree outright, the Fable-supervised XS→Rust (Endor) port pressing toward maintainer review, and an attention directive on [endojs/endo-but-for-bots#602](https://github.com/endojs/endo-but-for-bots/pull/602). Nothing new was posted to the board. Worth a maintainer's eye: the review queue is backing up, with the oldest parked PRs — [endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) and [endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — now waiting 42 days, and [endo#3137](https://github.com/endojs/endo/pull/3137) (`.ts` runtime modules via erasable type syntax) at 17.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 1d)
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

### doin (4)
- [`endojs-endo-but-for-bots-pr602-7430cb28`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr602-7430cb28.md) — attention directive on endojs/endo-but-for-bots PR #602
- [`port-xs-to-rust-memory-safe-engine-s6`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/port-xs-to-rust-memory-safe-engine-s6.md) — Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`self-heal-fix-garden-orchestrate-journal-worktree-stale-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/self-heal-fix-garden-orchestrate-journal-worktree-stale-gitdir.md) — Harden scripts/jobs/journal-worktree-keeper.sh to REBUILD a broken/missing jo...
- [`xs2rust-endor-press-20260703-152012`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260703-152012.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (1091)
- [`self-heal-fix-garden-issue-inbox-keeper-repair-dangling-journal-worktree-link`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-issue-inbox-keeper-repair-dangling-journal-worktree-link.md) — Completion report
- [`self-heal-fix-garden-repo-watcher-dangling-journal-worktree-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-repo-watcher-dangling-journal-worktree-gitdir.md) — Everything the job asks for is already in place. Here's my report.
- [`self-heal-fix-garden-foreman-journal-worktree-dangling-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-foreman-journal-worktree-dangling-gitdir.md) — Completion report
- [`self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-dangling-journal-worktree`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-dangling-journal-worktree.md) — Completion report
- [`self-heal-fix-garden-proxy-journal-remote-fallback-to-garden-origin`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-proxy-journal-remote-fallback-to-garden-origin.md) — Completion report
- … and 1086 more

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
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
