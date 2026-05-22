---
created: 2026-05-22
updated: 2026-05-22
author: gardener
---

# Skill: frozen-base-branch

Every PR the garden opens on a **fork** (bot or otherwise) uses a frozen base branch named `<base>-<short-sha>` rather than directly targeting the moving upstream branch. The frozen base is a snapshot of the upstream branch at PR-open time, pushed to the fork. The PR's `base` field points at the snapshot; the head branch is rebased onto the snapshot on every rebase, and the PR's `base` field is moved to a new snapshot when the bot decides to rebase. Other PRs are isolated from any one PR's rebase.

The maintainer's framing on 2026-05-22: *"the PRs we create in the endo-but-for-bots repository, or any fork of upstream for any repository, are suffering from the drift of the base branch... put the agents that continue work on a pull request in control of both the base and head branch names, to reduce coordination issues with other PRs."*

Scope: this convention applies to **fork-side PRs** the garden opens (today: `kriscendobot/endo-but-for-bots`, `kriscendobot/agoric-sdk`, and any other bot fork). Upstream PRs the [boatman](../../roles/boatman/AGENT.md) ferries use upstream's natural base (e.g., `master` on `endojs/endo`); the frozen-base discipline does **not** propagate to upstream because the maintainer reviews against upstream's natural base.

## Naming convention

```
<base>-<7-char-short-sha>
```

Where `<base>` matches the underlying upstream branch the snapshot was taken from:

- `master-abc1234` when the upstream base is `master`.
- `llm-abc1234` when the upstream base is `llm` (the roadmap branch on `endojs/endo-but-for-bots`).
- `main-abc1234` for repos whose default branch is `main`.

The `<7-char-short-sha>` is `git rev-parse --short=7 origin/<base>` at the moment the frozen-base branch is created. Collisions at 7 chars are negligible at typical PR volume; the convention can be tightened later if needed.

## When to use

- **Builder** opens every fork-side PR with a frozen base per *Create at PR open* below.
- **Weaver** rebases an open PR by creating a new frozen base, moving the head onto it, and updating the PR's `base` field per *Rebase: move both base and head* below.
- **Conductor** (or the role that handles PR close) sweeps frozen-base branches on PR merge or close per *Sweep on PR close* below.
- **Fixer** and **Cleaner** push to the head as today; they do not touch the base. Their pushes land on whatever frozen base the PR currently uses.
- **Boatman** ferrying to upstream: the upstream PR's base is upstream's natural branch (`master`, etc.), not the bot's frozen base. The bot-side PR remains pinned to its frozen base for the bot fork's audit trail.

## Create at PR open (builder)

```sh
# 1. Fetch the current upstream base.
git fetch origin <base>

# 2. Compute the short SHA.
SHA7=$(git rev-parse --short=7 origin/<base>)
FROZEN_BASE="<base>-$SHA7"

# 3. Push the frozen-base branch to the fork. The bot's fork is origin's `kriscendobot/...`
#    remote (the worktree is checked out from the bot's bare clone).
git push origin "refs/remotes/origin/<base>:refs/heads/$FROZEN_BASE"

# 4. Create the head branch off the frozen base. The head name follows the
#    project's existing naming (e.g., `feat/<topic>`, `fix/<issue>-<topic>`,
#    or whatever the PR-formation skill prescribes).
git checkout -b <head-branch> "$FROZEN_BASE"

# 5. Author commits, push the head.
git add ... && git commit ...
git push origin <head-branch>

# 6. Open the PR. The `--base` is the frozen branch, not the upstream branch.
gh pr create --draft --base "$FROZEN_BASE" --head <head-branch> --title ... --body ...
```

The frozen base lives in the fork's branches namespace; it never propagates to upstream. The `git push origin refs/remotes/origin/<base>:refs/heads/<frozen-base>` form pushes the local view of upstream's tip without needing to check out the upstream branch.

## Rebase: move both base and head (weaver)

The weaver's job grows: rebasing now creates a new frozen base, rebases the head onto it, and updates the PR's `base` field. Both refs move together.

```sh
# Preconditions: weaver dispatched against PR #N because base has drifted
# (or kriskowal explicitly asked for a refresh).

# 1. Fetch upstream's current tip.
git fetch origin <base>

# 2. Compute the new short SHA.
NEW_SHA7=$(git rev-parse --short=7 origin/<base>)
NEW_FROZEN_BASE="<base>-$NEW_SHA7"

# 3. If the new short SHA equals the current frozen-base SHA, no rebase needed.
CURRENT_FROZEN_BASE=$(gh pr view <N> --json baseRefName --jq .baseRefName)
CURRENT_SHA7=${CURRENT_FROZEN_BASE##*-}
if [ "$NEW_SHA7" = "$CURRENT_SHA7" ]; then
  echo "Base unchanged; no rebase needed."
  exit 0
fi

# 4. Push the new frozen-base branch.
git push origin "refs/remotes/origin/<base>:refs/heads/$NEW_FROZEN_BASE"

# 5. Fetch the head, rebase onto the new frozen base, push with --force-with-lease.
HEAD_BRANCH=$(gh pr view <N> --json headRefName --jq .headRefName)
git fetch origin "$HEAD_BRANCH"
git checkout -B "$HEAD_BRANCH" "origin/$HEAD_BRANCH"
git rebase "$NEW_FROZEN_BASE"
git push --force-with-lease origin "$HEAD_BRANCH"

# 6. Update the PR's base.
gh pr edit <N> --base "$NEW_FROZEN_BASE"

# The old `<base>-<old-sha>` branch stays until PR close (see *Sweep on PR close* below).
```

The discipline: every rebase produces a new frozen-base branch; the PR's `base` is moved atomically; concurrent PRs are not affected because their `base` still points at their own frozen branches.

When the rebase produces conflicts, the weaver follows `skills/conflict-resolution/SKILL.md` as today. The conflict resolution happens against the new frozen base, not against the moving upstream tip.

## Sweep on PR close (conductor or close-handler)

On PR merge or close, the orchestrator sweeps the frozen-base branches the PR used:

```sh
# 1. Read the PR's base-ref history. GitHub records every base-ref change
#    as a PullRequestEvent with action='base_ref_changed'.
gh api "repos/<owner>/<name>/issues/<N>/events" \
  --jq '.[] | select(.event == "base_ref_changed") | .base_ref' \
  > /tmp/pr-<N>-bases.list

# 2. Append the final base (which is the PR's current baseRefName at close).
gh pr view <N> --json baseRefName --jq .baseRefName >> /tmp/pr-<N>-bases.list

# 3. Dedupe; each unique base is a frozen-base branch we created.
sort -u /tmp/pr-<N>-bases.list > /tmp/pr-<N>-bases.uniq

# 4. For each frozen-base branch, check if any other open PR uses it as base.
#    If not, delete it from the fork.
for fb in $(cat /tmp/pr-<N>-bases.uniq); do
  other_users=$(gh pr list --search "base:$fb is:open" --json number --jq 'length')
  if [ "$other_users" -eq 0 ]; then
    gh api -X DELETE "repos/<owner>/<name>/git/refs/heads/$fb" || true
  fi
done
```

The discipline: the conductor (on merge) or the close-handler (on close-without-merge) runs the sweep. Other open PRs that happen to share a frozen-base SHA with the closing PR are spared; in practice this is rare because each PR's frozen base is unique to the moment it was created.

## Stacked PRs

Per the 2026-05-22 decision: **each PR in a stack gets its own frozen base, including the dependent PRs**.

The dependent PR's frozen base is a snapshot of the parent PR's head at the dependent PR's creation time, named `<parent-head>-<short-sha>` rather than `<base>-<short-sha>`. The shape:

```sh
# Suppose PR-A has head `feat/foo` (currently at `def5678`)
# and PR-B is being opened as stacked on PR-A.

# Compute the snapshot SHA of PR-A's head.
SHA7=$(git rev-parse --short=7 feat/foo)
DEPENDENT_BASE="feat/foo-$SHA7"

# Push the dependent base to the fork.
git push origin "feat/foo:refs/heads/$DEPENDENT_BASE"

# Create PR-B's head off the dependent base.
git checkout -b feat/foo-followup "$DEPENDENT_BASE"
git push origin feat/foo-followup

# Open PR-B with `--base $DEPENDENT_BASE`.
gh pr create --draft --base "$DEPENDENT_BASE" --head feat/foo-followup ...
```

Rebasing PR-A does **not** auto-shift PR-B. PR-B keeps reviewing against the frozen snapshot of PR-A's old head until PR-B explicitly rebases (which means: create a new `feat/foo-<new-sha>` from PR-A's current head, rebase PR-B's head onto it, update PR-B's base). The cost is per-stack janitorial work; the benefit is per-PR isolation in line with the maintainer's framing.

See `skills/stacked-pr-build/SKILL.md` for the broader stack-construction discipline; this skill's section here is the base-naming overlay.

## When the frozen-base sha collides with an existing branch

At 7-char short SHA, two PRs opened at the same upstream tip would produce the same `<base>-<sha>` branch name. This is benign — both PRs share the frozen base — but worth noting: the bot does **not** push if `<base>-<sha>` already exists; it reuses the existing branch.

If a collision arises across forks (different work, same SHA), the bot's fork only sees its own; no actual conflict.

## Not applicable

- **Upstream PRs after ferry.** The boatman ferries from the bot-side frozen-base PR to upstream; the upstream PR's base is upstream's natural branch (`master`, etc.). The maintainer reviews against upstream master.
- **Bot-side branches that are not PRs.** Direct pushes to `master` on the bot fork (rare; the bot does not own the bot fork's `master`) do not use frozen bases.
- **Per-cycle scratch worktrees.** Standing monitor worktrees, integration scratches, and similar one-off workspaces do not open PRs and do not use frozen bases.

## Composition with other skills

- **`skills/pr-creation-flow/SKILL.md`**: the canonical PR flow now references this skill at the builder's "open the PR" step and the weaver's "rebase" step.
- **`skills/pr-formation/SKILL.md`**: head-branch naming is unchanged (project-specific). The base-branch naming is this skill's `<base>-<short-sha>` convention.
- **`skills/stacked-pr-build/SKILL.md`**: each dependent PR uses the per-PR frozen base shape above rather than parent-head-as-base.
- **`skills/rebase-before-followup/SKILL.md`**: fixer rebases head onto the **current** frozen base (the PR's existing base); does not create a new frozen base. The weaver creates new frozen bases.
- **`skills/cherry-pick-followup/SKILL.md`**: cherry-picks land on the head branch; no base-side change.
- **`skills/pr-handoff/SKILL.md`** (boatman): the upstream PR is opened against upstream's natural base; the bot-side frozen base is not copied upstream.
- **`skills/conflict-resolution/SKILL.md`**: conflicts arise during the rebase step against the new frozen base, exactly as today; the conflict-resolution procedure does not change.

## Pitfalls

- **The bot must have push access to the fork.** The frozen-base branch lives in the fork's branches namespace; the bot identity needs `push` access to create and delete them. On `kriscendobot/endo-but-for-bots` and `kriscendobot/agoric-sdk` this is already the case.
- **PR templates that hardcode the base.** Some projects have PR-creation tooling that defaults `--base` to upstream's natural branch. The bot must override explicitly with `--base <base>-<sha>`.
- **GitHub's "Update branch" button.** Maintainers reading a PR see GitHub's "Update branch" button which merges the PR's base into the head. The base is the frozen-base branch, not upstream — clicking the button does what we want (no-op when the head is already on the frozen base; merges if the head is somehow ahead). This is correct behavior under the new convention.
- **GitHub's "rebase" merge type.** When the maintainer (or the conductor) merges with `--rebase`, the rebase target is the PR's base (the frozen-base branch). GitHub rebases the head onto the frozen base. Per-PR isolation is preserved at merge time; the actual upstream commit sequence is whatever the frozen base + the head produced.
- **CI workflows keyed on `master`.** Some workflows use `pull_request.base.ref == 'master'` to gate behavior. Under the frozen-base convention, the base ref is `master-abc1234`, not `master`. Workflows may need to match with a regex (e.g., `^(master|master-[0-9a-f]{7})$`). The first time this trips is the time to update the workflow; not a blocker for the convention.
- **Branch proliferation in the fork's UI.** The fork's branches page will show many `<base>-<hash>` branches. This is the cost; the sweep-on-close discipline bounds it to live PRs.

## Notes from the field

(Append; terse and dated.)

- _2026-05-22_: initial bootstrap. The convention lands across all four touched skills (`pr-creation-flow`, `pr-formation`, `stacked-pr-build`, `pr-handoff`) and four touched roles (`builder`, `weaver`, `conductor`, `boatman`) on 2026-05-22. The first PR opened under the new convention is the test of the convention; expect a *Notes from the field* row tracking the first month's adoption signal (collisions, branch-proliferation pressure, CI-workflow surprises).
