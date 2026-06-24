---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: rebase-before-followup

Always rebase the PR branch onto its current base before pushing a fix-up commit. A PR that lags its base risks "behind master" status and CI runs against stale dependency versions.

Consumed by the fixer/followup step of the gardening state machine ([`scripts/jobs/gardening/garden-pr.sh`](../../scripts/jobs/gardening/garden-pr.sh); design [`../../designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)): before that step applies and pushes review-feedback fix-ups, it rebases onto the current base. The state machine's rebase stage senses whether the base moved and decides whether to rebase; this skill is the discipline that stage and any hand-applied followup both follow.

## When to use

Before any follow-up push on an open PR: review-feedback fix-ups, weave/rebase passes, builder corrections.

## Procedure

```sh
git fetch <remote> <base>             # e.g. bots-ssh master
git switch -c <followup-slug>         # working branch from current PR head
git rebase <remote>/<base>            # resolves linearly if no conflicts
# apply review fixes
git commit -m "fix(pkg): address review on ... (#NNNN)"
git push --force-with-lease <remote> HEAD:<original-branch-name>
```

`--force-with-lease` (not `--force`) refuses to overwrite work pushed since the agent's last fetch. If the lease is rejected, fetch again and re-rebase.

## Pitfalls

- **Never `--ours` / `--theirs`.** See [`../conflict-resolution/SKILL.md`](../conflict-resolution/SKILL.md).
- **Silent commit drops.** If the PR branch contains commits that landed independently on the base, the rebase will skip them. Verify the rebased diff still represents the PR's intent.
- **Workflow scope.** A token lacking the `workflow` scope rejects a rebase that touches `.github/workflows/*`. Push via SSH instead.
- **Switching base branches** (e.g. `llm` to `master`) can surface `modify/delete` conflicts on infrastructure files that exist only on the old base. `git rebase --skip` for the bot-side-only commits, then verify with `git diff --name-only <new-base>..HEAD` that the remaining files belong on the new base.
- **Cross-base rebase requires `--onto`, not bare `git rebase <new-base>`.** Plain `git rebase actual/master` replays every commit between the new base and HEAD (hundreds of commits from the old base's history). Use the explicit form:

  ```sh
  git rebase --onto <new-base> <old-base> HEAD
  ```

  to replay only the PR's own commits.
- **Byte-identical duplicate commits auto-skip only for cumulative trees.** When the new base contains `A; A'` and the rebased branch carries patch-id-equivalent `B; B'`, `git rebase` replays them one at a time. `B` (the draft) does not match the new base's final version `A'` and surfaces as a conflict. Either `git rebase -i` and `drop` the duplicates after confirming the cumulative tree matches, or accept the new base's content for each conflict and let the second commit empty out.

## Notes from the field

- _2026-05-13_: adopted from the reference. PR-specific session lore (PRs 27, 58, 59, 71, 72, 75, 114, 155) lives in the journal, not here. A working-mirror master-sync sub-stage was in the reference; surface it as a project-specific journal entry if and when this garden needs it.
