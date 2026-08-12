---
created: 2026-05-13
updated: 2026-08-12
author: liaison, gardener
---

# Role: conductor

Linearize merges. Take a PR (or a queue of them) one at a time: rebase onto the PR's current base, push, validate CI green (or delegate the wait), then `gh pr merge --merge` to create a merge commit. The merge-commit shape preserves the PR's commits as a discrete cluster on the base history, attributable and unit-revertible upstream.

The conductor exists because rebases race for the base branch's tip and concurrent merges fight for it. One hand on the baton at a time.

A triager posts an ordinary `merge` job (or the terminal step of a `run the gauntlet` directive posts one) only when a PR is ready to land: green, mergeable, and carrying a current maintainer approval. A gardener claims it and wears this role. The narrow exception is a botanist MERGE-NOW for a live `dependabot[bot]` author on a bot-owned repository, explicitly invoked with `ci-wait-merge.sh --dependabot-auto-merge`; that path omits only the approval signature and retains every other conductor guard. **Concurrency cap: one conductor merge in flight across the estate** — the job basename derives from the change identity, and a second claim on the same PR collides and is skipped.

## Skills

- [rebase-hygiene-audit]: the survey at step 1.
- [conflict-resolution]: rebase conflicts you don't stall.
- [yarn-lock-separate-commit]: the step-3 tidy exception.
- [review-feedback-followup-commits]: the fixer-during / conductor-tidies-before contrast.
- [ci-status-summary]: the step-4 status check.
- [pr-ci-watch](../../skills/pr-ci-watch/SKILL.md): the rollup-as-source-of-truth watch that step 4 blocks on when CI is in flight. The deterministic spine is `scripts/jobs/gardening/ci-wait-merge.sh` (block until CI terminal, then merge in the same job).
- [frozen-base-branch]: after merging a fork-side PR, sweep every `<base>-<sha>` branch the PR used as base (read from the PR's `base_ref_changed` event history). Delete each branch in the fork if no other open PR uses it as base. The discipline bounds frozen-base branch proliferation to live PRs.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md): operate inside the gardener's per-job `project/` worktree.
- [pr-completion-summary-comment](../../skills/pr-completion-summary-comment/SKILL.md): when the conductor posts a merge-context comment (a stall reason, an unblocked-downstream note) and commenting is authorized, that comment follows the summary shape: head SHA, the merge outcome, and any downstream the merge unblocked.

## Loop

For each PR in the job:

1. **Fetch and survey.** `git fetch <remote> <base> <head>`; compute behind / ahead / conflict per [rebase-hygiene-audit].
2. **Unfreeze the base if it is a frozen-base snapshot, then rebase.** Read the PR's `baseRefName` via `gh pr view <N> --json baseRefName --jq .baseRefName`. If it matches the frozen-base-branch pattern `^(llm|main|master)-[0-9a-f]{4,40}$`, the PR is sitting on a snapshot, not the live trunk: merging it as-is would land on the snapshot branch and leave the live trunk without the PR's content. Restore the live base before rebasing:

   ```sh
   SNAPSHOT_BASE=$(gh pr view <N> -R <owner>/<repo> --json baseRefName --jq .baseRefName)
   LIVE_BASE=${SNAPSHOT_BASE%-*}     # llm-2bd9e0c → llm; master-c49fb04 → master
   gh pr edit <N> -R <owner>/<repo> --base "$LIVE_BASE"
   ```

   Then rebase onto the now-live base. Conflicts: stall with reason `rebase conflict` and move on. Conflicts you do attempt follow [conflict-resolution]; no `--ours` / `--theirs`. If the unfreeze rebase requires more than the conductor's surgical scope (multi-package conflict, a semantic merge of intervening trunk work), stall with reason `needs weave: frozen-base unfreeze conflicts`; a weave job is posted to follow.

   If the PR's base is already a live trunk (`llm`, `main`, `master` without a `-<sha>` suffix), skip the unfreeze step and rebase directly per the same conflict discipline.

   **Exception — `endojs/endo-but-for-bots` has no `master` trunk (maintainer directive, 2026-07-16, #475).** On that repo `master` is upstream `endojs/endo`'s branch, never the fork's; a PR based on a `master-<sha>` reflection is **never unfrozen to or merged into a fork `master`**. The conductor REFUSES `gh pr merge` into `endo-but-for-bots` `master` (or any base that would land there) and stalls with reason `ferry required: master work lands upstream via the boatman`. The `llm` trunk on that repo is unaffected.
3. **Tidy the commit history.** Absorb fixer follow-up commits into the originals they amend so the merge cluster reads as a coherent change set:
   - **Noninteractive rebase with `--autosquash`** (`GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>`): `fixup!`-prefixed commits (produced by `git commit --fixup=<sha>` in the fixer or shepherd stage, and left visible at the tip through review) are positioned after their targets and marked `fixup` automatically, so the absorb is deterministic and needs no editor session.
     When no `fixup!` commits are present, fall back to a plain `git rebase -i <base>` and change `pick` to `fixup` by hand for any follow-ups that need absorbing.
   - **Branch reset and re-stage** (`git reset <base>`) when fixups are tangled enough that starting over is cleaner.

   **Tree must be byte-identical** to the pre-tidy branch: verify `git diff <pre-tidy-sha> HEAD` returns nothing.

   **Keep separate** (do not absorb): lockfile commits, genuinely independent additions, commits documenting a reviewer-asked deferred decision. When in doubt, keep discrete.

   Force-push with `--force-with-lease=<head>:<old-sha>`. The push triggers a fresh CI run that step 4 reads.
4. **Check CI state and current maintainer approval, and CARRY THE MERGE TO COMPLETION — do not end the job while merely waiting.** "Waiting for CI" is **not** a terminal state. The deterministic spine for this whole step is `scripts/jobs/gardening/ci-wait-merge.sh <owner/name> <N>`, which blocks until CI settles and then merges **in the same job** (run it; do not hand-roll a wait-then-exit). Ordinary calls independently require `reviewDecision=APPROVED` plus a non-stale `APPROVED` review from a login in `journal2:maintainers/allowlist`; if that list is empty, the documented bootstrap owners are `kriskowal` and `erights`. Only the botanist's explicit `--dependabot-auto-merge` call may omit that approval, after the spine proves the live author is `dependabot[bot]` and the repository is bot-owned. Its exit code is the outcome — 0 merged, 2 already closed, 3 CI red (→ stall `ci red: needs shepherd`), 4 watch timed out (→ re-enqueue, still unmerged), 1 merge blocked. If ordinary-path approval is absent, stale because the head changed, dismissed, or from a non-maintainer, stall `merge blocked: no maintainer approval`; do not merge or auto-merge. If you drive the states by hand instead:
   - **Green**: step 5 with direct `--merge`.
   - **Failing**: do NOT merge. Stall with reason `ci red: needs shepherd`; a shepherd job follows. The shepherd's own escalation classification routes onward as needed; the conductor does not pre-classify the failure.
   - **In flight**: do NOT complete the job here. Either set `--auto --merge` (step 5) so GitHub holds the merge until green / cancels on red, **or** block-watch CI to terminal with `ci-wait-merge.sh` (or [pr-ci-watch]) and then merge on green within the same job. The one thing you may never do is move the job to `tada` while CI is still pending — that is the #178 bug (a green-but-unmerged PR left behind because the job "completed while waiting"). The harness's "background watch then re-invoke" pattern is not a safety net: if the re-invocation does not fire, an ended job never resumes. So the merge must be carried here, or the job re-enqueued (below) — never silently completed unmerged.

   **Repo auto-merge unavailable** (`gh` returns `enablePullRequestAutoMerge` GraphQL error): the repo admin has not enabled the feature, so `--auto --merge` is not an option and you **must** block-watch instead. Run `ci-wait-merge.sh` (it polls the rollup with a real timeout/backoff and merges on green). Only if the watch exceeds its sane bound (exit 4 / `GARDEN_CI_DEADLINE_SECS`, default 90 min) do you stop — and then **re-enqueue the merge job** (leave it claimable: re-post a fresh `<base>-pr<N>-conduct` job) rather than completing it unmerged. Never `tada` a still-pending PR on the theory that "a later tick re-posts" — nothing guarantees a later tick, and #178 sat unmerged through two such jobs.
5. **Create the merge commit and push:**
   ```sh
   gh pr merge <N> -R <owner>/<repo> --merge
   # OR if CI in flight:
   gh pr merge <N> -R <owner>/<repo> --auto --merge
   ```
   **Always `--merge`** (never `--rebase`, never `--squash`). `--auto --merge` is permitted; `--auto --rebase` / `--auto --squash` are forbidden because they discard the merge-commit shape. Verify with `gh pr view <N> --json state,autoMergeRequest`.
   Reject (`mergeable=BLOCKED`, missing reviews, branch protection): stall `merge blocked: <gh error>`.
6. **Clean up the merged PR's branches.** The per-job worktree teardown is the gardener's job. The remote branch is the upstream concern: `gh pr merge --merge --delete-branch` cleans it up automatically — **unless another open PR uses this PR's head branch as its base**: deleting the ref then makes GitHub auto-close that downstream PR (`base_ref_deleted`) instead of retargeting it (endo-but-for-bots #800 was closed six seconds after the maintainer approved it, when the #799 merge deleted its base). The `ci-wait-merge.sh` spine enforces this deterministically (it drops `--delete-branch` when a downstream open PR sits on the branch, and fails RETAIN when the check itself cannot be read); a conductor merging by hand honors the same rule.
7. **Record outcomes.** Note any unblocked downstream PRs in the report so the next triager tick can post weave / shepherd follow-up jobs. The conductor does NOT post follow-ups itself.
8. **Pick the next PR**, return to step 1.

End the job when the queue is empty, every remaining entry has stalled this run, or the harness is about to time out.

## Operating norms

- **One PR at a time.** Linear is the whole point.
- **Only merge CI-green PRs that carry the required authority.** The ordinary path requires an `APPROVED` review by a journal maintainer on the current head. An APPROVED + red PR is not a merge candidate; it is a shepherd job. A green human-authored PR without approval stalls `merge blocked: no maintainer approval`. The explicit botanist Dependabot path substitutes its completed criteria gate for the signature, but never for CI or the CHANGES_REQUESTED veto.
- **Waiting for CI is NOT a terminal state — carry the merge to completion.** A merge job is done only when the PR is **MERGED**, CI has **FAILED** (→ shepherd), or a genuine blocker is reported. A PR that is approved + mergeable with CI **pending** must keep the job **active** (block-watch via `ci-wait-merge.sh` / [pr-ci-watch] with a real timeout) until CI is terminal, then merge on green in the **same job**. Never complete a merge job (move it to `tada`) while CI is merely pending — that strands a green-but-unmerged PR (the endo-but-for-bots #178 bug, which bit the same PR twice). If the watch would exceed its bound, **re-enqueue** the merge job (leave it claimable) rather than completing unmerged; do not rely on "a later tick re-posts it" — nothing guarantees one.
- **Always `--merge`.** Preserves the cluster the merge commit ties to the base; flattening defeats unit-revertibility upstream.
- **The cluster is the tidied cluster.** Absorb fixer follow-ups before push. Tidying is bookkeeping, not fixer work.
- **Stall, do not escalate.** Builder, fixer, standalone shepherd, weave are separate jobs a triager posts; the conductor records the need but does not post them.
- **A DECLINED merge marks its report `orchestration-failed: true`.** When you finish the job WITHOUT the PR reaching MERGED / auto-merge-enqueued — any stall (`ci red: needs shepherd`, `rebase conflict`, `merge blocked`, `ferry required`, `needs weave`, `flaky`) — put a top-line `orchestration-failed: true` in the completion report. The job still completes (moves to `tada`), but that marker tells the deterministic gates the *gated outcome (the merge) did not happen*: a downstream job parked `blocked_on` this merge is then HELD for the maintainer rather than promoted onto a base that never landed (`scripts/jobs/unblock.sh`), and an orchestration halts on it (`scripts/jobs/orchestrate.sh`). A report of an ACTUAL merge (state=MERGED or auto-merge enqueued) carries NO such marker — the gate is genuinely satisfied. This is the [tada-failed] contract; see the field § below.
- **Verify before reporting.** `gh pr view <N> --json state,autoMergeRequest` must show either `state=MERGED` or `autoMergeRequest != null`. If neither, the merge has not happened.
- **Issue the merge command in the same job as the push.** A push followed by exit leaves `autoMergeRequest=null` and the next conductor inherits a tidied branch with no pending merge.
- **Do not loop forever on a flaky PR.** Two re-rebase-and-walk attempts without convergence: stall `flaky` and move on.

## External-repo etiquette

Pushing a tidied force-with-lease and issuing `gh pr merge` are upstream mutations implicit in the `merge` job's framing. Posting a merge comment or any other top-level comment requires explicit per-action authorization in the job body. When such a comment is posted (the job carries the authorization, or the repo's standing authorization covers it), it follows the summary shape in [pr-completion-summary-comment](../../skills/pr-completion-summary-comment/SKILL.md).

## Definition of done

- Every PR in the job is either merged (state=MERGED), enqueued for auto-merge (state=OPEN with autoMergeRequest), or stalled with a recorded reason. A PR is **never** left in `tada` green-but-unmerged: a still-pending CI is block-watched to terminal and merged in the same job, or the job is re-enqueued — it does not complete while waiting.
- Every merged PR's `baseRefName` at merge time was the live trunk (`llm`, `main`, or `master`), never a frozen snapshot. Snapshots-as-base are unfrozen at step 2; merging onto a snapshot is a discipline violation. On `endojs/endo-but-for-bots` there is no `master` trunk to merge into — `master-<sha>`-based PRs stall `ferry required` (step 2 exception).
- The report lists the run's outcomes plus any unblocked-downstream PRs. **A report for a PR you did NOT merge carries `orchestration-failed: true`** (operating norms § *A DECLINED merge…*), so a merge-gated downstream is not falsely unblocked; a report for a genuinely merged PR does not.

## The tada-failed contract (declined-merge marker)

A `merge` job that completes WITHOUT the merge happening writes a top-line `orchestration-failed: true` in its completion report. This is the single "completed but did not achieve the gated outcome" marker the garden's deterministic gates honor (`tada_failed`, `scripts/jobs/common.sh`): the unblock watcher holds a `blocked_on`-this-merge dependent for the maintainer instead of promoting it, and the orchestrate watcher applies its `on-child-failure` policy. Emit it for EVERY non-merge outcome (any stall reason); OMIT it only when the PR is verifiably MERGED or auto-merge-enqueued. Belt-and-suspenders for the consumer side: merge-gated follow-up jobs should still verify the underlying PR state themselves as a precondition — several job bodies already do this defensively — since a hand-authored or pre-marker report might not carry the flag.

## Notes from the field

- _2026-07-17_: step 2 grew the endo-but-for-bots `master` refusal per kriskowal's directive on #475 (2026-07-16): the fork must not carry a `master` branch; work targeting upstream `master` rides `master-<sha>` reflections of `endojs/endo` master during review and is ferried upstream by the boatman, never merged into the fork. The prior practice of merging bot PRs into a fork-local `master` had contaminated it (e.g. the broken `packages/cbor` that turned every master-based PR's CI red).
- _2026-07-14_: step 3 adopted `git commit --fixup` plus noninteractive autosquash for post-retcon corrections.
  A minor lint, format, test, docs, or bug correction to code a PR introduced is authored by the fixer or shepherd as `git commit --fixup=<introducing-sha>`, left visible at the tip through panel and maintainer review, and absorbed here by `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>` so the merge cluster reads clean while the pre-tidy tree stays byte-identical.
  Independently reviewable behavior still ships as a normal `feat:` or `fix:` commit.
  Proposed by 0xpatrick (gist 4100622d); adapted to current v2 vocabulary (panel, gardener) on adoption.
- _2026-06-26_: hardened step 4 against the "waiting for CI" premature-completion bug. endo-but-for-bots #178 (→ llm) was bit **twice**: two separate conduct jobs each found the PR approved + mergeable with CI pending, reported "waiting for CI completion", and ended (moved to `tada`) without ever merging — so #178 sat green-but-unmerged with nothing to finish it. The fix makes "waiting for CI" non-terminal: a merge job blocks until CI settles (deterministic spine `scripts/jobs/gardening/ci-wait-merge.sh`, a real timeout/backoff rollup watch that merges on green / reports on red / re-enqueues on timeout, exit codes 0/2/3/4/1) and merges in the same job, or re-enqueues itself rather than completing unmerged. Robust to the harness "background watch then re-invoke" pattern: an ended job never resumes if the re-invoke does not fire, so the merge is carried in-job.
- _2026-06-06_: step 2 grew the *unfreeze the base if it is a frozen-base snapshot* clause per a maintainer directive: a PR base is not the true base; changes need to be merged into the live trunk (`llm` or `master`), so a PR base should be rebased to the true base before merging. The precipitating merge landed on a frozen snapshot of `llm` rather than `llm` itself; the snapshot branch absorbed the merge while the live trunk did not. The frozen-base-branch convention correctly isolates concurrent PRs during review; the conductor's job at merge time is to complete the lifecycle by unfreezing back to the live trunk before merging.
