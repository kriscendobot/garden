---
created: 2026-05-22
updated: 2026-06-24
author: gardener
---

# Skill: frozen-base-branch

Every PR the garden opens on a **fork** (bot or otherwise) uses a frozen base
branch named `<base>-<short-sha>` rather than directly targeting the moving
upstream branch. The frozen base is a snapshot of the upstream branch at PR-open
time, pushed to the fork. The PR's `base` field points at the snapshot; the head
branch is rebased onto the snapshot on every rebase, and the PR's `base` field
is moved to a new snapshot when a rebase job runs. Other PRs are isolated from
any one PR's rebase. Consumed by the PR-open step of the gardening state machine.

The maintainer's framing on 2026-05-22: *"the PRs we create in the
endo-but-for-bots repository, or any fork of upstream for any repository, are
suffering from the drift of the base branch... put the agents that continue work
on a pull request in control of both the base and head branch names, to reduce
coordination issues with other PRs."*

Scope: this convention applies to **fork-side PRs** the garden opens (today:
`kriscendobot/endo-but-for-bots`, `kriscendobot/agoric-sdk`, and any other bot
fork). Upstream PRs the [boatman] ferries use upstream's natural base (e.g.,
`master` on `endojs/endo`); the frozen-base discipline does **not** propagate to
upstream because the maintainer reviews against upstream's natural base.

## Naming convention

```
<base>-<7-char-short-sha>
```

Where `<base>` matches the underlying upstream branch the snapshot was taken
from:

- `master-abc1234` when the upstream base is `master`.
- `llm-abc1234` when the upstream base is `llm` (the roadmap branch on
  `endojs/endo-but-for-bots`).
- `main-abc1234` for repos whose default branch is `main`.

The `<7-char-short-sha>` is `git rev-parse --short=7 origin/<base>` at the moment
the frozen-base branch is created. Collisions at 7 chars are negligible at
typical PR volume; the convention can be tightened later if needed.

## Where each step runs

In v2 each step below is a stage in the gardening state machine
(`scripts/jobs/gardening/garden-pr.sh`) that a gardener supervises, not a
distinct dispatched role. The stages map to v1's builder/weaver/conductor as:

- **PR open** (was builder) — *Create at PR open*.
- **rebase/weave job** (was weaver) — *Rebase: move both base and head*.
- **merge job** (was conductor) — *Unfreeze before merge* + *Sweep on PR close*.
- **fixer/cleaner steps** push to the head only; they never touch the base.
- **boatman ferry job** — upstream PR uses upstream's natural base; the bot-side
  PR stays pinned to its frozen base for the fork's audit trail.

## Create at PR open

```sh
# 1. Fetch the current upstream base.
git fetch origin <base>

# 2. Compute the short SHA.
SHA7=$(git rev-parse --short=7 origin/<base>)
FROZEN_BASE="<base>-$SHA7"

# 3. Push the frozen-base branch to the fork. The bot's fork is origin's
#    `kriscendobot/...` remote (the worktree is checked out from the bot's bare
#    clone).
git push origin "refs/remotes/origin/<base>:refs/heads/$FROZEN_BASE"

# 4. Create the head branch off the frozen base. The head name follows the
#    project's existing naming (e.g., `feat/<topic>`, `fix/<issue>-<topic>`,
#    or whatever pr-formation prescribes).
git checkout -b <head-branch> "$FROZEN_BASE"

# 5. Author commits, push the head.
git add ... && git commit ...
git push origin <head-branch>

# 6. Open the PR. The `--base` is the frozen branch, not the upstream branch.
gh pr create --draft --base "$FROZEN_BASE" --head <head-branch> --title ... --body ...
```

The frozen base lives in the fork's branches namespace; it never propagates to
upstream. The `git push origin refs/remotes/origin/<base>:refs/heads/<frozen-base>`
form pushes the local view of upstream's tip without checking out the upstream
branch.

## Rebase: move both base and head

The rebase/weave job's work grows: rebasing now creates a new frozen base,
rebases the head onto it, and updates the PR's `base` field. Both refs move
together.

```sh
# Preconditions: the rebase job claimed because base has drifted
# (or kriskowal explicitly asked for a refresh via a triager `rebase #N` job).

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

# The old `<base>-<old-sha>` branch stays until PR close (see *Sweep on PR close*).
```

The discipline: every rebase produces a new frozen-base branch; the PR's `base`
is moved atomically; concurrent PRs are not affected because their `base` still
points at their own frozen branches.

When the rebase produces conflicts, the job follows
[conflict-resolution](../conflict-resolution/SKILL.md). The conflict resolution
happens against the new frozen base, not against the moving upstream tip.

## Unfreeze before merge

**Mandatory before any `gh pr merge` invocation.** A PR whose base is a
frozen-base snapshot must have its base restored to the live trunk (`llm`,
`main`, or `master`) before the merge lands. Otherwise the merge commit anchors
on the snapshot branch and the live trunk does not absorb the PR's content. The
merge job's step 2 carries the canonical procedure; the gist:

```sh
SNAPSHOT_BASE=$(gh pr view <N> -R <owner>/<repo> --json baseRefName --jq .baseRefName)
if [[ "$SNAPSHOT_BASE" =~ ^(llm|main|master)-[0-9a-f]{4,40}$ ]]; then
  LIVE_BASE=${SNAPSHOT_BASE%-*}
  gh pr edit <N> -R <owner>/<repo> --base "$LIVE_BASE"
  # then rebase the head onto the now-live base per the merge job's loop step 2
fi
```

After the unfreeze, the merge job's normal rebase-then-merge sequence runs
against the live tip. Conflicts that exceed the merge job's surgical scope stall
and re-post a `rebase`/`weave` job (frozen-base unfreeze conflicts).

The frozen-base pattern is for *isolating PR review from concurrent trunk
drift*. Merging onto a frozen snapshot is a discipline violation; the snapshot is
for the review phase only.

## Sweep on PR close

On PR merge or close, the merge/close job sweeps the frozen-base branches the PR
used:

```sh
# 1. Read the PR's base-ref history. GitHub records every base-ref change
#    as a PullRequestEvent with action='base_ref_changed'.
gh api "repos/<owner>/<name>/issues/<N>/events" \
  --jq '.[] | select(.event == "base_ref_changed") | .base_ref' \
  > /tmp/pr-<N>-bases.list

# 2. Append the final base (the PR's current baseRefName at close).
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

Other open PRs that share a frozen-base SHA with the closing PR are spared; in
practice this is rare because each PR's frozen base is unique to the moment it
was created.

## Stacked PRs

Per the 2026-05-22 decision: **each PR in a stack gets its own frozen base,
including the dependent PRs**.

The dependent PR's frozen base is a snapshot of the parent PR's head at the
dependent PR's creation time, named `<parent-head>-<short-sha>` rather than
`<base>-<short-sha>`. The shape:

```sh
# Suppose PR-A has head `feat/foo` (currently at `def5678`)
# and PR-B is being opened as stacked on PR-A.

SHA7=$(git rev-parse --short=7 feat/foo)
DEPENDENT_BASE="feat/foo-$SHA7"

git push origin "feat/foo:refs/heads/$DEPENDENT_BASE"
git checkout -b feat/foo-followup "$DEPENDENT_BASE"
git push origin feat/foo-followup
gh pr create --draft --base "$DEPENDENT_BASE" --head feat/foo-followup ...
```

Rebasing PR-A does **not** auto-shift PR-B. PR-B keeps reviewing against the
frozen snapshot of PR-A's old head until PR-B explicitly rebases (create a new
`feat/foo-<new-sha>` from PR-A's current head, rebase PR-B's head onto it, update
PR-B's base). The cost is per-stack janitorial work; the benefit is per-PR
isolation in line with the maintainer's framing.

See [stacked-pr-build](../stacked-pr-build/SKILL.md) for the broader
stack-construction discipline; this
skill's section here is the base-naming overlay.

## When the frozen-base sha collides with an existing branch

At 7-char short SHA, two PRs opened at the same upstream tip would produce the
same `<base>-<sha>` branch name. This is benign — both PRs share the frozen base
— but worth noting: the bot does **not** push if `<base>-<sha>` already exists;
it reuses the existing branch. A collision across forks (different work, same
SHA) is invisible because the bot's fork only sees its own.

## Not applicable

- **Upstream PRs after ferry.** The boatman ferries from the bot-side
  frozen-base PR to upstream; the upstream PR's base is upstream's natural branch.
- **Bot-side branches that are not PRs.** Direct pushes to `master` on the bot
  fork do not use frozen bases.
- **Per-job scratch worktrees.** Watch/integration scratches do not open PRs and
  do not use frozen bases.

## Composition with other skills

- [pr-creation-flow]: the canonical PR flow references this skill at the PR-open
  step and the rebase step.
- [pr-formation](../pr-formation/SKILL.md): head-branch naming is unchanged
  (project-specific). The base-branch naming is this skill's `<base>-<short-sha>`
  convention.
- [stacked-pr-build](../stacked-pr-build/SKILL.md): each dependent PR uses the
  per-PR frozen base shape above.
- [rebase-before-followup](../rebase-before-followup/SKILL.md): the fixer/followup
  step rebases head onto the **current** frozen base; it does not create a new
  frozen base. The rebase/weave job creates new frozen bases.
- [cherry-pick-followup](../cherry-pick-followup/SKILL.md): cherry-picks land on
  the head branch; no base-side change.
- [pr-handoff](../pr-handoff/SKILL.md) (boatman): the upstream PR is opened against
  upstream's natural base; the bot-side frozen base is not copied upstream.
- [conflict-resolution](../conflict-resolution/SKILL.md): conflicts arise during
  the rebase step against the new frozen base; the procedure does not change.

## Pitfalls

- **The bot must have push access to the fork.** The frozen-base branch lives in
  the fork's branches namespace; the bot identity needs `push` access to create
  and delete them.
- **PR templates that hardcode the base.** Override explicitly with
  `--base <base>-<sha>`.
- **GitHub's "Update branch" button.** Clicking it merges the PR's base into the
  head; the base is the frozen-base branch, so this does what we want.
- **GitHub's "rebase" merge type.** The rebase target is the PR's base (the
  frozen-base branch); per-PR isolation is preserved at merge time.
- **CI workflows keyed on `master`.** Under the frozen-base convention the base
  ref is `master-abc1234`, not `master`. Workflows may need to match with a regex
  (e.g., `^(master|master-[0-9a-f]{7})$`).
- **Branch proliferation in the fork's UI.** The sweep-on-close discipline bounds
  it to live PRs.

## Notes from the field

(Append; terse and dated.)

- _2026-05-22_: initial bootstrap. The convention landed across the PR flow and
  the builder/weaver/conductor/boatman roles.
- _2026-06-06_: added the *Unfreeze before merge* section per a maintainer
  directive on `endojs/endo-but-for-bots#418`: the merge step must unfreeze a
  snapshot base to the live trunk before invoking `gh pr merge`, otherwise the
  merge lands on the snapshot branch and the trunk does not absorb the content.
- _2026-06-24_: migrated into v2. Rewired the per-role section ownership
  (builder/weaver/conductor) into gardening-state-machine stages and triager-
  posted rebase jobs; the git mechanics are unchanged.
