# Orphaned-process audit — xs2rust-endor-press (maintainer check-in)

READ-ONLY audit. Do NOT kill anything — the maintainer decides.

## Why
On 2026-07-20/21 the hourly `xs2rust-endor-press` leaked **356 orphaned
processes** (four `endor-xst` pegging cores up to 15.5h + a 344-proc `endor`/
`manager-node.js` daemon tree) because the reaper poisoned jobs WITHOUT killing
their spawned process tree. The maintainer hand-killed them, added a MANDATORY
per-test-`timeout` + process-group-reaping section to the press charter, RESUMED
the schedule as an interim mitigation, and asked to re-check orphans a day later.
A deterministic reaper backstop is in flight: orchestration
`xs2rust-endor-orphan-collection-fix`.

## Task
1. On THIS host, scan `/proc` for every live process whose `cwd` or `cmdline`
   references a `project-wt-xs2rust-endor-press-*` worktree (`readlink
   /proc/<pid>/cwd`, `tr '\0' ' ' </proc/<pid>/cmdline`).
2. For each, extract its originating press job (`-YYYYMMDD-HHMMSS` in the worktree
   name) and check whether that job is CURRENTLY in `jobs/doin/` (a live, watched
   handler — OK) or not (ORPHAN: reaped/poisoned but still running).
3. Note which host you are and whether you serve local qwen (the press runs on
   qwen hosts). If you are NOT the leader/primary-qwen host, say so and recommend
   the maintainer also check the leader host directly.
4. Check the backstop: has `fix-handler-reap-spawned-process-group` reached
   `jobs/tada/`, and is it deployed to the root?

## Report to the maintainer (`scripts/jobs/message-user.sh <your-base>`)
- ORPHAN COUNT under NON-`doin/` press worktrees, broken down by job, with the
  oldest `etime` and any `endor-xst` pegging CPU.
- Backstop fix status (landed? deployed?).
- **Verdict:** GREEN — "0 orphans, charter mitigation holding" — or RED —
  "orphans recurring: N procs, oldest Xh" with the remedy (land+deploy the reaper
  fix; consider re-pausing the schedule). Include the raw evidence (counts).
