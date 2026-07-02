# Fix the stale bulletin (leader-only singleton is not running)

**Kind:** garden-infra / operational (out of a gardener's autonomous scope — this
requires standing up a `systemd --user` singleton on the leader host and/or a
host-identity reconciliation + fleet restart. The claiming agent should **escalate
to the maintainer inbox** rather than flip identity or restart the fleet on its
own.)

## Symptom
`journal/README.md` (the journal landing page IS the bulletin) is stale. Last
update `2026-07-02T14:32:17Z`; still stale as of `~2026-07-02T19:03Z` (~4.5h).
The continuous `garden-bulletin.service` is not running on any host.

## Root cause (from the bulletin's own final `## Latest`, 14:31:58Z)
`scripts/jobs/is-main-host.sh` returns **FOLLOWER** on the marker-named leader
host: `/home/kris/.garden` resolves `GARDEN=endolinbot2` while `hostname -s` and
the `leader` marker are both `endolinbot`. Because the bulletin (and every other
leader-only singleton — foreman, scheduler, reaper, triager, issue-inbox,
ci-watcher, orchestrate, and the maintainer-inbox Monitor) gates in-process on
`is_main_host`, they are all being **silently skipped**. Not a `bulletin.sh`
defect — the loop ran cleanly until the identity flipped.

## The contested point (needs maintainer adjudication — do NOT guess)
Whether `endolinbot2` is the **intended** shard identity (per liaison memory: a
legitimate parallel-pool identity past the drift guard) or a **drift** on the true
`endolinbot` leader host (per the gardener investigation). The correct fix branch
depends on this and is the maintainer's call.

## Fix — branch on the identity decision
- **If `endolinbot` is authoritative (endolinbot2 is a drift):** reconcile
  `echo endolinbot > /home/kris/.garden`, then restart the fleet
  (`scripts/jobs/install-units.sh` reconcile + gardener restart). `is-main-host`
  starts returning LEADER; the leader-only singletons — bulletin included — come
  up. Verify `journal/README.md` advances within one board transition.
- **If `endolinbot2` is authoritative (this host is genuinely a follower):** the
  separate `endolinbot` leader host must stand up `garden-bulletin.service`
  (`systemctl --user start garden-bulletin.service` once `is-main-host` = LEADER
  there). If that host is gone/unreachable, **hand off leadership** to
  `endolinbot2` via `scripts/jobs/set-main-host.sh endolinbot2` (raises this host
  as leader through its standing leader-marker watch), then this host stands up
  the bulletin.

## Also
Send a message to the leader (below) to stand up `garden-bulletin` **or yield**
leadership — standing up the leader-only singleton is the leader's job.

## Done when
- `garden-bulletin.service` is `active (running)` on exactly one host (the leader).
- `journal/README.md` freshness line advances as the board moves.
- The `.garden` / `leader` / `hostname` identity triple is self-consistent on the
  leader host (`is-main-host.sh` returns LEADER there).

---
claim:
  host: endolinbot2
  gardener: 11
  claimed_at: 2026-07-02T19:07:03Z
