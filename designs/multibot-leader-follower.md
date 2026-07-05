---
created: 2026-06-28
updated: 2026-06-28
author: gardener
---

# Multibot: gardeners everywhere, singletons on the leader host

| Created | 2026-06-28 |
| Author  | gardener |
| Status  | Implemented; transition mechanics superseded by [leader-follower-determinism.md](leader-follower-determinism.md) |

Tracks issue [kriskowal/garden#11](https://github.com/kriskowal/garden/issues/11)
(Multibot). The garden may run on more than one host sharing one `journal2`
branch. This design says which units run where, and how a host knows.

**Supersession note (2026-07-05).** The leader/follower TRANSITION described
here (the bare `leader` marker, the fail-open predicate default, the prose
handoff ceremony) proved race-prone in practice. Its replacement is
[leader-follower-determinism.md](leader-follower-determinism.md): a structured
epoch-fenced leader record, a two-phase handoff executed by a deterministic
per-host sentinel, a container-minted instance identity with a duplicate-leader
detector, and a fail-closed predicate. This document remains the authority on
WHICH services are singletons versus per-host local-infra (§ The split, § Per-host
local-infra); read the sections below on the predicate, gating, and designation
as historical background for the superseding design.

## The split

- **Gardeners run on EVERY host** (leader and follower alike). Concurrent
  gardeners across hosts are safe: they race-claim jobs through the job board's
  git-push compare-and-swap, which dedups the work. More hosts buys more
  concurrency, never duplication. A **follower** host runs only the gardener pool
  plus the per-host local-infra units below.
- **Singleton services run ONLY on the leader host.** None of them tolerate a
  concurrent duplicate: two foremen double-pump the milestone, two schedulers
  double-dispatch, two bulletins/deadmail/reaper/follow-up double-post or
  double-act, two watchmen double-broadcast, two comment/mention/triager/issue-inbox
  watchers double-post, and two liaison maintainer-inbox Monitors double-answer.
  So each runs on exactly one host.

## Vocabulary (issue ↔ code)

The issue says **leader**/**follower**; the code names the leader in a single
journal file `leader` (at the journal root) holding the leader's `GARDEN`
identity, decoupled from the `hosts/<host>` heartbeat file names.

- **leader host** = the one host whose `GARDEN` identity matches the journal
  `leader` marker; runs the singletons.
- **follower host** = any other host; runs only the gardener pool + local-infra.

## The `GARDEN` host-identity knob

`common.sh` derives the host's logical name from a single canonical knob:

```sh
: "${GARDEN:=$(hostname -s)}"   # the one host-identity name every script uses
```

`GARDEN` is the journal index key, the claim-metadata key, the `hosts/<host>`
worker-count key, and the leader predicate's comparand. An operator exports
`GARDEN=endolinbot2` to spawn a parallel gardener pool from a checked-out worktree
without touching the Dockerfile (the kernel hostname is fixed at container
creation; `GARDEN` is the lighter override).

## The predicate

`is_main_host` (in `common.sh`) compares this host's `GARDEN` to the leader named
in the journal `leader` marker. Resolution order: an explicit `GARDEN_LEADER` env
override, then a TTL-cached read, then a fresh bounded journal read (refreshing
the cache), then the stale cache on a journal outage. When the leader is wholly
undeterminable (cold offline host, no marker, no cache) it falls back to
`GARDEN_LEADER_DEFAULT` — `leader` (fail open) so a lone host's singletons still
run, which keeps single-host behavior unchanged.

`scripts/jobs/is-main-host.sh` exposes the predicate as an executable (exit 0 =
leader, 1 = follower) for systemd.

## Gating

- **Timer-fired singleton oneshots** carry the predicate as an `ExecCondition=`. On
  a follower the timer still fires but the tick is **skipped cleanly**
  (condition-failed, never marked Failed) — that IS follower mode, "watch the
  journal and wait until promoted." Because each firing re-evaluates the condition,
  a leader change (promotion or demotion) is picked up at the next tick with **no
  restart**. The gated units: foreman, scheduler, deadmail, reaper, follow-up,
  proxy, mentor, mirror-closer, comment-watcher@, mention-watcher, triager@,
  issue-inbox, library-source-drift-scan.
- **The continuous bulletin singleton** and the **watchman reread broadcast** gate
  the same predicate **in-process** (the `is_main_host` helper), not at start: the
  marker is re-read each loop iteration / tick, so a demoted leader goes quiet and a
  promoted follower starts posting with no restart. The watchman's fast-forward /
  maintenance half stays every-host; only its duplicate-prone broadcast is
  leader-only.
- **The liaison maintainer-inbox Monitor** is a singleton too, gated by
  documentation: only the leader's liaison runs it (`roles/liaison/AGENT.md`
  § Stand up / stand down). A follower stand-up brings up the gardener pool only.

## Per-host local-infra (the point-2 tension, resolved)

Issue point 2 says a follower runs "only the gardener's systemd processes," yet a
follower still needs to maintain its OWN checkout, clones, and worktrees to run
gardeners at all. Resolution: classify the host-local maintainers as **every-host
local-infra** — they do no *shared* work and never duplicate across hosts, so they
fall under the spirit of point 2. These are `upgrade-monitor`, `clone-keeper`,
`journal-worktree-keeper`, `repo-watcher` (arms this host's watcher units),
`unblock` (deterministic board moves, CAS-deduped), and the watchman's
ff/maintenance half. The watchman is **split**: per-host ff/maintenance
(every-host) and the leader-only broadcast.

## Designating the leader (manual; no failover)

`scripts/jobs/set-main-host.sh [<host>]` CAS-writes the journal `leader` marker the
same way `set-gardeners.sh` writes `hosts/<host>`. Leadership is changed by hand: if
the leader dies, the singletons stay down until the marker is re-pointed. Lease-based
election (automatic failover) is a separate, harder follow-on. The `leader` marker
holds whichever host's `GARDEN` identity should lead, so the gate only bites when a
second host joins.

## Liaison stand-up / stand-down surface

`roles/liaison/AGENT.md` § Stand up / stand down recognizes "start" / "resume" /
"stand up" (verify the `GARDEN` identity is unique, offer the `GARDEN=…` override,
bring units up — gardener pool everywhere, singletons + maintainer Monitor on the
leader only) and "stand down" / "drain" / "stop" / "halt" / "shut down" (drain the
local pool via `drain-fleet.sh on`, or fully stop the units).
