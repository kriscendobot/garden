---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Investigate non-executable Yarn bin shims after a warm-cache worktree hit, and
document (or eliminate) the direct-node fallback.

REPORTED (self-improvement observation from a project job, role/liaison message
20260916T124816Z-08d1dd, host endolin-garden2-5bcdff64, 2026-09-16):
`ensure-project-worktree` reported a WARM-CACHE hit and a populated
`node_modules`, but every package script then failed with PERMISSION DENIED for
`ava` and `tsc`. The package binaries themselves WERE executable; invoking their
JavaScript entry points directly with `node` worked.

That asymmetry is the useful clue: the real binaries are fine, so the failure is
in the shim/link layer between them and the script runner.

TASK:
1. Reproduce on a warm-cache worktree hit. Determine whether warm-cache
   link-state reconciliation CREATES non-executable Yarn bin shims, or merely
   EXPOSES ones that were already wrong (e.g. mode bits lost through a copy,
   hardlink, or restore path that does not preserve them).
2. Fix it at the cause if it is ours. `scripts/jobs/ensure-project-worktree.sh`
   is the entry point; note the known berry-hardlink EMLINK install workaround
   already in this area, which may share a root.
3. If the direct-node invocation is genuinely the EXPECTED fallback rather than a
   workaround for a bug, document it where a gardener will actually meet it, and
   say plainly why the shims cannot be relied on.
4. Add a regression test if the cause is ours.

Report which of (2) or (3) it turned out to be — that is the substance of the
answer, not the fix itself.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T23:09:18Z
