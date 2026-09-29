---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Merge upstream master into llm on endojs/endo-but-for-bots (maintainer directive, 2026-09-29)

Precipitating case: `endojs/endo-but-for-bots#1356` ("feat(ses): tame and permit
URL and URLSearchParams", draft, base `master-6ee3fda`) was reported overtaken
by upstream `endo#3332`, which landed the same URL/URLSearchParams shim on
`master`. Reconcile the drift by merging `master` into `llm` directly, rather
than trying to hand-reconcile PR #1356 in isolation.

## Task

1. In a worktree of `endojs/endo-but-for-bots`, merge the current tip of
   `master` into `llm` (an ordinary merge commit, not a rebase — `llm` is a
   long-lived branch other open PRs are based against; do not rewrite its
   history). Open this as a draft PR (`llm` <- a merge branch off current
   `llm` merging in `master`) so CI runs against it before it lands, per the
   repo's normal draft discipline
   (`skills/pr-creation-flow/SKILL.md` § Draft discipline).
2. Shepherd it to green CI (`roles/shepherd/AGENT.md`). This is a
   reconciliation merge, not new bot-authored feature work — the maintainer
   has pre-authorized merging on green CI directly, without a design/code
   panel gauntlet, UNLESS the merge itself introduces conflicts or behavior
   changes non-trivial enough that a panel would genuinely add value (use
   judgment; if so, say why and post a gauntlet instead of merging solo).
3. Merge once CI is green.

## Gaps: expect and handle them

This merge will surface drift in both directions — commits `llm` has that
`master`/upstream lacks (bot-authored builds not yet upstreamed), and commits
`master` now has that `llm` lacks (this URL shim being the known instance,
likely not the only one). Diff the two histories (`git log
master..llm --oneline` and `git log llm..master --oneline`, plus a
content diff on any file both branches touched) and:

- For each **upstream feature `llm` is missing** that isn't already resolved
  by this merge, post a job (design or build, as fits) to close that specific
  gap — deterministic basename per
  `skills/job-board/SKILL.md` § Basename shape, one job per gap, not a single
  catch-all.
- For each **bot-authored change on `llm` that duplicates or conflicts with**
  something `master` now has (PR #1356 is the known instance — check whether
  this merge already subsumes it; if so, close #1356 as superseded and say so
  on the PR; if #1356 still carries something master's version lacks, say
  exactly what and post a follow-up to reconcile it), resolve or flag it.

Report every gap found and every job posted in your completion report, even
if a gap turns out to need no action (say so and why).
