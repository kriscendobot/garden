---
gate: orchestrated
orchestrated_by: oros-health-watch-20261018-123528-split
handler-timeout: 7200
split-indivisible-reason: 'The health verdict and any sysop intervention form one stateful observation-and-escalation cycle; separate workers could duplicate operations or act on inconsistent host state.'
split-lineage-root: oros-health-watch-20261018-123528
split-lineage-parent: oros-health-watch-20261018-123528-split
split-lineage-depth: 1
split-lineage-max-depth: 1
priority: normal
posted_by: producer
posted_at: 2026-10-18T13:46:10Z
---

---
role: fixer
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

**Role: fixer.** **Recurring oros-studio health watcher (every 3h, pinned to the leader, staggered about 45 min after `oros-health-checkup`).** Make sure this cycle's oros-pinned `oros-health-checkup-*` job is claimed and making progress. If it is not, try to bring oros back to health from afar through the sysop bridge.

Standing maintainer request (kriskowal, 2026-10-02).

Each run:

1. Find this cycle's checkup: the newest `oros-health-checkup-*` in `jobs/{todo,doin,tada}` with a post time within the last approximately 3 hours.
   - In tada: read its report. If it says healthy, finish with a one-line OK. If it reports problems it could not fix, go to step 3 for anything addressable from afar.
   - In doin (claimed): watch for up to about 40 minutes for progress. Signs of progress are commits from oros, journal activity, its heartbeat (`budget/live/claude-oros/oros-studio-garden-ce242c49`) refreshing, or an advancing `oros-health-log.md`. If it completes, handle it as tada. If it is wedged (no oros journal activity for more than 30 minutes, or the reaper flags it), go to step 3.
   - Still in todo (unclaimed after about 45 minutes): oros may be offline, derotated, drained, or wedged. Go to step 3.
2. Also check, every run:
   - the age of oros's heartbeat;
   - `worker-derotate/oros-studio-garden-ce242c49`;
   - oros's `fleet/health` roll_status and deployed sha versus main2;
   - its sysop-log freshness (`sysop-log/oros-studio-garden-ce242c49/`), which tells you whether the sysop is alive.
3. Intervene from afar, escalating only as needed, with `scripts/jobs/send-host-op.sh oros-studio-garden-ce242c49 op=...`:
   - First, benign ops: `op=reset-failed`; `op=restore` if the host is quota/outage-stalled.
   - Next, `op=drain state=off`, only for a stale drain left by the rolling deploy or a stale liaison drain. Never lift a fresh, active roll drain mid-deploy or an operator drain with a live reason.
   - Last, attested ops with `authorized_by=kriskowal` (the maintainer authorized this watcher to use them for oros health on 2026-10-02): `op=unit action=restart name=garden-budget-refresh.timer` (or another wedged garden unit you identify); `op=maintain` for a confirmed-stale git gc lock or repo bloat. Do not use `op=deploy` or `op=local-model`.
   - The sysop applies about one op per tick (minutes each). Send at most one op of each kind per run, then confirm the acknowledgments (`sysop_ack` in `msgs/host/<this host>` / `sysop-log`).
4. If oros is unreachable (no sysop-log activity for more than 1 hour), say so plainly. That needs a person at the machine: Docker Desktop, the Mac sleeping, or the VM.
5. Report one line of verdict (OK / intervened / unreachable), the ops sent and their acknowledgments, and what still needs a person. Message the maintainer inbox with `message-user.sh` only when you intervened with an attested op or oros is unreachable. Otherwise stay quiet.

Do not change worker leveling, derotation markers, budget pools, or schedules. Do not post duplicate oros jobs; the checkup schedule handles recurrence.
