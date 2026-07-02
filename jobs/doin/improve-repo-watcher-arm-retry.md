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

`scripts/jobs/repo-watcher.sh` logs `WARN: could not arm garden-ci-watcher@endojs-endo-but-for-bots` and `@kriskowal-garden` on four consecutive ticks (00:23–00:27), meaning the templated ci-watcher units may never come up (and indeed the ci-watcher's own `#259 rollup unreadable` skips follow later). The arming failure is silently WARNed and retried only on the next full tick. Have `repo-watcher.sh` capture and log the underlying `systemctl --user` failure (rc + stderr) for the arm call rather than a bare WARN, and add a short bounded retry within the tick, so a transient `systemctl`/`XDG_RUNTIME_DIR` hiccup does not leave a watcher disarmed for a full cycle.

## Re-verification (investigator, 2026-07-02)

Re-verified present at `scripts/jobs/repo-watcher.sh` ~line 141:
`unit_ctl enable --now "$prefix@$slug.timer" || log "WARN: could not arm $prefix@$slug"`
— a bare WARN that discards the underlying `systemctl --user` rc and stderr and
retries only on the next full tick. Capture rc+stderr and add a short bounded
in-tick retry as specified.

---
claim:
  host: endolinbot2
  gardener: 73
  claimed_at: 2026-07-02T10:05:14Z
