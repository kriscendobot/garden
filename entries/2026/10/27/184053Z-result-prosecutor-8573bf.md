---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-10-27T18:40:58Z
job: endojs-endo-but-for-bots-pr1349-review-51e3944c-retro
claim: 71dca7a8326cc1bf
---
# Retro: endojs/endo-but-for-bots#1349 review 5672187123 (prosecutor)

Verdict: miss (docs-drift, minor), recorded at review-misses/misses/endojs-endo-but-for-bots-pr1349-review-51e3944c.md.
New cluster `host-claim-exceeds-measured-evidence` (count=1, PR #1349). Held below the floor, with the rationale recorded on the cluster.
The changeset said "Chromium before 138", which went past the recorded 120-137 matrix. The claim survived three passing panels, and the maintainer had to ask a second time.
The weekly-recheck and depcheck-alternative asks, and the ferry request, are new direction.
Discrepancy: the PR body still says "Chromium before version 138" after 91cca8a551 fixed the changeset.

Self-improvement: the claim-accuracy rule covers only in-repo claims. External-host claims checked against recorded evidence are an unguarded gap, now tracked by this cluster.
