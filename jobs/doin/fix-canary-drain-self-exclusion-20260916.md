---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: this garden repo (main2). Fix a self-sustaining deadlock in the rolling deploy.

OBSERVED (endolin-garden2-5bcdff64, 2026-09-05..09-16): the host sat 6 commits
behind for 9+ days and the watchdog `rolling-deploy-all-followers-drained-
endolin-garden-ece02cb4` fired 1545 times. A hand-run `deploy-garden.sh` then
succeeded cleanly in 23s (gate passed, 123 units coherent), proving the deploy
path itself was never broken.

ROOT CAUSE (verified in code):
- `scripts/jobs/rolling-deploy.sh:203` remediates a FAILED canary by sending a
  benign `drain on` to that host.
- `scripts/jobs/self-deploy.sh:91` declines to deploy whenever `fleet_draining`,
  publishing roll_status `operator-drained` ("never self-deploy out from under
  an operator").
- `scripts/jobs/rolling-deploy.sh:280` then SKIPS any host publishing
  `operator-drained`.
A canary-failure drain is thus indistinguishable from an operator drain, so the
failed canary is permanently excluded from every subsequent roll and can never
retry itself. Only a human breaks the loop. The "skip a paused host" behavior is
correct in isolation; the bug is that the failure remediation manufactures
exactly the state that makes recovery impossible.

TASK: distinguish a ROLL-INDUCED drain from an OPERATOR drain, so the roll can
re-release a previously-failed canary on its own while still honoring a genuine
operator pause. Suggested shape (the design call is yours to make and justify):
record provenance in the draining marker -- it already carries `set_by`/`reason`
(this host's read `reason: rolling-deploy: canary FAILED validation (...)`) --
and have self-deploy/rolling-deploy treat a roll-set drain as retryable (with a
bounded retry count and an escalation to the maintainer inbox when exhausted)
while an operator-set drain stays absolutely inviolable. Do NOT weaken the
operator-drain guarantee.

Also consider: the 1545-occurrence watchdog coalesced correctly but never
escalated its severity as the condition aged. A stuck-for-days condition
deserves a louder signal than a stuck-for-an-hour one; judge whether that
belongs in this change or a follow-up.

Include a regression test under scripts/jobs/test/ that pins the recovery path.
Design: designs/follower-self-deploy.md.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T05:29:10Z
