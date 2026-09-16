---
created: 2026-05-13
updated: 2026-09-16
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

# Merge-base pinning: is the PR's base a pinned <base>-<sha> snapshot, and is the
# ahead-count within the intended delta? One deterministic probe covers both.
scripts/jobs/gardening/assert-pinned-base.sh pr <owner>/<repo> <N>
case $? in
  0) pin=ok ;;
  4) pin=inconclusive ;;        # gh/parse failure; never report this as clean
  5) pin=unpinned-base ;;       # floating master/llm/main
  6) pin=wide-entrained-delta ;;# far more commits than the intended change
  *) pin=sensor-error ;;
esac
```

## Categories

- **green**: `behind == 0` and `merges == 0`. Already perfectly stacked.
- **needs-rebase**: `behind > 0` and `conflicts == clean`. A `git rebase <base>` would land cleanly.
- **needs-rebase-with-conflicts**: `behind > 0` and `conflicts == conflicts`. Author must resolve.
- **has-merge-commits**: `merges > 0`. The author merged base into branch instead of rebasing.
- **base-not-on-remote**: the base branch doesn't exist on the audit remote (a stacked-PR scenario whose parent merged or closed).
- **unpinned-base**: the PR's `baseRefName` is a **floating** trunk (`master` / `llm`
  / `main`) rather than a pinned `<base>-<sha>` snapshot — the `merge-base-pinning`
  miss (review-misses/clusters/merge-base-pinning.md; endojs/endo-but-for-bots
  #719 / #836). Such a PR drifts with the trunk and reviews at the wrong merge base;
  the remedy is a `pin the merge base #N` weave, not a plain rebase. The
  deterministic `scripts/jobs/gardening/assert-pinned-base.sh pr <repo> <N>` is the
  per-PR probe (exit 5 = floating base).
- **wide-entrained-delta**: `ahead` is far larger than the PR's intended change —
  the tell of a rebase re-parented onto a moving branch that dragged in unrelated
  commits (#831's "79 commits entrained"). `assert-pinned-base.sh` flags it (exit
  6) above `GARDEN_PIN_MAX_AHEAD`; treat it as a candidate for a from-pinned-base
  restack, not a routine rebase.
- **inconclusive** / **sensor-error**: the probe could not establish branch
  hygiene. Do not classify the PR as green; retry the probe and report the read or
  sensor failure if it persists.

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
