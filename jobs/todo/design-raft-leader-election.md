# Design PR: RAFT leader election for the multibot fleet (half-hour cadence, journal2 as the ledger)

**Type:** design-only PR (a new markdown design under `designs/`, e.g.
`designs/raft-leader-election.md`). No source/behavior change in this PR — it
proposes the design for review. Open it against `origin` (`kriskowal/garden`)
with the head branch on the `fork` remote (`kriscendobot/garden`); the garden's
design-only-PR workflow governs the mechanics.

**Maintainer ask (verbatim intent):** propose a design PR on `kriskowal/garden`
for **RAFT leader election** with a **very slow, half-hour cadence**, using the
**`journal2` branch as the ledger**. A reference RAFT implementation lives in
**`kriskowal/cask`** — study it and adapt.

## Why / what it replaces

The fleet is leader/follower today (`designs/multibot-leader-follower.md`,
issue kriskowal/garden#11): gardeners run on every host; **singleton services run
only on the leader** named by the `journal2:hosts/main-host` marker; the
`scripts/jobs/is-main-host.sh` predicate gates them via `ExecCondition=`.
Leadership is currently **manual with no failover** — `scripts/jobs/set-main-host.sh`
hand-writes `hosts/main-host`, and "if the leader dies the singletons stay down
until the marker is re-pointed by hand." That doc explicitly defers the fix:
*"Lease-based election (automatic failover) is a separate, harder follow-on."*
**This design IS that follow-on.** It must preserve the existing gating contract:
the election's output should ultimately drive the same `hosts/main-host` marker
(or a clearly-specified successor) so `is-main-host.sh` and every `ExecCondition`
gate keep working unchanged, and `set-main-host.sh` degrades to a seed/override.

## Required scope of the design doc

1. **Map RAFT onto journal2.** journal2 is the replicated log / ledger. The
   git **push-to-`origin/journal2` is already the fleet's compare-and-swap**
   serialization point (the job board claims, `set-gardeners.sh`, every producer
   use this CAS). Express RAFT's persistent state — `currentTerm`, `votedFor`,
   log entries (term + leadership grant) — as journal2 files, and RAFT's
   transitions (RequestVote, AppendEntries/heartbeat, leader commit) as
   journal2 entries serialized by that push-CAS. Reconcile this with **cask's
   transport** (cask is "half a century of networking and databases with just
   UDP and a CAS of 1KB blocks") — name the analogy explicitly: cask's CAS of
   1KB blocks ↔ the garden's git-CAS on journal2; cask's UDP heartbeats ↔
   periodic journal2 heartbeat entries. Adapt cask's RAFT structure; do not
   reinvent it.
2. **The half-hour cadence, justified.** Tune RAFT's timers to a *very slow*
   scale: heartbeat interval on the order of tens of minutes and an election
   timeout around / above 30 minutes (with the usual randomized spread to avoid
   split votes). Argue *why* such a slow cadence is acceptable and even desirable
   here: leadership only gates singleton services, a multi-minute leaderless gap
   is tolerable (followers simply keep claiming jobs), and a slow cadence
   **minimizes journal2 push contention and churn** against the busy job board.
   State the worst-case failover latency (≈ one election timeout) and confirm it
   is acceptable for the singletons it gates (scheduler, foreman, bulletin,
   deadmail, reaper, watchman broadcast, the watchers, and the leader-only
   maintainer-inbox Monitor).
3. **Safety: no two leaders.** The whole point of the leader split is that the
   singletons are duplication-intolerant (two bulletins double-post, two
   schedulers double-dispatch). The design must show how RAFT term + majority
   vote + leader lease **prevents split-brain** at this cadence, including the
   lease-expiry / step-down rule a demoted or partitioned ex-leader follows
   before another can win (so the `is-main-host` in-process re-check in the
   bulletin/watchman goes quiet in time). Address the git-CAS reality: rejected
   pushes (lost CAS races) are the analogue of dropped/again-tried RPCs —
   specify the backoff and how a stale term loses.
4. **Membership.** Hosts join/leave via `journal2:hosts/<host>` today. Define the
   voter set (which hosts count toward a majority), how a new host is admitted,
   and how a permanently-dead host is removed so it cannot wedge the quorum.
5. **Integration + migration.** Keep `hosts/main-host` (or a named successor) as
   the committed leader output that `is-main-host.sh` reads; specify how
   `set-main-host.sh` becomes a manual seed/override (bootstrap and break-glass);
   and give the rollout from today's single manual leader (`endolinbot`) to an
   elected one with no flap. A deterministic election tick almost certainly wants
   to run as an **every-host** systemd timer (like the other per-host local-infra
   units) rather than a leader-only singleton — call that out.

## References to read first

- `kriskowal/cask` — the reference RAFT implementation (adapt its structure;
  reconcile its UDP + 1KB-block-CAS transport with journal2's git-CAS).
- `designs/multibot-leader-follower.md` — the leader/follower split, the
  `hosts/main-host` marker, `is-main-host.sh`, the gated unit list, and the
  explicit "manual; no failover" gap this closes.
- `designs/job-board.md` and `skills/job-board/SKILL.md` — how journal2 push-CAS
  already serializes fleet state (the substrate RAFT rides on).
- `scripts/jobs/is-main-host.sh`, `set-main-host.sh`, `common.sh` (the
  `GARDEN`/`GARDEN_HOST` identity knob and the `is_main_host` resolution order).

## Deliverable / definition of done

A design-only PR on `kriskowal/garden` adding `designs/raft-leader-election.md`
covering items 1–5 above, citing cask and the multibot design, with the timer/
cadence parameters concrete enough to implement, and an explicit safety argument
that two leaders never run the singletons concurrently. Design only — no script
changes in this PR.
