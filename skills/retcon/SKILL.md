---
created: 2026-05-14
updated: 2026-06-24
author: gardener
---

# Skill: retcon

Reset a PR's branch to its base and restage the same net diff as a sensibly grouped commit history. The PR's diff is unchanged; only the commit grouping changes. The verb is the maintainer's: *"retcon"* = retroactively continuity-fix the branch's commit history.

A retcon runs as a **job**. The triager maps a maintainer's "retcon #N" PR-comment directive to a job posted on the board ([`../job-board/SKILL.md`](../job-board/SKILL.md)); a gardener claims it and runs the retcon as the fixer step of the gardening state machine ([`scripts/jobs/gardening/garden-pr.sh`](../../scripts/jobs/gardening/garden-pr.sh); design [`../../designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)). The retcon is the orthogonal operation of regrouping commits without moving the base; rebase-onto-current-base is the separate weave/rebase step, posted by the triager's "weave #N" / "rebase #N" directive.

## When to use

- A maintainer says "retcon #N" or "please retcon this branch" on a PR. The triager turns that directive into a retcon job; the verb names this procedure.
- A PR's commit history grew sprawling during the panel-fixer loop (one commit per fixer round, intermediate work-in-progress commits, lockfile churn interleaved with code).
- Pre-ferry: the upstream is reviewing commit-by-commit and the bot-side history is not in shape for that. Retcon, then ferry.

The retcon is **not** a rebase onto a new base. If the branch lags its base, run the weave/rebase step first (or chain "weave then retcon"). Retcon assumes the base is current.

## What the retcon produces

A linear history on the PR branch with commits grouped as:

- **One commit per affected package.** Changes under `packages/foo/` ship in one commit; changes under `packages/bar/` ship in another. Conventional-commit message scoped to the package (`feat(foo): ...`, `fix(bar): ...`, etc.).
- **One `chore: Update yarn.lock` commit** for the lockfile, separate from any `package.json` commit that caused it. The [yarn-lock-separate-commit](../yarn-lock-separate-commit/SKILL.md) discipline is *applied retroactively* here across the whole branch, not commit-by-commit at write time.
- **Implementation and tests in the same commit.** A package's behavior change and the tests covering that change ship together. This is a deliberate departure from the "test, then implement" or "implement, then test" patterns that produce two commits per feature; the retcon wants one.
- **Conventional-commit messages** on every commit. The first line is `<type>(<scope>): <imperative summary>`; the body (when present) names *why*, not the diff.

The PR's net diff (the merge result) is byte-identical before and after the retcon. The panel re-runs against the new commit shape: each per-package commit gets its own scope of attention rather than the panel having to mentally re-group sprawling history.

## Procedure

Run inside the PR's project worktree on its head branch ([`../worktree-per-pr/SKILL.md`](../worktree-per-pr/SKILL.md)). The branch must be up to date with its base; if not, run a weave/rebase first.

```sh
# 0. Sanity: confirm the working tree is clean and the branch tip matches the
#    remote we'll push to.
git -C project status --porcelain     # must be empty
git -C project log --oneline origin/<head-branch>..HEAD   # must be empty

# 1. Identify the base. For a PR, this is the base branch named in the PR's
#    metadata (typically master or main, or llm for design-roadmap PRs).
BASE=$(gh pr view <N> -R <owner>/<repo> --json baseRefName --jq '.baseRefName')

# 2. Reset to the base, keeping the net diff as a working-tree state.
#    --mixed (the default) unstages everything; --soft keeps the index. Use
#    --mixed so the next step's `git add` is deliberate.
git -C project reset --mixed origin/$BASE

# 3. Restage by package. For each affected package, add the package's files
#    and commit with a conventional-commit message.
git -C project add packages/foo/
git -C project commit -m "feat(foo): <one-line summary>"

git -C project add packages/bar/
git -C project commit -m "fix(bar): <one-line summary>"

# (... one commit per affected package, implementation+tests bundled ...)

# 4. Stage and commit the lockfile last, separate from any package commit.
git -C project add yarn.lock
git -C project commit -m "chore: Update yarn.lock"

# 5. Confirm the net diff is unchanged.
git -C project diff origin/$BASE..HEAD --stat   # compare to the pre-retcon diff
git -C project diff <pre-retcon-sha>..HEAD       # must be empty (no net change)

# 6. Force-push with --force-with-lease.
git -C project push --force-with-lease origin HEAD:<head-branch>
```

The `--force-with-lease` (not `--force`) refuses to overwrite work pushed since the agent's last fetch; if the lease is rejected, fetch again and abort the retcon rather than clobbering concurrent work.

### Save a pre-retcon reference

Before step 2, tag (or note) the pre-retcon tip so the no-net-change verification in step 5 has something to diff against. `git tag pre-retcon-<short-id> HEAD` works locally; delete the tag after the push lands.

### Capture grouping decisions

When the branch's changes do not map cleanly to a per-package commit (a cross-package refactor, a touch in a top-level config file), name the groupings in the job's completion report so the panel and the maintainer can read the new history as a deliberate shape rather than guessing. Typical buckets when a per-package split does not exhaust the diff:

- **Top-level config or build changes.** One commit, `chore: <summary>` or `build: <summary>`.
- **Cross-package refactors that have to land atomically.** One commit covering all packages it touches, `refactor(<area>): <summary>`. The "area" names the conceptual change, not a single package.
- **Documentation-only files (READMEs, design notes).** One commit, `docs: <summary>` or `docs(<scope>): <summary>` when scoped.

## Net diff is invariant

The single load-bearing property of a retcon: the PR's net diff (base ... new head) is byte-identical to the PR's pre-retcon diff (base ... pre-retcon head). The retcon changes commit grouping; it does not change what the PR proposes to merge. Step 5's two diffs verify this:

- `git diff origin/$BASE..HEAD --stat` against the pre-retcon stat: same files, same line counts.
- `git diff <pre-retcon-sha>..HEAD`: empty. The two heads have the same tree.

If either check fails, the retcon went wrong; do not push. Roll back with `git reset --hard <pre-retcon-sha>` and start over.

## Output

A force-pushed, regrouped PR branch with an invariant net diff, plus a completion report (via the job board's `complete-job.sh`) naming the new commit groupings. Any grouping decision that departed from one-commit-per-package is called out in that report.

## Notes from the field

- _2026-05-14_: the verb landed when kriskowal said *"A new verb I would like to use is 'retcon' meaning 'Please reset this branch and restage the changes in sensibly grouped commits. This should generally have a single commit for each affected package, a separate commit for chore: Update yarn.lock, conventional-commit messages, and a single implementation and test commit.'"* The directive bundles three disciplines (per-package grouping, lockfile separation, implementation+tests together) that the garden had as separate skills or norms; the retcon names the procedure that applies all three at once to a branch's full history.

## Pitfalls

- **Forgetting the pre-retcon tag.** Without it, step 5's no-net-change check has no reference. Tag before resetting.
- **`git reset --hard` instead of `--mixed`.** `--hard` discards the working tree and loses the net diff. Use `--mixed` (or `--soft` if you want the index preserved) so the diff stays available as unstaged changes.
- **Lockfile interleaved with a package commit.** If `git add packages/foo/` accidentally stages a lockfile that lives under that package (rare; typically lockfiles are root-level), the lockfile leaks into the package commit. Run `git status` after each `git add` and verify only the intended package's files are staged.
- **Implementation without tests, or tests without implementation.** The discipline is one commit per package containing both. A package commit with no test changes when the implementation is new behavior is wrong; either the tests live elsewhere (a cross-package test commit, separately) or the implementation is genuinely untested (a panel finding for the next round, not a retcon target).
- **Conflicting with concurrent fixer pushes.** A retcon force-pushes; if a follow-up landed since the agent's last fetch, `--force-with-lease` rejects the push. Do not override with `--force`; abort and rebase the retcon onto the new tip.
