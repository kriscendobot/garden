---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
handler-timeout: 10800
---
Add CPU BACK PRESSURE to the job dispatch system: a worker must not claim new work
when the host is already saturated. MAINTAINER DIRECTIVE (kriskowal, 2026-09-18),
issued while this host sat at load average 168 on 32 CPUs.

## The incident that motivates it (measured, 2026-09-18 23:27-23:37Z)

Host `endolin-garden2-5bcdff64`, 32 CPUs:

- `garden-monk@2.service` was running the live gauntlet stage
  `endojs-endo-but-for-bots-pr1301-gauntlet-20260918-clean`.
- That ONE job owned **594 processes** against a single project worktree:
  **104 `manager-node.js` + 82 `worker-node.js`** — roughly 190 Endo daemon
  processes spawned by a SINGLE `ava` run of `packages/daemon` under
  `test/_ava-ses.config.js`.
- Load average went 149 -> 168 over ten minutes while the daemon count stayed FLAT
  at ~190 and their ages clustered at median 2125s / max 2189s against an `ava`
  run of 2191s. Flat count plus ages equal to the run's own age means the suite was
  NOT churning through test files — it had stalled under its own contention.
- Nothing throttled. The host kept advertising capacity and kept claiming.

IMPORTANT — DO NOT MISDIAGNOSE THIS AS ORPHANS. It was investigated directly:
ZERO processes had `PPID=1`, and exactly one process fleet-wide sat outside a
`garden-*` unit cgroup. Every process belonged to a LIVE worker's cgroup. This is
not a reaping or cleanup failure; it is the absence of any admission control
relating host load to claim eligibility.

## What to design

The dispatch system today decides whether to claim from BUDGET (token/credit pools,
`pool_admits`), DRAIN state, and worker COUNT. It has no notion of the host's actual
CPU pressure. Worker count is a poor proxy: here, 2 monks were enough to produce
190 processes, because one claim can fan out arbitrarily.

1. A LOAD-AWARE CLAIM GATE. Before a worker claims, consult host CPU pressure and
   decline when saturated. Choose the signal deliberately and justify it:
   1-minute load average relative to `nproc` is the obvious candidate, but consider
   PSI (`/proc/pressure/cpu`), which measures actual stall time and is far less
   noisy than load average on a box running many short-lived processes. State which
   you picked and why.
2. HYSTERESIS. A naive threshold oscillates: refuse, load drops, claim, load spikes.
   Use separate high-water and low-water marks, as `budget-level` already does with
   its 0.85 high-water. Reuse that pattern rather than inventing a second one.
3. FAIL OPEN, NOT CLOSED — and this is the opposite of the budget gate, so say so
   explicitly in the design. An unreadable budget pool means we cannot know if we can
   AFFORD the work, so `credit-controls-fail-closed-pools` correctly refuses. An
   unreadable load signal only means we cannot tell how BUSY we are; refusing every
   claim fleet-wide on a missing `/proc` read would be a self-inflicted outage.
   Degrade to today's behavior.
4. DO NOT KILL OR PREEMPT RUNNING WORK. This gate governs ADMISSION only. The
   maintainer explicitly chose throttling over killing the live job. A saturated host
   stops taking NEW claims and lets in-flight work finish — the same shape as a
   drain, and the scale path already defers on the busy marker so a mid-job worker
   restarts between claims rather than mid-flight. Preserve that.
5. OBSERVABILITY. When a host declines to claim on load, that must be visible —
   coalesced through `watchdog-notice.sh`, one keyed notice per host per episode,
   never one per refused claim. A silent refusal is indistinguishable from an idle
   fleet, which is exactly the confusion that made the foreman quiesce
   (`GARDEN_FOREMAN_ACTIVE_TARGET=0`) invisible for two months.
6. INTERACTION WITH THE FOREMAN AND SCHEDULER. They push work onto the board
   independently of any host's load. Decide whether back pressure belongs only at
   the claim edge, or whether a fleet-wide saturation signal should also damp
   production. Claim-edge alone is the smaller, safer change; say which you chose.

## Explicitly out of scope

The underlying `packages/daemon` test leak (~190 daemons never torn down for one
`ava` run) is a real defect but is UPSTREAM work in `endojs/endo-but-for-bots`, not
this design. Note it as a motivating example; do not fix it here. Likewise the 100
stale `scratch/project-wt-*` worktrees (41 GB) are a separate cleanup concern.

Back pressure is the durable answer either way: the garden cannot assume every test
suite it runs is well-behaved, so the dispatcher must defend the host regardless.

## Deliverable

A design under `designs/`, with an `## Open questions` section if real decisions
remain for the maintainer (per the repo carve-out, that opens as a review PR rather
than landing bare). Include the chosen signal, thresholds, and the fail-open
rationale. Do NOT implement.

<!-- garden-transient-elapsed: kind=signature through=0 values=10 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-19T00:24:15Z -->

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-19T00:25:05Z
