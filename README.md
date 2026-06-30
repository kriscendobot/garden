# Garden bulletin

_As of 2026-06-30T19:15:29Z_

## Latest

Quiet cycle, mostly housekeeping completions. A `dependabotany` recheck swept [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots) and its self-scheduling was tightened to a precise recheck cadence, the daily progress summary landed on `origin/journal2`, the build for a restrictive Uint8Array-view byte-array emulation finished (the passable-byte-arrays line tracked by [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503), still parked for review), and erights' maintainer authority was encoded into the garden.

The one thing worth a maintainer's eye: the `journal-worktree-keeper` watchdog flagged that the live journal worktree on **endolinbot2** has diverged from `origin/journal2` — 3 commits local-ahead, 5664 behind, 5 dirty paths — and was deliberately left untouched. It needs a by-hand reconcile (`git -C /home/kris/journal status`, inspect `origin/journal2..HEAD`, then rebase/push or discard) before that host's journal state can fast-forward again.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 14h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 14h)
- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260630T191519Z-122e1f` — from watchdog:journal-worktree-keeper, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260630T191519Z-122e1f.md)

> journal worktree /home/kris/journal has DIVERGED from origin/journal2 and was left UNTOUCHED (no reset/pull/stash): 3 local-ahead commit(s), 5664 behind, 5 dirty path(s). Reconcile by hand: 'git -C /home/kris/journal status', 'git -C /home/kris/journal log --oneline origin/journal2..HEAD', then rebase/push or discard the local commits. (host=endolinbot2)


## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (696)
- [`improve-dependabotany-self-schedule-precise-recheck`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-dependabotany-self-schedule-precise-recheck.md) — Completion report
- [`dependabotany-recheck-endo-but-for-bots-20260630-143503`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/dependabotany-recheck-endo-but-for-bots-20260630-143503.md) — Completion report
- [`daily-progress-summary-20260630-143503`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daily-progress-summary-20260630-143503.md) — The periodical is landed on origin/journal2 (442be7523), inbox empty, and thi...
- [`build-ebfb-bytearray-uint8array-view-restrictive`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-ebfb-bytearray-uint8array-view-restrictive.md) — Completion report
- [`garden-encode-erights-maintainer-authority`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-encode-erights-maintainer-authority.md) — Completion report
- … and 691 more

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
