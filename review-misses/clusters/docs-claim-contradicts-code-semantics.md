---
slug: docs-claim-contradicts-code-semantics
category: docs-drift
status: closed
count: 3
members:
  - endojs-endo-but-for-bots-pr475-review-41c12eb0
  - endojs-endo-but-for-bots-pr877-review-e5dd1111
  - endojs-endo-but-for-bots-pr264-review-1da7ebe7
prs: [475, 877, 264]
improvement_job: review-improve-docs-claim-contradicts-code-semantics
improved_by: d5c13fcfe0 (roles/COMMON.md § Definite technical claims in authored prose; roles/jurors/archivist/AGENT.md cross-verify check; skills/panel-hints/probes/C-archivist-claim-accuracy.sh + panel-hints.sh design-panel cross-fire; scripts/jobs/test/docs-claim-accuracy-probe-test.sh)
---





A doc asserts an API-semantics/brand-check claim that contradicts the repo's own authoritative reference code, because review checks prose for clarity but does not cross-verify definite technical claims against the implementation they describe.

**Threshold rationale:** Floor met and dispatch justified. Cluster `docs-claim-contradicts-code-semantics`
now holds count=3 misses across 3 distinct PRs (475, 877, 264) — clearing the
K≥3 / ≥2-PR floor. The judgment above the floor is dispatch, not hold: the three
members are not one messy PR masquerading as a pattern. They span two producing
roles (builder for #475 and #877, designer for #264) and three artifact kinds
(package README prose, source-file header comment, design-proposal doc), yet all
share one exact shape — fleet-authored prose asserting a definite,
in-repo-verifiable technical claim that contradicts the authoritative code (or,
for #264, the doc's own later text), missed because review reads prose for clarity
without cross-verifying its definite technical claims against the implementation.
That is a genuine, recurring, sense-and-prevent gap in the docs-prose-accuracy
lens (the archivist seat), exactly the systemic signal the threshold is for. No
fix for the pattern is already in flight. Dispatching one
`review-improve-docs-claim-contradicts-code-semantics` builder job.
