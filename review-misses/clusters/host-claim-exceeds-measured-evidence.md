---
slug: host-claim-exceeds-measured-evidence
category: docs-drift
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr1349-review-51e3944c
prs: [1349]
---


A release note or comment states an external-host behavior range broader than the measurements the producing work recorded (an open-ended "all before N" from a sampled matrix), and review does not compare the claim against the recorded evidence, because the claim-accuracy lens covers only in-repo-verifiable claims.

**Threshold rationale:** Held below the dispatch floor. The new cluster has count=1 on one PR (#1349), short of K >= 3 across >= 2 PRs. The severity bypass does not apply: the miss is minor (a release-note range), and the nearest standing rule (COMMON.md § Definite technical claims, plus the archivist cross-verify check) covers only in-repo-verifiable claims, so it did not clearly bind an external host-version claim. A future member of this cluster, or of the related evidence-backed-host-workaround cluster (#259), would justify a combined improvement. That improvement would extend the claim-accuracy rule and the archivist/changeset-auditor check to external-environment claims, compared against the evidence the producing job recorded. It should also add a reply-reconciliation check for "be more precise" asks.
