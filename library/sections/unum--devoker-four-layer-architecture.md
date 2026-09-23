---
title: Devoker's four-layer architecture, argv[0] dispatch, and the vigil/refinery engine
source: devoker/DESIGN.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 23cb6dd980e4216ca5631f56973134894bc4aa53
source_date: 2026-07-09
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-orchestration, process-monitoring]
status: current
notes: |
  Architecture overview of the devoker Go binary beyond the prior cycle's
  self-evocation overview: the Evoker→Invoker→Agent→Model layering, the single-binary
  argv[0] dispatch, and the vigil health-monitor / burst / refinery-merge engine.
---

## Abstract

**devoker** ("dAImon Evoker") is a single Go binary that replaced unum's earlier shell suite
(`pivoker/*.sh`), preserving the same model — AI coding agents work tasks one at a time, managed by
systemd services, with lifecycle notifications at each transition. Two orthogonal structures organize
it: a **four-layer conceptual nesting** (Evoker → Invoker → Agent → Model) that names *who is acting*,
and an **`argv[0]` dispatch mechanism** that names *which face of the one binary runs* for a given
entry point. The runtime heart is the **vigil** timer — a periodic health monitor that restarts a
failed worker, idle-kicks pending work, runs a stuck-task detector, and drives occupancy-aware burst
concurrency — feeding the **refinery** branch-merge engine.

## The four layers: Evoker → Invoker → Agent → Model

The vocabulary names a four-layer nesting, outermost to innermost:

1. **Evoker** — the operator (nominally human), the outermost layer. Works from an ordinary git clone
   and evokes either by pushing tasks/code *into* an invoker or through a chat-channel intermediary
   (televoke).
2. **Invoker** — the entity bound within a **least-privilege repository** (a bare repo recognized at
   its git-dir root). Its duty is to *execute* evocations — claim a task, prepare a worktree, prompt
   the harness. Implemented by the `invoke` control binary, the `post-receive` hook, oneshot systemd
   services, and the vigil timer.
3. **Agent** — the harness (Claude Code, Codex, …), constituted by a SOUL, prompted with a task
   pointer, nudged along by the invoker, calling tools on a branch of its realm's repo in an isolated
   worktree.
4. **Model** — the particular LLM the agent uses; the innermost layer that reads, thinks, and decides
   which tools to call.

The relation reads outermost-in: *an Evoker pushes into an Invoker, which runs an Agent, which calls a
Model.* (`televoke` is surface area *to the Evoker* via a chat channel, not a misnamed layer.) The two
altitudes of "evocation" — the task the Evoker pushed, and one run-cycle of the engine (claim → prompt →
dialog → post-process) — are the outer and inner views of a *single* act, so no separate "invocation"
frame sits between them.

## One binary, argv[0]-dispatched faces

All faces live in one `devoker` binary, selected by `argv[0]` detection plus subcommands. The dispatch
is orthogonal to the four layers: most faces (`hook`, `run`, `next`, `notify`, `vigil`) are inner faces
the **Invoker** wears; `init`/`remote`/`make` are the outer face the **Evoker** drives. The flow on a
push: `post-receive` (hook mode) detects task-file changes → `devoker run` creates/starts a systemd
service → `devoker next` finds a task, invokes the agent, archives the session → `devoker notify`
dispatches lifecycle notices. Notable faces: `tasks`/`update`/`archive` (board ops), `cost` (aggregate
the per-run token/compute ledger — see [[cost-ledger]]), `recap` (rebuild an overflow-rotation session
recap), `health`/`repair` (holistic checkup + auto-fixable subset), `make` (host provisioning — see the
[resource-quota section](./unum--make-user-host-resource-quota.md)), and `foreman` (a single
board-sequencing pass). `help` is a terminal verb at *every* dispatch level, printing that level's usage
to stdout and exiting 0 (a real request for help, never the "unknown command" stderr+non-zero); the
side-effecting leaves (`init`, `run`, `vigil`) answer `help` through their own paths so a help request
can never trigger a partial side effect.

## The vigil health monitor and burst engine

`devoker vigil` runs on a recurring timer (≈5 min). Each tick queries the worker unit's `ActiveState` /
`SubState` / `Result` triple and branches:

- **active/activating** → report healthy, log the last resource line, exit early.
- **failed** (exit-code/signal/timeout/core-dump) → report + pending count, dump the last 10 journal
  lines, `reset-failed`, restart via `devoker run`, notify `error`.
- **inactive with pending work** → **defer to a healthy bot first** (televoke idle-kicks promptly off
  its own poll loop, so vigil reports "idle-kick deferred" and does *not* double-kick); only when the
  bot is absent/unhealthy does vigil fall through and trigger the run itself (the optional-bot floor).
- **inactive, no pending** → **run the stuck-task detector first**: classify the in-flight set
  (DOIN-claimed tasks ∪ ledger running/mergeable rows) as healthy or **stuck**; a non-empty stuck set is
  logged loudly and drops a deduped steward-wake marker — vigil never emits the all-clear line while
  something is stuck.

**Occupancy-aware burst (cap>1).** Every kickoff path funnels through one shared
`invokerctl.KickoffAndBurst` primitive: `Start(worker 0)` — the installed `devoker@<slug>` unit — then a
sizing step that may launch *extra* concurrent workers. Demand is sized off *total* work (running +
queued), not queue depth alone:

```
occupied = (worker-0 active ? 1 : 0) + inflight transient workers
want     = min(min(P, cap), occupied + runnable)   // P = host CPU budget, cap = max_concurrent_invocations
launch   = want - occupied
```

Counting the busy worker as *occupancy* is the fix for a staggered-trickle bug (a worker busy on one task
plus one freshly-runnable task now bursts, where the old queue-only formula never did). Cap modes: **1**
(serial floor, a byte-identical no-op), **N** (soft ceiling `min(P, N)`), **0** (uncapped, pure CPU
budget). A **typed agent pool** (`agent_pool: [{agent, count}]`) carves per-agent-profile targets from the
shared budget, so a specialised profile (e.g. `Explore`) claims only tasks whose frontmatter matches. Each
kick also drops a tiny JSON **trigger breadcrumb** just before starting the (idempotent) unit, which the
next `invoke next` consumes and stamps as a `Trigger:` commit trailer — fail-soft throughout (a
missing/malformed breadcrumb falls back to a coarse env var, then `cli`).

Source: [devoker/DESIGN.md](https://tangled.org/jcorbin.tngl.sh/unum) at commit `23cb6dd`.
