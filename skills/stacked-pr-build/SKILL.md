---
created: 2026-05-15
updated: 2026-06-24
author: gardener
---

# Skill: stacked-pr-build

Build a PR whose base is the implementation branch with one or more in-flight PR heads merged in, so the dependent's implementation can be developed and reviewed against the actual code the deps deliver rather than against a clean base that does not yet have them. Consumed by the `build` job a gardener claims off the job board (`../job-board/SKILL.md`) when dependency triage returns the `stack-on-PRs` verdict; reusable by any gardening step facing the same dep-stack shape.

Distinct from `../pr-dependency-graph/SKILL.md` and `[pr-dependency-topo-sort]`: those skills are the *registry-read and ordering* primitives over the `journal2` dependency registry. This skill is the *operational* procedure for building on top of a stack at build time: what base to compute, how to commit, how to surface the dependence to reviewers, and how to handle the stack's heads moving.

## When to use

- A dependency-triage step returns the `stack-on-PRs` verdict and a gardener is about to run the `build` job's implementation step.
- A maintainer directive (routed via an inbox per `../message-bus/SKILL.md`, or named on the `build` job) says "build X on top of #N and #M" explicitly.
- A stale PR whose body declares `depends on #N` is adopted into a `build` job and the maintainer (or the triage step) confirms the dependency is load-bearing rather than informational.

## Inputs

- `impl_base_branch`: today `master` on `endojs/endo-but-for-bots`. The natural implementation base.
- `stack_prs`: list of `{number: <int>, head_sha: <sha>, design_path: <path>}` records. Order is the dep order returned by triage (deepest dep first; the dependency walk's `walked_chain` preserves the order).
- `seed_design_path`: the design the build is implementing. The PR's body will cite this and the stack.
- `working_branch_name`: the branch name the build will push to (e.g., `<bot-slug>--<design-slug>--stack`).
- `repo`: `<owner>/<name>` of the fork.

These ride on the `build` job's payload (the dependency walk's verdict plus the seed design); a one-off caller assembles them by hand.

## Procedure

The stack is built on a fresh local branch in the gardener's project worktree (per `../worktree-per-pr/SKILL.md`) and pushed to the fork. The PR is opened against `impl_base_branch` (not against the topmost stack PR) so the GitHub diff shows the full delta from `impl_base_branch` plus the deps' diffs plus the seed's diff. Reviewers see everything in one place; the dep PRs continue to live as their own merge units.

### 1. Prepare a clean working tree

The gardener's per-job worktree (`../dispatch-worktree/SKILL.md` / `../worktree-per-pr/SKILL.md`) holds a `project/` checkout at `impl_base_branch`. Stand in it:

```sh
cd project/
git fetch origin <impl_base_branch>
git checkout -B <working_branch_name> origin/<impl_base_branch>
```

The working branch starts at the freshest `origin/<impl_base_branch>` HEAD. The worktree's local `<impl_base_branch>` may be behind by minutes; the `git fetch` keeps the stack aligned.

### 2. Merge each stack PR's head SHA

For each `stack_pr` in order (deepest dep first):

```sh
git fetch origin pull/<number>/head:pr-<number>
git merge --no-ff pr-<number> \
  -m "stack: merge endojs/<repo>#<number> head <short-sha> (<dep-design-slug>)"
```

The `--no-ff` is load-bearing: the merge commit's first parent is the working branch's prior HEAD, the second parent is the dep PR's head. The merge commit's message names the upstream PR and the dep's design slug so a reviewer can trace the stack without leaving the PR view.

Use the SHA the dependency walk recorded, not `pr-<number>`'s current head, when the `build` job's payload was written more than five minutes before this step. The job payload is the source of truth for what the stack pinned to; if the dep PR's head has advanced since, the payload is the audit trail for what the stack actually built on. (A future `build` job that re-runs the walk and sees the new head can rebuild the stack against the new SHA; the prior build is preserved in git history.)

Resolve conflicts in line per `../conflict-resolution/SKILL.md`. The merge commit's body should record any non-trivial resolution; if the resolution exceeds the scope of a single commit message, write a follow-up commit on top of the merge that adjusts the dep's code so the stack compiles, with a commit message that explains the adjustment.

### 3. Add the seed's implementation commits

After all stack merges land, the working branch is at `impl_base_branch + dep1 + dep2 + ...`. Now commit the seed design's implementation on top, using whatever per-package commit shape `../changeset-discipline/SKILL.md` and the project's own commit-shape conventions call for.

The seed's commits should not re-touch files the stack merges introduced unless the seed genuinely needs to. Cross-cutting touches (a shared utility the dep PR introduced and the seed extends) are fine; gratuitous re-formatting of the dep's code is not.

### 4. Push the working branch

```sh
git push origin HEAD:<working_branch_name>
```

The push goes to the fork as usual; the working branch lives alongside the existing fork branches.

### 5. Open the PR against the implementation base

```sh
gh pr create -R <repo> \
  --base <impl_base_branch> \
  --head <working_branch_name> \
  --draft \
  --title "<seed-design-slug>: <one-line description>" \
  --body "$(cat <<'EOF'
Implements `<seed_design_path>`.

## Stack

This PR is built on top of:

- #<number-1> (`<dep-1-design-slug>`)
- #<number-2> (`<dep-2-design-slug>`)
- ...

The merge commits at the top of the stack pin each dep at the SHA the
dependency walk recorded. Reviewers see the full diff including the deps'
contributions; the deps' PRs continue to live as their own merge units.
When the deps merge into `<impl_base_branch>`, the PR can either be rebased
(a later gardening step reduces the stack) or merged after the deps land.

## Design

<short summary of the seed design's contract>
EOF
)"
```

The PR opens in draft state per the standard gauntlet discipline (`[pr-creation-flow]`). The scripted panel (`../panel/SKILL.md`) un-drafts when the gauntlet terminates.

### 6. Record the stack on the dependency registry

Write the stack metadata into the PR's `journal2` dependency-registry entry (the registry the `../pr-dependency-graph/SKILL.md` read side parses) so subsequent gardening steps know the PR is a stack:

```yaml
stack:
  base: <impl_base_branch>
  prs:
    - { number: <int>, head_sha: <sha> }
    - { number: <int>, head_sha: <sha> }
```

The registry entry's prose body records the dependency walk's chain.

## Maintaining the stack across gardening passes

The dep PRs continue to move while the seed's PR is in flight. The gardening state machine handles three transitions:

- **A dep PR merges.** The stack's pinned SHA is now part of `impl_base_branch`. The seed PR is fine as-is; the next rebase step (when the seed becomes `CONFLICTING` against its base, or on a maintainer-asked rebase) reduces the stack by one PR, because the dep's commits are now ancestors of `impl_base_branch`.

- **A dep PR's head advances.** New commits were pushed to the dep's PR. The seed's stack still points at the old SHA. Two options:
  - **Leave it.** The seed's PR is built on the stack snapshot; the dep's later commits don't affect the seed's review surface. The dep will land eventually and the rebase step above resolves the stack.
  - **Rebuild the stack.** If the dep's new commits include API changes the seed relies on, a rebase step rebuilds the seed against `impl_base_branch + <new-dep-head>`, following the same merge-each-pr procedure above but starting from the seed's existing branch rather than from `impl_base_branch`.

  The registry entry's `stack.prs[].head_sha` is the audit trail; the rebase step updates the pinned SHAs.

- **A dep PR is closed without merging.** The stack is broken: the dep's implementation is no longer landing, but the seed depends on it. The gardener surfaces the breakage via an inbox message (`../message-bus/SKILL.md`) and re-enters dependency triage on the seed (which now sees the dep as `dep-unstarted-design` again; the walk may redirect to `start-with-dep` or `no-actionable-design`).

## Pitfalls

- **Opening the PR against the topmost stack PR's branch.** Tempting but wrong. The PR's diff would only show the seed's own commits, hiding the stack from the reviewer. Open against `impl_base_branch`; the stack is visible as the merge commits at the top.

- **Forgetting `--no-ff`.** A fast-forward merge produces a linear history that loses the "this is a stack" signal in `git log --graph`. The merge-commit's two-parent shape is load-bearing for the reviewer and for any later bisect. Always use `--no-ff` for stack merges.

- **Resolving conflicts in the merge commit's resolution rather than in a follow-up commit.** A merge commit with a non-trivial conflict resolution embedded in it is hard to review (the merge commit's diff against either parent is the resolution, but neither view shows the diff against the *seed's* code). When the resolution is more than a one-line conflict marker fix, commit it as a separate `chore: reconcile stack with <dep>` commit on top of the merge.

- **Stacking deeper than two PRs.** Three or more PRs in a stack increases the bot's review surface and the rebase cost geometrically. The first heuristic is to redirect to `start-with-dep` when the stack would exceed two PRs; the deeper dep is built first as its own `build` job, and the seed re-enters the queue once the dep lands. The walk's recursion does this naturally (an unstarted dep at depth 2 returns `start-with-dep` for the seed, redirecting the build to the depth-2 dep directly). A maintainer override can permit a deeper stack when the deps are mature and unlikely to need further rework.

- **The dep's design naming a different `impl_base_branch`.** If the dep's design says it lands on a different base than the seed (rare, but possible during a base migration), the stack is invalid; the deps cannot be merged because their commits are on a different lineage. Surface via an inbox message.

## Output shape

A draft PR opened against `impl_base_branch` with the stack visible as `--no-ff` merge commits at the top of the branch, plus a `journal2` registry entry carrying the `stack:` block. The PR then runs the gauntlet (panel + fixer loop, `../panel/SKILL.md`).

## Notes from the field

- _2026-05-15_: skill landed as part of the original stacked-build work. The originating framing: "the builder is to implement their design based on a merge of all its dependency PRs, in a stack." The merge-each-PR approach (open against `impl_base_branch`, stack as merge commits at the top) was chosen over the "branch off the topmost stack PR" alternative because the former preserves a single-PR review surface for the reviewer; the latter would scatter the seed's review across the stack's PRs. The two-PR depth cap is a first heuristic.
- _2026-06-24_: migrated into v2. The merge-each-PR procedure is unchanged. The orchestration changed: the slot-table / general-contractor framing is replaced by a `build` job a gardener claims off the board; the slot file's `stack:` frontmatter moves to the PR's `journal2` dependency-registry entry; cross-cycle maintenance is the gardening state machine's rebase step rather than a contractor refill loop.
