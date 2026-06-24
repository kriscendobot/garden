---
ts: 2026-05-22T01:19:42Z
kind: result
role: conductor
repo: endojs/endo-but-for-bots
project: endo
---

PR #327 (`docs(designs): daemon mount and git capability plans`,
0xpatrickbot, base `llm`) was already MERGED at 2026-05-22T01:18:03Z by
0xpatrickdev directly (merge commit `b67ef3d9d03f77e7867a1e5c116140b5f20cf3d0`,
method `--merge`) by the time this conductor dispatch fetched the PR state.
0xpatrickdev's APPROVED review (id 4341777494, 2026-05-22T01:15:18Z) and
the upstream merge action happened in parallel with the dispatch
preparation, so the merge had occurred ~99 seconds before the conductor
read `gh pr view`. The conductor did not need to (and could not) re-issue
`gh pr merge`.

**Branch cleanup.** The merge did not auto-delete `pc-daemon-mount-git-designs`
on the remote. The conductor deleted the ref via
`gh api .../git/refs/heads/pc-daemon-mount-git-designs -X DELETE`.

**Stacked PR #339 collateral.** Deleting the base branch immediately closed
PR #339 (`feat(daemon): complete EndoMount and specialize as Directory
(Phases 1–5)`, base was `pc-daemon-mount-git-designs`). GitHub refuses to
reopen a PR whose base ref is missing and refuses to re-target a closed PR.
The conductor recovered by:

1. Recreating the `pc-daemon-mount-git-designs` ref at the same SHA
   `0b0e64ce5d0f9fb430ce28be0c7f3133a3f1c3b0`.
2. `gh pr reopen 339` (succeeded).
3. `gh pr edit 339 --base llm` (succeeded; new base is `llm`).
4. Re-deleting `pc-daemon-mount-git-designs` (the ref now has no PR
   referent and is genuinely stale).

Final state for #339: OPEN, base=`llm`, head=`pc-daemon-mount-capabilities`,
mergeable=MERGEABLE, mergeStateStatus=UNSTABLE (the same pre-existing
zizmor workflow-audit failure that affects every PR in this repo; test,
build, lint, browser-tests all SUCCESS on PR #327's run).

**Follow-up for the orchestrator.** PR #339 now bases on `llm` and likely
needs a weaver to rebase its commits onto the new tip (the merge commit
`b67ef3d9d` introduced new history not in the stacked branch). Conductor
does not dispatch follow-ups; surfacing here for the steward / general-contractor
next cycle.

Lessons logged in this entry that future conductors should heed:

- **Verify PR state at the start of every dispatch.** A "merge PR #N"
  dispatch can race with the actual maintainer merging by hand. Read
  `gh pr view --json state,mergedAt,mergeCommit` first; if state=MERGED,
  pivot to branch-cleanup-only.
- **Branch deletion has stacked-PR collateral.** Deleting a base branch
  closes any open PR that targets it. If a stacked downstream PR exists
  (named in the dispatch or discovered via `gh pr list --base <branch>`),
  re-target the downstream PR to the new base *before* deleting the
  merged branch, not after. The recover-by-recreating-the-ref dance works
  but burns extra GitHub API calls.

Self-improvement: the two lessons above (verify-state-first and
re-target-before-delete) are worth a `message` to `liaison` for the
conductor role file. Filing separately.
