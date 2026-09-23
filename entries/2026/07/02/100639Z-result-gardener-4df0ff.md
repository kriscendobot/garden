---
kind: result
role: gardener
host: endolinbot2
at: 2026-07-02T10:06:40Z
---
# investigate-poisoned-garden-infra-jobs — result

Root-caused the 5 poisoned garden-infra jobs and re-posted all five with corrected
bodies (none re-posted unchanged). No infra source landed on main2; the one live
operational defect found is out of a gardener's autonomous scope and was routed to
the maintainer inbox.

## Shared root cause of the POISONING (all 5)

The poisoning was NOT caused by bad job bodies and NOT by the infra the jobs target.
A sustained Claude quota/usage outage (2026-07-01T00:26-00:50Z, recurring in the
2026-07-02T01:20-01:45Z window) made every gardener `claude -p` handler exit rc=1
with a transient "claude quota/usage cut" signature. The reaper counts requeue
cycles regardless of transient-vs-deterministic classification
(GARDEN_REAP_POISON_THRESHOLD=5), so 5 requeue cycles INSIDE one sustained outage
poisoned each job. Dozens of unrelated peers failed identically in the same window
(pr96-shepherd, pr394-fixer, pr216-weave, pr587/588/591-shepherd, ...), which is
the proof the cause was environmental, not per-job. The fleet then went quiet from
~01:34Z until the ~09:54Z restart; the outage has passed, so the re-posts are safe
timing-wise. All four "improve-*" target defects were RE-VERIFIED still present
against origin/main2 before re-posting, so none is moot.

Compounding factor (see the identity-drift finding below): the endolinbot2 host
identity was drifted throughout — every entry keyed host: endolinbot2 — and remains
drifted at result time.

## Per-job findings and actions

1. improve-gardener-transient-failure-backoff-and-fleet-brake
   - Intent: add per-worker backoff + shared fleet brake so a quota storm drains
     instead of being fed by instant re-claims.
   - Root cause of failure: environmental outage (above). Body is correct.
   - Re-verified: the transient block (`if [ "$transient" -eq 1 ]`, gardener.sh
     ~L477) stamps a reap-now hint and loops STRAIGHT to the claim head — zero
     idle_backoff on either transient path; no fleet brake exists. This job is the
     sanctioned fix for the very thrash that poisoned all five.
   - Action: RE-POSTED corrected (poison postmortem + re-verification header).

2. improve-garden-identity-drift-detector
   - Intent: a loud deterministic guard when $GARDEN != hostname -s with no
     recorded parallel-pool override.
   - Root cause of failure: environmental outage (above). Body is correct AND the
     drift it describes is STILL LIVE: /home/kris/.garden holds "endolinbot2" while
     hostname -s and journal/leader are "endolinbot", so is-main-host.sh returns
     FOLLOWER on the true leader host and every leader-only singleton is skipped.
   - Why existing guards miss it: gardener.sh:98 only `log`-WARNs (not kind:error);
     gardener-scaler reconcile-identity catches only /proc-vs-resolved INCONSISTENCY,
     but a .garden-FILE override makes all workers resolve endolinbot2 consistently.
   - Action: RE-POSTED sharpened (names the .garden source, the is-main-host
     consequence, and the existing guards to build on). Separately MESSAGED the
     maintainer about the live .garden regression (operational fix on the deployed
     root — echo endolinbot > .garden OR re-point the leader marker — is out of a
     gardener's autonomous scope; msg 20260702T100530Z-a43c17).

3. improve-issue-inbox-child-git-reaping
   - Intent: reap orphan git children on stop/restart of garden-issue-inbox.
   - Root cause of failure: environmental outage (above). Body correct.
   - Re-verified: garden-issue-inbox.service has neither KillMode=mixed nor a
     bounded TimeoutStopSec (only TimeoutStartSec=900).
   - Action: RE-POSTED corrected.

4. improve-repo-watcher-arm-retry
   - Intent: capture rc+stderr and add a bounded in-tick retry for the
     ci-watcher arm call instead of a bare WARN.
   - Root cause of failure: environmental outage (above). Body correct.
   - Re-verified: repo-watcher.sh ~L141 `unit_ctl enable --now ... || log "WARN:
     could not arm ..."` discards rc/stderr and retries only next full tick.
   - Action: RE-POSTED corrected.

5. build-daemon-rename-to-manager  (project build job, endojs/endo-but-for-bots —
   in the poison list though outside the garden-infra target set)
   - Intent: rename daemon.js->manager.js and Daemon*/Mignonic* identifiers on the
     `llm` branch, phased, DRAFT-first.
   - Root cause of failure: environmental outage (above). Its poison report was
     already in inbox/maintainer/read/, so nothing to archive.
   - Action: RE-POSTED corrected (poison postmortem prepended).

## Not re-posted unchanged / not dropped

No job was re-posted unchanged and none was dropped as moot — all four infra
targets are real and still present, and the build job is still valid work. Every
re-post carries a poison-postmortem header so a future handler will not blindly
re-poison during the next quota storm.

## Follow-ups

- Operational (maintainer): correct /home/kris/.garden (or re-point the leader
  marker) and restart the fleet so is-main-host flips back to leader. Until then
  the leader-only singletons are down on endolinbot.
- Possible infra hardening (not filed — flagging): the reaper poisons a job after
  5 requeue cycles even when all 5 failures are sustained-environmental transients.
  Distinguishing a sustained-outage transient from a genuinely-broken handler in
  the poison counter (or pausing the counter under the fleet brake from job #1)
  would prevent this whole class of mass-poisoning. Left to the maintainer /
  backoff-brake job author to decide, as it trades off against letting a genuinely
  broken job loop forever.
