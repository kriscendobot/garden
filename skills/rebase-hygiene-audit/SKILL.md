---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: rebase-hygiene-audit

Batch audit across open PRs for "are these cleanly stacked on base?". Read-only; produces a maintainer-actionable report.

The audit feeds the weave/rebase step of the gardening state machine ([`scripts/jobs/gardening/garden-pr.sh`](../../scripts/jobs/gardening/garden-pr.sh); design [`../../designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)): a `needs-rebase` verdict is the signal that a branch's rebase stage has work to do. When the audit surfaces a PR that needs a rebase, the triager posts a "weave #N" / "rebase #N" job to the board ([`../job-board/SKILL.md`](../job-board/SKILL.md)) that a gardener claims; the audit itself stays read-only and never pushes.

## Per-PR probes

```sh
git fetch <remote> <base> <head>

mergebase=$(git merge-base <remote>/<base> <remote>/<head>)
behind=$(git rev-list --count <remote>/<head>..<remote>/<base>)
ahead=$(git rev-list --count <remote>/<base>..<remote>/<head>)
merges=$(git rev-list --count --merges <remote>/<base>..<remote>/<head>)

if git merge-tree --write-tree <remote>/<base> <remote>/<head> >/dev/null 2>&1; then
  conflicts=clean
else
  conflicts=conflicts
fi
```

## Categories

- **green**: `behind == 0` and `merges == 0`. Already perfectly stacked.
- **needs-rebase**: `behind > 0` and `conflicts == clean`. A `git rebase <base>` would land cleanly.
- **needs-rebase-with-conflicts**: `behind > 0` and `conflicts == conflicts`. Author must resolve.
- **has-merge-commits**: `merges > 0`. The author merged base into branch instead of rebasing.
- **base-not-on-remote**: the base branch doesn't exist on the audit remote (a stacked-PR scenario whose parent merged or closed).

## Bulk-fetching

60 PRs times 5 fetches each is fine; 60 times `git fetch --all` is not. Pull the list first:

```sh
gh pr list -R <owner>/<repo> --state open --limit 200 \
  --json number,baseRefName,headRefName \
  > /tmp/prs.json
```

Then `git fetch <remote> <ref1> <ref2> ...` in batches of ~50.

## Output

A markdown report grouped by category with a summary table at the top. End with 2 to 3 sentences of recommendations. Each `needs-rebase` row is a candidate for a triager-posted weave/rebase job; the report names the candidates, it does not act on them.

## Pitfalls

- **Read-only.** The audit does not push or rebase; recommendations go to the maintainer (via the liaison) and to the triager that posts the resulting jobs.
- **Long-lived feature branches with intentional merges** will read as `has-merge-commits` but should not be rebased. Flag them as anomalies in the report.
- **Stale Dependabot PRs** can be 700+ commits behind; recommend "dependabot recreate" rather than manual rebase.

## Notes from the field

- _2026-05-13_: adopted from the reference.
