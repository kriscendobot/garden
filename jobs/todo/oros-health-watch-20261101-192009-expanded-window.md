---
role: fixer
tier: mentor
posted_at: 2026-11-01T21:36:49Z
handler-timeout: 7200
split-indivisible-reason: 'sequential single-checkup observation with built-in ~45min claim + ~40min progress wait windows plus sysop ack round-trips exceeds 3600s'
split-lineage-root: oros-health-watch-20261101-192009
split-lineage-parent: oros-health-watch-20261101-192009-split
split-lineage-depth: 1
split-lineage-max-depth: 1
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-01T21:40:08Z cleared=none -->

---
role: fixer
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Expanded-window continuation of `oros-health-watch-20261101-192009` (the oros-studio health watcher for the 19:20Z cycle).

State carried forward from the first attempt (as of 2026-11-01 ~20:20Z):
- `oros-health-checkup-20261101-192009` sat unclaimed ~32 min, was claimed by oros monk-1 at 19:52:08Z, and is now in `jobs/tada/2026/11/01/`.
- Oros heartbeat was fresh (20:03Z); there was no `worker-derotate` marker; `fleet/health` showed `roll_status: deployed` at `d1e41a90e6` (main2 tip).
- One benign op was sent: `op=restore` (msgid 20261101T195257Z-9406f2). It was acked at 19:59:27Z as `failed` with the detail `restore partial: ran reset-failed`, so the sysop is alive and the reset-failed step was applied.

**Do:** read the tada report of `oros-health-checkup-20261101-192009`. If it is healthy, finish with a one-line OK. If it reports problems it could not fix, intervene from afar per the standing watcher spec (`schedules/oros-health-watch.md` on journal2), escalating only as needed. Do NOT resend `op=restore` this run. Recheck the heartbeat age, derotation, roll_status/sha and sysop-log freshness. Message the maintainer only if you send an attested op or oros is unreachable. Do not change worker leveling, derotation markers, budget pools or schedules, and do not post duplicate oros jobs.
