---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 2
deadline_overruns: 1
doomed_at: 2026-07-17T05:03:08Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-17T05:03:08Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Merge upstream master into the endo-but-for-bots `llm` branch (propose PR -> shepherd -> conduct)

Integrate the latest upstream into `llm`: merge upstream **`master`** into the **`llm`** roadmap
branch of `endojs/endo-but-for-bots`, driving the full lifecycle — propose a PR, shepherd it to
green, and conduct it onto `llm`. "Upstream master" = the current `endojs/endo` `master` (equivalently
the fork's `origin/master` mirror of it); fetch it fresh. This is an integration merge WITHIN the
fork (mirror -> working branch); do NOT push to or recreate the mutable `master`, and no frozen-base
anchor is involved (anchors are for fork PRs of upstream-destined work, not for master->llm).

## 1. Propose the merge PR
- Work in an isolated worktree. Create an integration branch off `llm`:
  `integrate/master-into-llm-20260717`.
- Merge the current upstream `master` into it as a **true merge** (preserve history — an integration
  merge, not a rebase/squash). Resolve conflicts **faithfully**: keep `llm`'s deliberate roadmap
  divergences where they are intentional, take upstream where `llm` has no opinion; where a conflict
  is non-obvious (e.g. a package upstream overhauled that `llm` also changed), document the resolution
  in the PR rather than guessing. Update `yarn.lock` in its own commit
  (`skills/yarn-lock-separate-commit/SKILL.md`).
- Push the integration branch and open a PR, **base `llm`**, e.g. "chore: merge upstream master into
  llm (2026-07-17)". Body: summarize what upstream brings in and every notable conflict resolution.

## 2. Shepherd to green (`roles/shepherd/AGENT.md`)
- Drive CI green on the PR (`skills/ci-failure-classification-loop/SKILL.md`). Fix merge-induced
  breakages on the integration branch — adapt `llm` code to upstream API changes, reconcile lockfile
  and types, etc. Iterate until checks pass and the PR is mergeable. Use `skills/local-verify` and
  `skills/pre-push-gates` before each push.

## 3. Conduct to `llm` (`roles/conductor/AGENT.md`)
- When green and mergeable, conduct (merge) the PR into `llm` per the conductor role — a **merge**
  (not squash), to preserve the upstream merge history. Confirm `llm` now contains the upstream
  changes and remains green post-merge.

## Skills
`skills/conflict-resolution/SKILL.md`, `skills/ci-failure-classification-loop/SKILL.md`,
`skills/yarn-lock-separate-commit/SKILL.md`, `skills/local-verify/SKILL.md`,
`skills/pre-push-gates/SKILL.md`; roles `shepherd`, `conductor`.

## Done
`llm` has upstream `master` merged in, via a PR that was proposed, shepherded to green, and conducted
onto `llm`. If the merge is too large/conflict-heavy to converge this cycle, stop and surface the
blockers (leave the PR open with a clear report) rather than force a bad merge. The `tada` report
links the merge PR, summarizes what upstream brought in, lists notable conflict resolutions, and
confirms `llm`'s post-merge CI state.


<!-- garden-deadline-overrun: 1 -->
