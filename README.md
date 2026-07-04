# Garden bulletin

_As of 2026-07-04T03:21:39Z_

## Latest

The scheduler grew a DST-aware anchored cadence (`daily-at-00:00-America/Los_Angeles`) on main2 (85a1cd8e6), backed by a 13-assertion test and documented in the `schedule` skill; it stamps the midnight-Pacific anchor rather than the fire time so the daily summary stops drifting (it currently fires ~8pm Pacific). This needs a leader-host deploy, after which the live `daily-progress-summary` schedule should be flipped to the anchored cadence — order matters, since flipping before the deploy would make the old scheduler treat the token as its weekly default. The gardener also backfilled the missing `2026/07/02` periodical. In flight: the xs2rust-endor port continues (stage-3b fundamentals follow-up, plus a metering-doctrine revision toward accuracy-over-parity), and several self-heal jobs repaired dangling comment-watcher and repo-watcher worktrees. One thing to confirm: the 07-02 periodical flagged that this host (endolinbot2) ran with a drifted identity for that whole window — worth verifying it now reads correctly.

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

- `20260704T032133Z-329166` — from gardener:daily-progress-summary-20260704-030501, reply_to `daily-progress-summary-20260704-030501` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260704T032133Z-329166.md)

> Daily-progress-summary periodical: v1→v2 translation landed, one coordinated
> follow-up needs your deploy.
>
> DONE now:
> - Wrote the missing periodical journal/periodicals/2026/07/02.md (pushed to
>   journal2). The series was current through 07-01; 07-02 (Pacific) was the next
>   one due.
> - main2 85a1cd8e6: scheduler.sh grew a DST-aware anchored cadence
>   `daily-at-00:00-America/Los_Angeles` (stamps the anchor, not the fire time, so
>   the daily midnight-Pacific anchor never drifts even on a late tick or across DST;
>   injects the prior-24h window + Pacific-date output path into the dispatched job
>   body). Added scheduler-anchored-cadence-test.sh (13 assertions, green), gave the
>   v2 journalist role its dropped `daily-progress-summary` purpose, and documented
>   the anchored cadence in skills/schedule.
> - journal2 schedule body rewritten from a description into an explicit journalist
>   dispatch instruction.
>
> FOLLOW-UP (needs a deploy, so I left it for you):
> - The live schedule is still cadence `daily`. It KEEPS firing daily correctly under
>   the current scheduler. After main2 85a1cd8e6 deploys to the leader host, flip
>   schedules/daily-progress-summary.md cadence to `daily-at-00:00-America/Los_Angeles`
>   so it anchors to midnight Pacific instead of drifting (right now the seed fires at
>   ~03:05Z = 8pm Pacific, not midnight). Flipping BEFORE deploy would make the
>   pre-deploy scheduler treat the unknown token as its weekly default, so the order
>   matters: deploy first, then flip.
>
> One thing to notice from the 07-02 periodical: the investigate-poisoned-garden-infra
> result flagged that this host's (endolinbot2) identity was drifted for the whole
> window. Worth confirming it is now correct.


## Board
### todo (0)
(none)

### doin (3)
- [`daily-progress-summary-20260704-030501`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/daily-progress-summary-20260704-030501.md) — Daily midnight Pacific progress summary
- [`xs2rust-endor-build-stage3b-fundamentals-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3b-fundamentals-followup.md) — Builder: stage-3b child 4/9 — fundamentals follow-up (bind/apply-with-array/....
- [`xs2rust-endor-metering-doctrine-accuracy-over-parity`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-metering-doctrine-accuracy-over-parity.md) — xs2rust-endor: revise the metering doctrine to accuracy-over-parity

### tada (1118)
- [`deadmail-issue-comment-4880090927`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-issue-comment-4880090927.md) — Completion report
- [`xs2rust-endor-press-20260704-030501`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260704-030501.md) — Completion report — xs2rust-endor-press-20260704-030501
- [`self-heal-fix-garden-comment-watcher-kriskowal-garden-journal-remote-dangling-worktree`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-comment-watcher-kriskowal-garden-journal-remote-dangling-worktree.md) — Completion report
- [`deadmail-20260703T202026Z-8bcdb1`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260703T202026Z-8bcdb1.md) — Completion report — deadmail-20260703T202026Z-8bcdb1
- [`self-heal-fix-garden-repo-watcher-journal-remote-root-origin-fallback`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-repo-watcher-journal-remote-root-origin-fallback.md) — Work complete. Here is my report.
- … and 1113 more

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
