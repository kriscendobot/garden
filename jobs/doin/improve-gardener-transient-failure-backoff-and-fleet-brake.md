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

`scripts/jobs/gardener.sh`: on a correlated Claude quota/API outage, all ~100 gardeners thrash — 50+ entries in ~15 min show shepherd handlers failing transiently (rc=1 / exit-0-unsatisfying, the message literally names "claude quota/usage cut"), all requeuing and immediately re-claiming. The loop's `idle_backoff` is applied ONLY on empty-claim and offline-completion paths; both transient-failure branches (the `elif [ "$hrc" -eq 0 ]` exit-0-unsatisfying branch ~line 318 and the non-zero transient branch that ends at `done` line 604) fall straight back to the claim head with zero delay. Result: the fleet re-runs the same jobs against an already-exhausted quota, amplifying the outage and churning todo↔doin. Add (a) a per-worker exponential+jittered backoff after any transient-classified handler failure (reuse `idle_backoff`/`idle_attempt` so a just-failed worker does not instantly re-claim), and (b) a shared fleet brake: when the recent transient-failure density crosses a threshold (a rolling count in `$GARDEN_STATE`, written by any gardener on a transient failure), gardeners pause claiming for a backoff window so a quota storm drains instead of being fed. Keep the reaper as the sole requeue owner; this changes only claim cadence, not board ownership.

## Re-verification (investigator, 2026-07-02)

Re-verified present against origin/main2: the non-zero transient branch (now the
`if [ "$transient" -eq 1 ]` block at gardener.sh ~line 477) stamps a reap-now hint
and loops STRAIGHT back to the claim head with ZERO delay — no `idle_backoff` on
either transient path, and no shared fleet brake exists. This job is the sanctioned
fix for the exact thrash that poisoned all five garden-infra jobs (see postmortem
above); prioritize it — until it lands, the next quota storm re-poisons the board.

---
claim:
  host: endolinbot2
  gardener: 94
  claimed_at: 2026-07-02T10:04:31Z
