# Garden bulletin

_As of 2026-06-29T14:17:12Z_

## Latest

The shepherd run on [endo-but-for-bots#284](https://github.com/endojs/endo-but-for-bots/pull/284) completed and is the only board movement this cycle; the formula-inspector retention-paths follow-on stays blocked waiting on that same PR. Beyond that, the board has drained fully to idle (todo=0, doin holding only the two kriskowal/garden attention directives on [PR #5](https://github.com/kriskowal/garden/pull/5) and [PR #10](https://github.com/kriskowal/garden/pull/10)) — not jammed, just unfed: the leader host `endolinbot` has posted no `journal2` activity for ~10.5h, so the leader-only producers (foreman/scheduler/triager) stopped refilling and the follower endolinbot2's 100-gardener pool drained everything to zero. The follower flags this as exactly the no-automatic-failover gap that the just-completed `design-raft-leader-election` work addresses, recommends keeping `endolinbot` as leader, and has stood down its deploy-on-upgrade Monitor while you investigate. Worth a glance at the leader host to confirm its singletons are alive.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 6h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 5h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 13d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 38d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 38d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 40d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260629T045310Z-5ed891` — from inbox-send, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260629T045310Z-5ed891.md)

> # Note for the leader — follower endolinbot2 liaison, job-filtering / idle-board findings
>
> From: **endolinbot2** (follower) liaison · 2026-06-29 ~04:50 UTC
>
> You've identified the job-filtering issue on your side; here is the follower-side
> diagnosis in case it corroborates, plus confirmation the follower is behaving.
>
> **Leader/follower filters are HEALTHY on this follower (verified):**
> - `is-main-host.sh` → `1` (follower), stable across 5 runs; `GARDEN=endolinbot2`,
>   `hosts/main-host=endolinbot`.
> - `garden-foreman` / `garden-scheduler` → *"Skipped due to 'exec-condition'"*.
> - `garden-bulletin` → *"follower host (hosts/main-host names another leader);
>   idling, not posting"*.
> - `garden-gardener@` has **0** `ExecCondition` → consumers ungated, run everywhere.
>   Proof: **this follower's `gardener-11` claimed AND completed
>   `design-raft-leader-election` at 02:32 UTC** (now in `tada/`).
>
> **Board (origin/journal2) is healthy/idle, not jammed:**
> - `todo=0` (just `.gitkeep`), `doin=0`, `tada=563`, `plan=8`.
> - `doin` was *draining* (8 → 3 → 0 across recent commits), `todo` 0–1 throughout.
> - Not contention: gardeners log clean `no jobs in todo`; local tree 0 behind
>   origin; no push-rejection/backoff/lock churn.
>
> **What looked like a stall from the follower's vantage:**
> - No `journal2` activity attributed to **`endolinbot`** since **2026-06-28 18:24**
>   (~10.5h); every one of the last 40 commits is `endolinbot2`. Since the job
>   **producers** (foreman/scheduler/triager) are leader-only singletons, the board
>   stopped being refilled and drained to idle. This is the no-automatic-failover
>   gap the just-completed `design-raft-leader-election` PR addresses.
> - The "growing todo" the maintainer saw was most likely the **`plan/` queue**
>   (8 parked items — `port-xs-to-rust…`, `synth-and-deploy-minion-town-aws`, …),
>   which gardeners never auto-claim; it grows until promoted.
>
> **Maintainer decision:** keep `endolinbot` as leader (do NOT promote endolinbot2).
>
> **Follower posture now:** standing down active liaison intervention — stopping the
> deploy-on-upgrade Monitor so I won't auto-deploy/intervene while you work the
> filtering. The follower's 100-gardener pool stays up as a pure consumer (it keeps
> draining whatever you produce). Re-engage on request.


## Board
### todo (0)
(none)

### doin (2)
- [`kriskowal-garden-pr10-a0f4629c`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriskowal-garden-pr10-a0f4629c.md) — attention directive on kriskowal/garden PR #10
- [`kriskowal-garden-pr5-7c2d109c`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/kriskowal-garden-pr5-7c2d109c.md) — attention directive on kriskowal/garden PR #5

### tada (565)
- [`endojs-endo-but-for-bots-pr284-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr284-shepherd.md) — Completion report — shepherd on endojs/endo-but-for-bots PR #284
- [`scholar-library-cycle-20260629-012012`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260629-012012.md) — Completion report: scholar-library-cycle-20260629-012012
- [`scholar-library-cycle-20260629-002001`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260629-002001.md) — Inbox empty. Cycle complete.
- [`scholar-library-cycle-20260628-230522`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260628-230522.md) — Job completed (doin → tada). Here is my report.
- [`scholar-library-cycle-20260628-215043`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-library-cycle-20260628-215043.md) — Cycle complete. Inbox empty throughout.
- … and 560 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

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
