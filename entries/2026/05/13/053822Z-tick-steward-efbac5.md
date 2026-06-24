---
ts: 2026-05-13T05:38:22Z
kind: tick
role: steward
project: garden
subject_matter:
  - standing-monitors
  - daemon-respawn
to: "*"
---

# Standing-monitor liveness check: 4-of-5 dead, respawned

Triggered by my parent-context daemon-log Monitor surfacing `[05:37:19] daemon stopping repo=agoric/agoric-sdk pid=18398`. Liveness probe of all five standing-monitor daemons:

| Daemon | Pid before | Status before | New pid | Status after |
|---|---|---|---|---|
| endojs/endo | (pid file vanished) | DEAD | 59950 | alive |
| endojs/endo-but-for-bots | 18397 | ALIVE (untouched) | 18397 | alive |
| agoric/agoric-sdk | 18398 | DEAD (logged trap) | 59951 | alive |
| dcfoundation/cosmos-proposal-builder | (pid file vanished) | DEAD | 59952 | alive |
| kriskowal/garden | (pid file vanished) | DEAD | 59953 | alive |

Review-queue daemon pid 2243 unaffected.

Cause: not visible in the logs I can read. Only the agoric-sdk daemon logged its own `daemon stopping` trap message (so it received SIGTERM/SIGINT); the other three pids and pid files simply disappeared (consistent with SIGKILL or with the pid file being unlinked while the process was killed elsewhere). The one daemon that survived (`endojs/endo-but-for-bots`, pid 18397) is the one started earliest in the lineage, which is suggestive but not conclusive.

Possible causes (none verified):

1. A `scripts/dispatch-teardown.sh` invocation from one of the in-flight subagent runs (gardener engagement, etc.) inadvertently snared the daemon processes. Teardown should only remove git worktrees, not kill processes, so this would be a bug in the teardown script. Worth a `grep -rn 'kill\|pkill' scripts/` scan to confirm/deny.
2. A subagent ran a broader process-management command (e.g. `pkill -f monitor-poll` from a misconfigured cleanup loop). Worth checking subagent transcripts if available.
3. An OS-level OOM-killer pass. Less likely (the daemons are tiny bash loops + a python parser; they don't allocate much).
4. A manual intervention by the maintainer in a sibling session.

Respawn was clean per the standing-monitors discipline in `roles/steward/AGENT.md`. The new pids are 59950 / 59951 / 59952 / 59953 (repo monitors) and 18397 (survivor). All five daemons logged their startup banner; first-poll `NEW <count>` batches expected within their cadence (60s) and will surface via my parent-context Monitors `brfryz067` and `bnla6ctcb`.

Worth noting that the scripts have NOT yet moved per the gardener's task G (the reorg into skill directories); the respawn used the existing `scripts/monitor-poll.sh` path. When the reorg lands, future respawns must use the new path; the steward's role file's standing-monitors section will reflect that update.

Self-improvement: a simultaneous death of multiple standing daemons is a low-frequency event worth a discipline. Recommend: when the steward's liveness check finds *more than one* daemon dead in a single cycle, write a `message` to liaison alongside the respawn so the cause is investigated rather than silently absorbed. One occurrence is not yet enough evidence for a rule change; if a second multi-daemon-death happens, log a message-to-liaison along with this entry's `refs:` so the pattern is visible.

Self-improvement: nothing for the role file directly. Investigation deferred until/unless a second occurrence happens.
