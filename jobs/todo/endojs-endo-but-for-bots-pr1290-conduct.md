---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct (merge) endojs/endo-but-for-bots PR #1290

Finalize and merge PR #1290 ("feat(sha256): @endo/sha256/async, the
asynchronous digest arm"), base `llm`, head `pr903-endo-sha256-async`.

Authority: maintainer kriskowal APPROVED this PR in review
https://github.com/endojs/endo-but-for-bots/pull/1290#pullrequestreview-5271710675
with the explicit directive "then retcon, and conduct this change". The
approval still stands (not dismissed, no later CHANGES_REQUESTED).

Preconditions already handled by the review job
(endojs-endo-but-for-bots-pr1290-review-dec2083a):
- The sole inline comment (packages/sha256/test/browser-entry.js "seems
  extraneous") was resolved at maintainer-delegated discretion: the file
  is kept, with reasoning posted as an inline reply (comment id 4066821098)
  — self-imports exercise the conditional-export `browser` condition, which
  is the point of the test; test-only, not published.
- The branch was rebased onto current `llm` and retconned into three
  grouped commits (feat(sha256) + changeset, test(browser-test),
  chore: Update browser-test lockfile). Net diff invariant verified.

Run the conductor loop: rebase-through-the-spine, block-watch CI to green,
merge with `--merge` in the same job. PR is already OPEN (not draft).

Known-flaky heads-up (do NOT treat as PR-attributable): the pre-retcon run
saw `test (22.x, ubuntu-latest)` fail on a `packages/daemon`
`test/endo.test.js` "Termination requested" SES_UNHANDLED_REJECTION — a
pre-existing daemon flake, not touched by this sha256-only diff (24.x legs
passed). If it recurs on the fresh run, re-run that leg before routing to a
shepherd.

Bot repo (endojs/endo-but-for-bots, `llm` trunk) — merge is authorized.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=754 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-21T23:33:08Z -->
