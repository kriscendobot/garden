---
title: "ADR 0007: Optional coding-agent review"
source: docs/decisions/0007-update-classification-and-semantic-merge.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: An opt-in, per-file coding-agent review examines baseline, local, and upstream content plus declared file role, then returns a typed keep-local, take-upstream, or merge proposal with an identity-bound rationale; the proposal is inspectable and retained as evidence but writes nothing by itself.

For a file that remains a genuine three-way conflict after the reference fix above,
`litai update` gains an **optional** review step, off by default, that a caller
explicitly requests (a new flag, e.g. `--review-conflicts`, exact name to be finalized
during implementation planning):

1. For each remaining conflict, assemble the three inputs already available to the
   classifier: the recorded baseline, the current local bytes, and the upstream bytes
   at the target revision — plus enough surrounding context (the file's declared role:
   Component, Flavor, skill, workflow, routing, documentation) for a coding agent to
   reason about intent, not just text.
2. Dispatch one coding-agent review per conflicted file (reusing this repository's
   existing coding-CLI adapter, the same selection/priority/fallback machinery
   `litai rebuild` already uses — this is not a new model-invocation surface).
   The agent proposes exactly one of: keep-local, take-upstream, or a merged result,
   each with a short identity-bound rationale citing which specific hunks motivated the
   choice.
3. **Nothing is written from this step alone.** The proposal is returned as a typed,
   inspectable result (plan-only, matching `litai update`'s existing plan/apply
   separation) that the operator reviews before any `--apply` mode acts on it. A silent
   semantic overwrite is never the default, matching this project's `release-project`
   skill's own "never publish only a subset unless explicitly permitted" discipline
   applied to the same class of destructive-by-default risk.
4. The reviewed proposal's rationale is retained alongside the update's other evidence
   (matching `record-user-directed-work`'s existing evidence-checklist convention) so a
   later reader can see why a conflict was resolved the way it was, not just that it
   was.

Source: [docs/decisions/0007-update-classification-and-semantic-merge.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0007-update-classification-and-semantic-merge.md) at commit `2820f853` (source lines 66–93).
