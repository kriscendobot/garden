---
ts: 2026-05-13T21:19:36Z
kind: dispatch
role: liaison
project: xsnap-pub
to: "*"
prs:
  - repo: agoric-labs/xsnap-pub
    pr: 50
    role: source
---

# Dispatch: builder mirrors agoric-labs/xsnap-pub#50 to kriscendobot/xsnap-pub

Dispatch root: `dispatches/builder--mirror-xsnap-pr-50--20260513-211935--11aaf7/`. First builder engagement since the role landed; the per-PR-flow draft discipline (per `skills/pr-creation-flow/SKILL.md`) applies.

Task: mirror `https://github.com/agoric-labs/xsnap-pub/pull/50` into our fork `kriscendobot/xsnap-pub`. Bring the PR's diff over as a topic branch on the fork, open a **draft** PR on the fork (or against upstream — pick whichever fits the maintainer's evaluation purpose, see below).

The maintainer's framing: this mirror is so we can validate the PR's content against our usage of xsnap as a submodule in endo and agoric-sdk. The mirror itself does not need to be filed upstream; opening a draft PR on `kriscendobot/xsnap-pub` (base: `master`, head: a `mirror/pr-50` topic branch) is sufficient. The draft state lets the integration builders (next dispatches, coming after this one returns) point their submodule pins at the branch.

Procedure:

1. Bare clone at `worktrees/agoric-labs-xsnap-pub.git/` (upstream); fork at `kriscendobot/xsnap-pub` (already created). Add `kriscendobot/xsnap-pub` as a remote in your project worktree if not present.
2. Read `agoric-labs/xsnap-pub#50`: `gh pr view 50 -R agoric-labs/xsnap-pub --json headRepositoryOwner,headRefName,headRefOid,title,body,baseRefName`. The head may live on a contributor's fork; the SHA is what matters.
3. Fetch the head SHA: `git fetch <contributor-fork-or-upstream> <head-sha>`.
4. Create the mirror branch off the same merge base as the upstream PR: `git checkout -b mirror/pr-50 <merge-base>`, then `git cherry-pick <each-commit>` or `git diff <merge-base>..<head> | git apply --index` for a squashed mirror. Default: squash via apply, to keep history simple.
5. Identity: kriscendobot. Verify with `git log --pretty=fuller` that author + committer are kriscendobot; no `Co-authored-by`, no `Generated with [Claude Code]` trailers.
6. Push: `git push kriscendobot mirror/pr-50:refs/heads/mirror/pr-50`. The fork name is `kriscendobot/xsnap-pub`.
7. Open draft PR on the fork: `gh pr create -R kriscendobot/xsnap-pub --draft --base master --head mirror/pr-50 --title "mirror: agoric-labs/xsnap-pub#50 (<original-title>)" --body "<brief body naming the source PR; no oblique-reference constraints here, agoric-labs/xsnap-pub is in scope>"`.
8. Per `skills/pr-creation-flow/SKILL.md`: the PR opens in **draft**. The cleaner moves it out of draft after CI; for this mirror, the maintainer drives evaluation directly.

Out of scope:
- Do not file the mirror against `agoric-labs/xsnap-pub` upstream.
- Do not touch endo, agoric-sdk, or other projects in this dispatch.
- Do not run CI watchers; that is the shepherd's job in a follow-up dispatch.

Report: PR URL, commit SHA of the mirrored branch's head, file count + line stats, one-line self-improvement.

Follow-up (not this dispatch): the orchestrator will then fire two builder dispatches (one against endo, one against agoric-sdk) to bump the xsnap submodule pin to the mirrored branch and validate CI on each fork.
