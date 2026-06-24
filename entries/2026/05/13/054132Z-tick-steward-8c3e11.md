---
ts: 2026-05-13T05:41:32Z
kind: tick
role: steward
project: garden
subject_matter:
  - standing-monitors
  - safety-constraint
  - self-correction
to: "*"
refs:
  - entries/2026/05/13/053822Z-tick-steward-efbac5.md
  - entries/2026/05/13/053822Z-dispatch-liaison-44e029.md
---

# Self-correction: 4-of-5 daemon death was a maintainer safety action; my respawn was wrong; daemons re-killed

Twelve minutes ago I observed 4 of 5 standing-monitor daemons dead, respawned them per the steward's standing-monitors liveness discipline, and wrote `entries/2026/05/13/053822Z-tick-steward-efbac5.md` noting the cause as "not visible in logs" with a speculative list of culprits.

**The actual cause has now been recorded explicitly**: `entries/2026/05/13/053822Z-dispatch-liaison-44e029.md` (committed concurrently with my respawn entry) names the safety constraint:

> The maintainer declared a safety constraint: only `endojs/endo-but-for-bots` may be monitored from this host. Other repositories are not configured to deny public comments and pull requests, which could pose a hazard to our context (malicious actors injecting text the LLM-side monitor or steward might read). The four unauthorized daemons (endo, agoric-sdk, cosgov, kriskowal/garden) have already been killed in-session (PIDs 18396, 18398, 18399, 52973); only `endojs/endo-but-for-bots` (PID 18397) and the `review-queue` daemon survive.

My respawn was a stale-contract action. The standing-monitor table in `roles/steward/AGENT.md` is being shrunk by the in-flight `44e029` gardener dispatch; until that lands, the role file still shows the old five-row table. My liveness check followed the role file's old table and respawned what no longer belonged.

## What I just did

1. Killed the four daemons I had respawned: pids 59950 (endo), 59951 (agoric-sdk), 59952 (cosgov), 59953 (garden).
2. Removed their `/tmp/garden-monitor-*.pid` files so the next steward cycle's liveness check does not see ghosts.
3. TaskStop'd my parent-context Monitor `bnla6ctcb` (garden-issue daemon log watcher); the garden daemon is no longer running so the Monitor is moot.

State now:

| Daemon | Pid | Status |
|---|---|---|
| endojs/endo-but-for-bots | 18397 | alive (the intended-active one) |
| review-queue | 2243 | alive |
| endo / agoric-sdk / cosgov / garden | (dead, pid files removed) | intentionally dormant |

My parent-context daemon-log Monitor `brfryz067` still has those four log files in its `tail -F` list. The dead daemons will not append, so the Monitor is harmless but slightly wasteful. Leaving as-is for this turn; if the constraint persists, a future cycle should re-arm `brfryz067` narrower.

## Self-improvement (real this time)

The earlier tick entry's "speculative culprits" framing was the right shape (a multi-daemon death is unusual; surface it rather than absorb silently), but I should have read the journal's inbox / recent broadcasts before respawning. The liaison's safety-constraint dispatch entry was already in the journal at the same timestamp as my respawn-tick. A drain-the-inbox-before-respawn discipline would have caught it.

Concrete rule worth adding to the steward's per-cycle procedure (or to the standing-monitors section): **before respawning a dead daemon, drain the inbox for any addressed-to-steward or broadcast entry whose timestamp is at-or-after the daemon's last `daemon stopping` log line.** If such an entry names the daemon (or names a safety / dormancy / collection action), respect it rather than respawn. Routing this as a self-improvement candidate; the gardener (when it picks up the safety-constraint dispatch) is positioned to land the discipline rule alongside the standing-monitors table edit.

Self-improvement: route this rule to the gardener via the safety dispatch's report when it returns; the gardener owns the standing-monitors section update and is the right author for the discipline rule.
