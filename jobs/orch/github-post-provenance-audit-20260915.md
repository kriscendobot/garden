---
order: serial
children: fix-comment-provenance-provider-and-automatic-mark add-per-section-provenance-footnotes-aggregated-reports audit-github-provenance-gaps-20260915
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-09-15T20:50:21Z
---

Orchestrates a 3-part fix for missing model/harness/provider attribution on
posted GitHub comments, triggered by
https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4009312397
(a comment whose footer named only the garden commit sha, no model/harness).

1. fix-comment-provenance-provider-and-automatic-mark — add a `provider`
   fact to the shared footer mechanism, and distinguish "automatic" (no LLM
   in the loop, deliberately marked) from a silently-unresolved fact (an
   instrumentation bug to surface, not paper over).
2. add-per-section-provenance-footnotes-aggregated-reports — for panel
   reviews / PR completion summaries stitched from multiple agents' output,
   footnote each section with ITS OWN model/harness/provider rather than one
   whole-comment footer.
3. audit-github-provenance-gaps-20260915 — audit posted comments on our
   active repos against the fixed mechanism and report gaps (no retroactive
   edits without maintainer sign-off).

Serial: 2 reuses 1's field conventions; 3 audits against the fixed mechanism.
