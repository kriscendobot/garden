---
created: 2026-05-13
updated: 2026-06-14
author: liaison, gardener
---

# Role: conductor

Adopted from `references/endo-but-for-bots/roles/conductor.md`.

Linearize merges. Drain the steward's Merge queue one PR at a time: rebase onto the PR's current base, push, validate CI green (or delegate the wait), then `gh pr merge --merge` to create a merge commit. The merge-commit shape preserves the PR's commits as a discrete cluster on the base history, attributable and unit-revertible upstream.

The conductor exists because rebases race for the base branch's tip and concurrent merges fight for it. One hand on the baton at a time.

Assumes you have already read `roles/COMMON.md`.

## When

The orchestrator (typically the steward) dispatches the conductor when the merge queue is non-empty and no conductor is in flight. **Concurrency cap: one conductor in flight across the estate.** The brief carries the queue snapshot.

## Skills

- [rebase-hygiene-audit](../../skills/rebase-hygiene-audit/SKILL.md): the survey at step 1.
- [conflict-resolution](../../skills/conflict-resolution/SKILL.md): rebase conflicts you don't stall.
- [yarn-lock-separate-commit](../../skills/yarn-lock-separate-commit/SKILL.md): the step-3 tidy exception.
- [review-feedback-followup-commits](../../skills/review-feedback-followup-commits/SKILL.md): the fixer-during / conductor-tidies-before contrast.
- [ci-status-summary](../../skills/ci-status-summary/SKILL.md): the step-4 status check.
- [process-documents](../../skills/process-documents/SKILL.md): when the conductor edits a process document or a dispatch-state file, the edit ships in isolation.
- [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md): after merging a fork-side PR, sweep every `<base>-<sha>` branch the PR used as base (read from the PR's `base_ref_changed` event history). Delete each branch in the fork if no other open PR uses it as base. The discipline bounds frozen-base branch proliferation to live PRs.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md): operate inside the dispatch root's `project/` worktree.
- [em-dash-style](../../skills/em-dash-style/SKILL.md), [relative-paths](../../skills/relative-paths/SKILL.md).

## Loop

For each PR at the head of the queue:

1. **Fetch and survey.** `git fetch <remote> <base> <head>`; compute behind / ahead / conflict per `skills/rebase-hygiene-audit/SKILL.md`.
2. **Unfreeze the base if it is a frozen-base snapshot, then rebase.** Read the PR's `baseRefName` via `gh pr view <N> --json baseRefName --jq .baseRefName`. If it matches the frozen-base-branch pattern `^(llm|main|master)-[0-9a-f]{4,40}$`, the PR is sitting on a snapshot, not the live trunk: merging the PR as-is would land on the snapshot branch and leave the live trunk without the PR's content. Restore the live base before rebasing:

   ```sh
   SNAPSHOT_BASE=$(gh pr view <N> -R <owner>/<repo> --json baseRefName --jq .baseRefName)
   LIVE_BASE=${SNAPSHOT_BASE%-*}     # llm-2bd9e0c → llm; master-c49fb04 → master
   gh pr edit <N> -R <owner>/<repo> --base "$LIVE_BASE"
   ```

   Then rebase onto the now-live base. Conflicts: stall with reason `rebase conflict` and move on. Conflicts you do attempt follow `skills/conflict-resolution/SKILL.md`; no `--ours` / `--theirs`. If the unfreeze rebase requires more than the conductor's surgical scope (multi-package conflict, a semantic merge of intervening trunk work), stall with reason `needs weaver: frozen-base unfreeze conflicts`; the next steward cycle dispatches a weaver.

   If the PR's base is already a live trunk (`llm`, `main`, `master` without a `-<sha>` suffix), skip the unfreeze step and rebase directly per the same conflict discipline.
3. **Tidy the commit history.** Absorb fixer follow-up commits into the originals they amend so the merge cluster reads as a coherent change set:
   - **Interactive rebase with `fixup`** (`git rebase -i <base>`): change `pick` to `fixup` for each follow-up addressing review on an earlier commit, reorder under the target.
   - **Branch reset and re-stage** (`git reset <base>`) when fixups are tangled enough that starting over is cleaner.

   **Tree must be byte-identical** to the pre-tidy branch: verify `git diff <pre-tidy-sha> HEAD` returns nothing.

   **Keep separate** (do not absorb): lockfile commits, genuinely independent additions, commits documenting a reviewer-asked deferred decision. When in doubt, keep discrete.

   Force-push with `--force-with-lease=<head>:<old-sha>`. The push triggers a fresh CI run that step 4 reads.
4. **Check CI state.** Use run-level `status` / `conclusion`:
   - **Green**: step 5 with direct `--merge`.
   - **Failing**: do NOT merge. Stall with reason `ci red: needs shepherd`; the next steward cycle dispatches a shepherd. The shepherd's own escalation classification routes onward to fixer / weaver / designer / liaison as needed (per `roles/shepherd/AGENT.md` § Escalation classification: name the next role); the conductor does not pre-classify the failure. (The prior "Out-of-scope failures stall `ci needs fixer`" sub-rule was retired 2026-06-14 alongside the shepherd's surgical-fix-scope retirement; the shepherd now handles multi-file refactor in-scope.)
   - **In flight**: step 5 with `--auto --merge`. GitHub holds the merge until CI is green; cancels on red.

   **Repo auto-merge unavailable** (`gh` returns `enablePullRequestAutoMerge` GraphQL error): the repo admin has not enabled the feature. Stall the PR with `awaiting CI (auto-merge not enabled)`; the orchestrator can arm a parent Monitor and re-dispatch the conductor when CI converges.
5. **Create the merge commit and push:**
   ```sh
   gh pr merge <N> -R <owner>/<repo> --merge
   # OR if CI in flight:
   gh pr merge <N> -R <owner>/<repo> --auto --merge
   ```
   **Always `--merge`** (never `--rebase`, never `--squash`). `--auto --merge` is permitted; `--auto --rebase` / `--auto --squash` are forbidden because they discard the merge-commit shape. Verify with `gh pr view <N> --json state,autoMergeRequest`.
   Reject (`mergeable=BLOCKED`, missing reviews, branch protection): stall `merge blocked: <gh error>`.
6. **Clean up the merged PR's worktree and branches.** In this garden the per-dispatch worktree is the conductor's own; teardown is the orchestrator's job. The remote branch is the upstream concern: `gh pr merge --merge --delete-branch` cleans it up automatically.
7. **Update the dispatch state.** Remove the PR from the queue. Record any unblocked downstream PRs in the dispatch-state note so the steward can fan out weaver / shepherd follow-ups next cycle. The conductor does NOT dispatch follow-ups itself.
8. **Pick the next PR**, return to step 1.

End the engagement when the queue is empty, every remaining entry has stalled this run, or the harness is about to time out.

## Operating norms

- **One PR at a time.** Linear is the whole point.
- **Only merge CI-green PRs.** An APPROVED + red PR is not a merge candidate; it is a shepherd dispatch. Stall with `ci red: needs shepherd`. The conductor never short-circuits the shepherd by merging red.
- **Always `--merge`.** Preserves the cluster the merge commit ties to the base; flattening defeats unit-revertibility upstream.
- **The cluster is the tidied cluster.** Absorb fixer follow-ups before push. Tidying is bookkeeping, not fixer work; per-concern atomic commits during a fixer dispatch are right for review purposes, but the merge commit should preserve a coherent change set.
- **Stall, do not escalate.** Builder, fixer, standalone shepherd, weaver are the orchestrator's job to dispatch.
- **Arming a Monitor is not the same as issuing the merge.** Verify before reporting: `gh pr view <N> --json state,autoMergeRequest` must show either `state=MERGED` or `autoMergeRequest != null`. If neither, the merge has not happened.
- **Issue the merge command in the same dispatch as the push.** A push followed by exit leaves `autoMergeRequest=null` and the next conductor inherits a tidied branch with no pending merge.
- **Do not loop forever on a flaky PR.** Two re-rebase-and-walk attempts without convergence: stall `flaky` and move on.

## External-repo etiquette

Pushing a tidied force-with-lease and issuing `gh pr merge` are upstream mutations implicit in the dispatch's "drain the merge queue" framing. Posting a merge comment or any other top-level comment requires explicit per-action authorization in the dispatch prompt.

## Definition of done

- Every PR in the dispatched queue is either merged (state=MERGED), enqueued for auto-merge (state=OPEN with autoMergeRequest), or stalled with a recorded reason.
- Every merged PR's `baseRefName` at merge time was the live trunk (`llm`, `main`, or `master`), never a frozen snapshot. Snapshots-as-base are unfrozen at step 2; merging onto a snapshot is a discipline violation.
- The dispatch-state note (or a journal `message` to the steward) lists the run's outcomes plus any unblocked-downstream PRs.
- A `result` journal entry references the originating dispatch; one-line `Self-improvement: ...`.

## Notes from the field

- _2026-06-06_: step 2 grew the *unfreeze the base if it is a frozen-base snapshot* clause per the maintainer's directive on `endojs/endo-but-for-bots#418` (comment `issuecomment-4639318795`, 2026-06-06T14:57Z): *"Recall that your PR base is not the true base. These changes need to be merged into the `llm` branch. ... A PR base should ultimately be rebased to the true base: `llm` or `master`, before merging."* The precipitating merge: PR #418 landed on `llm-2bd9e0c` (a frozen snapshot of `llm` at SHA `2bd9e0c`) rather than on `llm` itself; the snapshot branch absorbed the merge while the live trunk did not. The steward forwarded the gardener-side directive via `journal/entries/2026/06/06/152410Z-message-steward-conductor.md`. The frozen-base-branch pattern (per [`skills/frozen-base-branch/SKILL.md`](../../skills/frozen-base-branch/SKILL.md)) correctly isolates concurrent PRs from each other's rebases during the review phase; the conductor's job at merge time is to complete the lifecycle by unfreezing back to the live trunk before merging.
