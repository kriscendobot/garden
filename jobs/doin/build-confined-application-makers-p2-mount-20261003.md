---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-03T05:52:08Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 2b: canonical mount hook for confined application makers

Implement only the daemon canonical-mount hook portion of Phase 2 from the
landed `designs/agent-confined-application-makers.md` in
`endojs/endo-but-for-bots`. Read the full design, especially Phase 2 and its Test
plan. This child follows the completed `build-confined-application-makers-p2-scan-20261003` child.

Use an isolated project checkout created with:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh build-confined-application-makers-p2-mount-20261003 endojs/endo-but-for-bots llm-confined-application-makers-p2`.
Fetch the shared branch and begin from its pushed head; do not reset, replace, or
discard the preceding child’s commits. If it is absent despite the predecessor
being marked complete, stop with evidence and the orchestrated-failure signal.

Add the daemon’s canonical hook for mounts using `getEntryPhysicalPath`, exactly
with the authority boundary, return shape, and error/confinement behavior in the
design. Do not implement `EndoHost.makeFromTree` layout/entry in this child, and
do not open a PR.

Add focused tests for the canonical mount behavior, including a case that proves
the hook receives/resolves the intended mounted physical entry rather than an
unconfined path. Run the focused tests and relevant package checks. Commit and
push the shared Phase-2 branch. Report the head SHA, changed paths, and executed
verification. On an unmet prerequisite or a design conflict, preserve the branch,
report evidence, and use the orchestrated-failure signal.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T05:53:26Z
