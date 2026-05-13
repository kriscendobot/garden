---
ts: 2026-05-13T21:19:36Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo
    pr: 1967
    role: source
---

# Dispatch: builder mirrors endojs/endo#1967 into endo-but-for-bots

Dispatch root: `dispatches/builder--mirror-endo-1967--20260513-211935--c57714/`. First stage of a multi-stage chain (builder mirror → weaver rebase → shepherd CI watch). The maintainer wants to evaluate whether the test in #1967 passes locally and in CI.

Task: mirror `https://github.com/endojs/endo/pull/1967` as a draft PR on `endojs/endo-but-for-bots` (kriscendobot has direct push to that repo). The base branch is `master` for endo-but-for-bots (mirroring an endo PR; the llm branch is where ongoing garden dev lives, but the test in #1967 was authored against endo's master and should run against endo-but-for-bots' master for direct comparability).

Procedure:

1. Bare clone at `worktrees/endojs-endo.git/` (already exists; upstream endo). Bare clone at `worktrees/endojs-endo-but-for-bots.git/` (already exists; this is the dispatch's project worktree's source). In your project worktree (checked out at `endo-but-for-bots@master`), add `https://github.com/endojs/endo.git` as remote `endo-upstream` if needed.
2. Read `endojs/endo#1967`: `gh pr view 1967 -R endojs/endo --json headRefOid,headRefName,headRepositoryOwner,baseRefName,title,body`.
3. Fetch the head SHA from endo-upstream: `git fetch endo-upstream <head-sha>`.
4. Compute the diff `<merge-base>..<head>` from endo's perspective and apply via `git apply --index` onto a new branch `mirror/endo-1967` based off endo-but-for-bots' `master`. Squash by default.
5. Identity kriscendobot; verify clean (no `Co-authored-by`, no Claude trailers).
6. Push: `git push origin mirror/endo-1967:refs/heads/mirror/endo-1967` (origin in your project worktree is `endojs/endo-but-for-bots`; kriscendobot has direct push).
7. Open draft PR: `gh pr create -R endojs/endo-but-for-bots --draft --base master --head mirror/endo-1967 --title "mirror: endojs/endo#1967 (<original-title>)" --body "<brief body naming the source PR; says 'evaluation only, do not merge'>"`. Mention in the body that the maintainer wants to evaluate whether the test passes locally and in CI; CI results will land via a follow-up shepherd dispatch.

Stretch (if the diff doesn't apply cleanly because of divergent histories): stop and report. Do NOT speculatively fix conflicts; the weaver dispatch (follow-up) is the proper home for that work.

Out of scope:
- Do not run CI watchers; shepherd handles that.
- Do not rebase if the diff doesn't apply cleanly; that is weaver work.
- Do not touch the upstream endo PR.

Report: draft PR URL, mirror branch head SHA, one-paragraph diff summary, **and** an explicit "applied cleanly" vs "conflict at <files>" verdict so the orchestrator knows whether weaver is the next stage or shepherd is.
