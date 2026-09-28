from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-19T00:35:16Z
doom_base: fix-worktree-sweeper-leader-only-misgating-20260919
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-19T00:35:16Z
last_seen: 2026-09-19T00:35:16Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-worktree-sweeper-leader-only-misgating-20260919; it stays HELD until a human promotes it
(promote-plan.sh fix-worktree-sweeper-leader-only-misgating-20260919) or removes it, so nothing is lost.
Original job base: fix-worktree-sweeper-leader-only-misgating-20260919

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
The terminal-worktree sweeper is MISGATED: it is leader-only, but the garbage it
collects is LOCAL to every host. On a follower it has never run, and the residue
accumulates without bound.

MAINTAINER REQUEST (kriskowal, 2026-09-19): "Check whether we already have
automation for collecting worktree garbage and whether it is working." It exists
and it is NOT working on followers. This job fixes that.

## Evidence (endolin-garden2-5bcdff64, a FOLLOWER, 2026-09-18/19)

- `scratch/project-wt-*` directories on disk: **100**, totaling **41 GB**.
- `garden-worktree-sweeper.timer` is enabled, active, and fires on schedule (last
  trigger 23:42:00Z, next 00:12:00Z) — so the timer is healthy.
- Every single run is skipped:
      garden-worktree-sweeper.service: Skipped due to 'exec-condition'.
- The gate is in the unit:
      ExecCondition=/bin/bash .../scripts/jobs/is-main-host.sh
  This host is a follower, so the condition fails every tick and
  `worktree-sweeper.sh` never executes here. `Result=exec-condition`,
  `ActiveState=inactive` — not a crash, a permanent no-op.

## Why leader-only is wrong for THIS unit

`worktree-sweeper.sh` is explicitly a LOCAL-filesystem safety net. Its own header:

  "The completion and doom paths remove project worktrees promptly. This timer
   covers interrupted cleanup, removes the trusted spine's garden-root worktrees,
   and collects legacy directories which are no longer registered in their bare
   repository. It intentionally has NO fleet-drain guard: inode exhaustion is a
   reason to run cleanup, not a reason to suspend it."

It has a `has_live_process()` helper that inspects LOCAL processes, and it reclaims
LOCAL directories. None of that is journal state, so there is nothing for a single
leader to do on behalf of the fleet — every host generates its own worktrees in its
own `scratch/`, and only that host can see or reclaim them.

Note the self-contradiction worth preserving in the fix: the script deliberately
refuses to be suspended by a fleet drain, reasoning that inode exhaustion argues FOR
running cleanup — while the leader-only gate suspends it entirely on every follower.
The author clearly intended this to be robust; the gating defeats that intent.

## Tasks

1. UNGATE IT from `is-main-host.sh` so it runs on EVERY host, like `garden-sysop`
   (the existing precedent for a deliberately un-leader-gated per-host daemon; see
   CLAUDE.md § the sysop). Verify nothing inside `worktree-sweeper.sh` assumes
   leader identity or singleton execution — if any step IS genuinely fleet-wide,
   split that step out rather than keeping the whole unit leader-only.
2. AUDIT THE PRIMARY PATH. The sweeper is a SAFETY NET; the header says "the
   completion and doom paths remove project worktrees promptly." 100 surviving
   worktrees on one host suggests the primary path is ALSO failing, not merely that
   the net is absent. Determine how many of the 100 correspond to jobs that reached
   `tada/` or were doomed, and therefore should already have been reclaimed. If the
   completion path is leaking, fix that too — an ungated safety net that silently
   compensates for a broken primary path is worse than either problem alone, because
   it hides the leak.
3. CHECK THE CAP. `GARDEN_WORKTREE_SWEEP_MAX` defaults to 100 and this host has
   exactly 100 worktrees. Confirm whether that is coincidence or whether the cap is
   interacting with the backlog; a per-tick cap that never drains a backlog larger
   than itself would be its own defect.
4. VERIFY THE OTHER KEEPERS are correctly gated while you are here:
   `garden-clone-keeper`, `garden-state-clone-keeper`, `garden-journal-worktree-keeper`.
   There is prior art for this exact failure class — per-id journal clones under
   `$GARDEN_STATE` were never pruned and wedged a host at zero free inodes TWICE.
   Report each one's gate and whether it is right; fix any that share this bug.
5. Regression test pinning that the sweeper runs on a non-leader host.

## Context

This surfaced during a CPU-saturation investigation (load 168 on 32 CPUs) where the
41 GB of residue was a secondary finding. Disk is not currently at risk (1.4T of
3.6T used, 41%), so this is not an emergency — but the inode-exhaustion precedent
above is why it should not wait for one. A separate design job,
`design-cpu-back-pressure-job-dispatch-20260918`, owns the load/memory/IO admission
gate; do not duplicate that work here.
