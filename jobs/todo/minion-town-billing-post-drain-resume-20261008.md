---
role: shepherd
tier: mentor
handler-timeout: 10800
priority: high
dispatch: automatic
fallback-tier: minion
---

# Finish the post-billing gauntlet resumes and proxy screens after deploy quiesce

This is the durable continuation of `minion-town-billing-parked-prs-resume-20261008`.
That shepherd moved all billing-blocked PRs onto #145-capable frozen bases and
proved CI green on `ci.minion.town`, but the host entered a
`rolling-deploy-quiesce` drain while the claim was in flight. `gauntlet.sh`
correctly no-opped under that moratorium, so these exact remaining actions are
owned here after the deploy lifts the drain:

1. Resume the parked gauntlets:
   - `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr166-gauntlet-20261008 fix --iteration 2`
   - `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr170-gauntlet fix --iteration 5`
   - `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr171-gauntlet fix --iteration 4`
   - `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion-town-pr94-screen-e8518a2f-gauntlet fix --iteration 1`
2. Run `scripts/jobs/screen-delegated-prs.sh` so the proxy re-screens #122 and
   #169 under the active minion.town delegation. Confirm its durable actions or
   attestations were posted; do not merely assume the periodic proxy tick ran.
3. Report the resulting gauntlet stage jobs and proxy actions. Do not rerun the
   already-green CI unless a resumed stage changes a head.

Evidence from the predecessor: green current-head rollups on #166, #169, #170,
#171, #94, #122, #153, and newly re-derived #173; proving self-hosted run
https://github.com/kriscendobot/minion.town/actions/runs/37833023533. The frozen
base is `main-50aa690`; stacked #171 uses `feat/prod-objectives-probe-f432a51`
and #153 uses `chore/javascript-only-scripts-part-2a-dcb041b`.
