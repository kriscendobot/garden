---
gate: orchestrated
orchestrated_by: build-confined-application-makers-p2-split-20261003
priority: normal
role: builder
posted_by: orchestrator
posted_at: 2026-10-03T05:28:23Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 2c: `EndoHost.makeFromTree` layout/entry API and draft PR

Finish Phase 2 of the landed `designs/agent-confined-application-makers.md` in
`endojs/endo-but-for-bots`: add `EndoHost.makeFromTree` layout and entry support
and its tests. Read the design in full, particularly Phase 2 and the Test plan.
This child follows the scan and canonical-mount children and is the only child
that opens the Phase-2 draft PR.

Use an isolated project checkout created with:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh build-confined-application-makers-p2-makefromtree-20261003 endojs/endo-but-for-bots llm-confined-application-makers-p2`.
Fetch and continue the existing shared branch rather than recreating it. If the
preceding commits are missing, stop with evidence and emit the orchestrated-failure
signal.

Implement only the remaining `EndoHost.makeFromTree` layout/entry surface and
associated integration/unit tests specified for Phase 2. Preserve the capture and
mount work already on the branch. Run focused tests plus relevant package checks;
commit and push all Phase-2 work.

Before opening anything, rediscover an existing job-owned PR using:
`/home/kris/garden/scripts/jobs/gardening/ensure-pr.sh --find-only build-confined-application-makers-p2-split-20261003 endojs/endo-but-for-bots llm-confined-application-makers-p2 llm-confined-application-makers-p1`.
Then create or adopt exactly one DRAFT PR with:
`/home/kris/garden/scripts/jobs/gardening/ensure-pr.sh build-confined-application-makers-p2-split-20261003 endojs/endo-but-for-bots llm-confined-application-makers-p2 llm-confined-application-makers-p1 --title 'feat(daemon): support confined application makers phase 2' --body-file <body-file>`.
The body must include `<!-- garden-job: build-confined-application-makers-p2-split-20261003 -->` and state that it stacks on #1417. If #1417 has merged before PR creation, use the helper with the appropriate current base branch and state the observed condition in the report. Do not run a gauntlet or mark the PR ready; it remains draft.

Report the pushed head SHA, PR URL/number, base and head branches, changed paths,
and every verification command/result. If a prerequisite or design conflict blocks
the gated PR outcome, preserve the committed branch, report evidence, and emit
the orchestrated-failure signal.
