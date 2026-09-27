---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr95-review-6266ce72
verdict: not-a-miss
category: new-direction
review_at: 2026-09-23T17:27:36Z
repo: kriscendobot/garden
comment_url: https://github.com/kriscendobot/garden/pull/95#pullrequestreview-5294397181
identity: kriscendobot/garden#95:review:5294397181:retro
producing_role: designer
producing_job: garden-gauntlet-reexport-policy-check
---

PR #95 was an explicitly marked design open-questions answer surface for the already-landed re-export policy proposal. The maintainer resolved five choices the design had deliberately left for maintainer judgment, then commissioned incorporation, implementation, synthetic validation, and finalization. Those decisions established the rule's previously undecided barrel, annotation, reviewer, deployment-scope, and type-export boundaries; the follow-on work was new direction rather than correction of a defect that review should already have detected.

The absence of panel rounds is not evaluator avoidance. The PR carried the sanctioned `garden-design-open-questions` marker, and the standing carve-out intentionally makes the maintainer the evaluator for unresolved design forks while suppressing a design-panel gauntlet. The originating designer report confirms the design was landed on `main2` and the PR was opened solely as that answer surface. Consequently no seat, gate, or standing instruction had an antecedent requirement with which to indict the review process.

Grounded independently in current state, the primary's claimed deliverables exist: resolution commit `7c712dafbef` and implementation commit `b499967687` are ancestors of `origin/main2`; the journal has completed build, synthetic-validation, conductor, and parent-orchestration reports; and GitHub shows PR #95 closed with the resolution and implementation recorded. This is therefore not the false-peer no-op case. Nobody could have anticipated answers to explicitly open questions or the maintainer's new build-and-validate commission.
