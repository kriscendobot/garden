<!-- POISON POSTMORTEM (investigate-poisoned-garden-infra-jobs, 2026-07-02) -->
<!--
This job was dropped from the board as POISON after 5 reaper requeue cycles. Root
cause of the poisoning was NOT this job body and NOT the infra it targets: a
sustained Claude quota/usage outage (2026-07-01T00:26-00:50Z, recurring in the
2026-07-02T01:20-01:45Z window) made EVERY gardener claude -p handler exit rc=1
with a transient "claude quota/usage cut" signature. The reaper counts requeue
cycles regardless of transient-vs-deterministic classification, so 5 cycles inside
one sustained outage poisoned this job and dozens of unrelated peers
(pr96-shepherd, pr394-fixer, pr216-weave, pr587/588/591-shepherd, ...) identically.
Compounding factor: the endolinbot2 host-identity drift was (and at re-post time
still is) live -- /home/kris/.garden holds "endolinbot2" though hostname -s and the
leader marker are "endolinbot", so is-main-host reports FOLLOWER and the leader-only
singletons were down. The target defect below was re-verified present at re-post
time against origin/main2. Do the work as specified; if claude -p is CURRENTLY
failing with a quota/usage signature, that is an environmental outage -- let the
tick requeue, do not treat it as a job defect.
-->

`garden-issue-inbox.service` logs `Found left-over process (git) in control group while starting unit ... indicates unclean termination of a previous run` (three orphan `git` PIDs at 00:36:21). `scripts/jobs/issue-inbox-watcher.sh` is leaving background git processes that outlive the unit, so the next start inherits stragglers. Make the handler `wait` on (or explicitly kill) every git child before exiting, and/or set `KillMode=mixed` + a bounded `TimeoutStopSec` on the unit in `scripts/systemd/` so the control group is reaped cleanly on stop/restart. Prevents orphan-git accumulation across restarts.

## Re-verification (investigator, 2026-07-02)

Re-verified present: `scripts/systemd/garden-issue-inbox.service` has NEITHER
`KillMode=mixed` NOR a bounded `TimeoutStopSec` (only `TimeoutStartSec=900`), so a
stop/restart does not reap the control group and orphan git children survive into
the next start. Prefer the unit-side fix (`KillMode=mixed` + `TimeoutStopSec`) as
the robust half; the watcher-side `wait`/kill is belt-and-suspenders.
