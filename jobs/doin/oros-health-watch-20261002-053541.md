---
handler-timeout: 3600
---

---
role: fixer
requires: host=endolin-garden-ece02cb4
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** **Recurring oros-studio health watcher (every 3h, pinned to the leader, staggered about 45 min after `oros-health-checkup`).** Your job is to make sure this cycle's oros-pinned `oros-health-checkup-*` job is **claimed** and is **making progress**. If it isn't, try to bring oros back to health **from afar** through the **sysop bridge**.

Standing maintainer request (kriskowal, 2026-10-02).

**Each run:**
1. **Find this cycle's checkup:** the newest `oros-health-checkup-*` in `jobs/{todo,doin,tada}` (post time within the last ~3h).
   - **In tada:** read its report. If it says healthy, finish with a one-line OK. If it reports problems it couldn't fix, go to step 3 for anything addressable from afar.
   - **In doin (claimed):** watch for up to about 40 min for progress. Signs of progress: commits from oros, journal activity, its heartbeat (`budget/live/claude-oros/oros-studio-garden-ce242c49`) refreshing, or an advancing `oros-health-log.md`. If it completes, handle it as tada. If it is wedged (no oros journal activity for more than 30 min, or the reaper flags it), go to step 3.
   - **Still in todo (unclaimed after about 45 min):** oros may be offline, derotated, drained, or wedged. Go to step 3.
2. **Also check, every run:**
   - the age of oros's heartbeat;
   - `worker-derotate/oros-studio-garden-ce242c49`;
   - oros's `fleet/health` roll_status and deployed sha vs main2;
   - its sysop-log freshness (`sysop-log/oros-studio-garden-ce242c49/`), which tells you whether the sysop is alive.
3. **Intervene from afar** (escalate only as needed) with `scripts/jobs/send-host-op.sh oros-studio-garden-ce242c49 op=…`:
   - First, benign ops: `op=reset-failed`; `op=restore` if the host is quota/outage-stalled.
   - Next, `op=drain state=off`, **only** for a stale drain left by the rolling deploy or a stale liaison drain. Never lift a fresh, active roll drain mid-deploy or an operator drain with a live reason.
   - Last, attested ops with `authorized_by=kriskowal` (the maintainer authorized this watcher to use them for oros health on 2026-10-02): `op=unit action=restart name=garden-budget-refresh.timer` (or another wedged garden unit you identify); `op=maintain` for a confirmed-stale git gc lock or repo bloat. Do **not** use `op=deploy` or `op=local-model`.
   - The sysop applies about one op per tick (minutes each). Send at most one op of each kind per run, then confirm the acks (`sysop_ack` in `msgs/host/<this host>` / `sysop-log`).
4. If oros is unreachable (no sysop-log activity for more than 1h), say so plainly. That needs a person at the machine: Docker Desktop, the Mac sleeping, the VM.
5. **Report:** one line of verdict (OK / intervened / unreachable), the ops sent and their acks, and what still needs a person. Message the maintainer inbox (`message-user.sh`) **only** when you intervened with an attested op or oros is unreachable. Otherwise stay quiet.

Do not change worker leveling, derotation markers, budget pools or schedules. Do not post duplicate oros jobs; the checkup schedule handles recurrence.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T06:21:42Z
