---
ts: 2026-05-15T01:20:11Z
kind: dispatch
role: understudy
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: target
---

# Dispatch: fixer retcons PR #243 per kriskowal directive

Dispatch root: `/home/kris/dispatches/fixer--d61999`. Project worktree
on `endojs/endo-but-for-bots@chore/eslint-numeric-separators-style`
(detached at `bd979ce23`).

User-directed dispatch from the understudy session on `endolinbot`. The
understudy holds the same authority bounds as the steward per
`roles/understudy/AGENT.md` § Posture; user-driven directives are an
explicit handoff (the user being reachable is the lever that distinguishes
the understudy from the steward). The autonomous steward on this host
continues its own per-cycle work; this dispatch is a sibling user-driven
engagement and does not preempt it.

## Maintainer directive

Comment on PR #243 from kriskowal at 2026-05-14T23:00:53Z
([issuecomment-4455437562](https://github.com/endojs/endo-but-for-bots/pull/243#issuecomment-4455437562)):

> Please reset and redistribute into sensibly grouped commits.

That is verbatim the retcon procedure landed today as
`skills/retcon/SKILL.md` (gardener `c31b1c`). The fixer executes the
retcon against the current PR head, preserves the net diff, and
force-pushes with-lease.

## PR state at dispatch time

- Title: `chore(eslint-plugin): require underscore-delimited groups in numeric literals`.
- Branch `chore/eslint-numeric-separators-style` at `bd979ce23` (head per `gh pr view 243`).
- Base `llm`.
- State OPEN, NOT DRAFT, MERGEABLE.
- CI: 25 SUCCESS, 1 still in flight on the latest run.
- Reviews: three `COMMENTED` reviews from `kriscendobot` (panel rounds);
  the maintainer's retcon comment is the user-facing directive.

## Per-action authorization

- Force-push to `chore/eslint-numeric-separators-style` with
  `--force-with-lease` after the retcon.
- Standing comment authorization on `endo-but-for-bots`: a brief
  top-level comment naming the retcon and the pre-retcon SHA is fine.
- No reviewer re-request from this dispatch; the panel re-runs against
  the new commit shape via a separate judge dispatch (this session or
  the autonomous steward issues that next).
- No upstream ferry (this is a bots-side retcon, not a re-ferry).

## Task

Execute the retcon per `skills/retcon/SKILL.md`. The procedure:

1. Inspect the current diff to map files to packages. Identify any
   non-per-package buckets per the skill's *Capture grouping decisions*
   section (top-level config, cross-package refactors, docs).
2. Tag the pre-retcon tip locally for the no-net-change diff check.
3. `git reset --mixed origin/llm` to keep the diff as working-tree state.
4. Restage by package: one commit per affected package with a
   conventional-commit message, implementation+tests bundled.
5. Stage and commit `yarn.lock` (if any) as `chore: Update yarn.lock`.
6. Stage any non-per-package buckets per *Capture grouping decisions*.
7. Verify net diff invariant via the two diffs the skill names.
8. Force-push with `--force-with-lease`.
9. Post one brief comment on PR #243 naming the retcon and the
   pre-retcon SHA (optional but useful for the maintainer's read).

## Out of scope

- No substance changes; the PR's net diff is invariant by construction.
- No master-base mirror.
- No judge re-dispatch.
- No reviewer re-request.

## Report

≤ 400 words: new head SHA after force-push, the commit list (one line
per commit naming scope + summary), confirmation that the two
net-diff-invariant checks both pass (empty `<pre>..HEAD` diff; identical
`base..HEAD` stat), comment URL if posted, one-line
`Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
