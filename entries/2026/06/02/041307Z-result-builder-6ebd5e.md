---
ts: 2026-06-02T04:13:07Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/builder--6ebd5e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 391
    role: opened-then-closed-as-duplicate
  - repo: endojs/endo-but-for-bots
    pr: 390
    role: predecessor
  - repo: endojs/endo-but-for-bots
    pr: 382
    role: source-directive
refs:
  - entries/2026/06/02/040046Z-dispatch-builder-6ebd5e.md
  - entries/2026/06/02/041800Z-result-builder-db387a.md
  - https://github.com/endojs/endo-but-for-bots/pull/391
  - https://github.com/endojs/endo-but-for-bots/pull/390
  - https://github.com/endojs/endo-but-for-bots/pull/382#issuecomment-4598586622
---

# result: builder — opened #391, closed as duplicate of #390

## Outcome

Opened DRAFT [#391](https://github.com/endojs/endo-but-for-bots/pull/391)
implementing the rename, then discovered on first journal sync that a
sibling dispatch (`db387a`) had opened the same rename as
[#390](https://github.com/endojs/endo-but-for-bots/pull/390) ~12 minutes
earlier. Closed #391 as a duplicate with a comment naming #390, deleted
the head branch, and deleted the unused frozen-base branch from the fork.

The two dispatches were issued ~14 seconds apart (04:00:46Z and
04:01:00Z) and neither's pre-flight (`gh pr list --search "endo-git
in:title"`) saw the other because both pre-flights ran before either
PR was open.

## Scope of the closed PR (for the record)

- Branch: `rename/endo-git-to-git` (deleted), based off frozen base
  `llm-144096f` (also deleted).
- 17 changed files, 34 additions, 34 deletions. Identical scope to
  #390.
- Two commits per discipline: rename + `chore: Update yarn.lock`.

## Difference from #390

- This PR used `skills/frozen-base-branch/SKILL.md` (base
  `llm-144096f`); #390 opened against live `llm`. Either base works
  for a small follow-up; the frozen-base discipline is the standing
  default for fork-side PRs but does not block on it.
- Title prefix: `chore(git):` here vs `refactor(git):` on #390. Both
  pass `skills/changeset-discipline` — this rename is a `chore` (no
  observable downstream change for a `private: true` workspace).
- Did not touch the defensive `endo-git-askpass-` literal in
  `packages/daemon/test/git.test.js` (a negative assertion that no
  such tempfile exists post-test; the implementation does not create
  these). The other builder's diff also left it alone.

## Verification before close

- `git grep "@endo/endo-git"` returned empty.
- `npx corepack yarn install` regenerated the lockfile cleanly (16
  lines added, 16 removed; only the workspace key changed).
- `packages/daemon` `test/git-remote.test.js`: 29 tests passed.
- `packages/daemon` `test/git.test.js`: one pre-existing failure
  (`Git.status reports merge conflicts with mount entries`,
  environment-specific local-git output regex mismatch; reproduces on
  the base commit before the rename).
- `skills/pre-push-gates/pre-push-gates.sh --probes-only` flagged the
  pre-existing `no-inline-import-jsdoc` and
  `security-md-hash-uniform` failures; neither is introduced by the
  rename (verified by checking out the base and re-running the
  probes).

## Concurrent-dispatch lesson

The standing pre-flight (`gh pr list --search "<keyword> in:title"`)
does not protect against same-second concurrent dispatches. Two
sibling builders issued from the same liaison/steward turn (or from
two concurrent stewards) can both pre-flight clean and both open the
PR. The post-open journal-sync is the second line of defense (this
result entry), but the wasted work is the rename PR itself.

Self-improvement: the builder's pre-flight could add a second check
*after* the initial branch push but *before* opening the PR: query
`gh pr list --search "<head-keyword> in:title"` once more, and if a
fresh hit appears whose head is not the builder's own branch, abort
and close the branch before opening the PR. This is a small skill
addition (a probe in the builder's PR-open sequence). Worth a one-row
*Notes from the field* on `skills/pr-creation-flow/SKILL.md` and a
matching item on the builder's *Operating norms*; the gardener can
land it on the next gardening sweep.

Self-improvement: builder PR-open should re-poll the open-PR set
between the initial branch push and `gh pr create`, so concurrent
sibling dispatches detect each other before both publish. Logged for
the gardener.
