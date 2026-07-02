# investigator (garden-infra): why did the garden miss kriskowal's #594 CHANGES_REQUESTED review?

**Garden-infra change on `main2`** (if a code fix results). Isolated worktree off `origin/main2` per the
hard rule; root checkout read-only. Land any fix with an explicit-pathspec commit, push `HEAD:main2`.

## The incident (kriskowal, 2026-07-02)

kriskowal submitted a **CHANGES_REQUESTED review** on `endojs/endo-but-for-bots` PR #594 at
**2026-07-02T10:14:32Z** ("Please use JavaScript for the driver script. Use zx ... or drive eslint by
API ..."): <https://github.com/endojs/endo-but-for-bots/pull/594#pullrequestreview-4616520025>. The
garden did **not** auto-detect or act on it — the liaison had to relay it by hand. That is the defect:
a maintainer review on a bot-authored PR should be detected and turned into action (a fixer job)
automatically. Find out why it was missed and close the gap.

## Investigate (root-cause, do not guess)

Read the review-detection machinery and determine which failure applies (there may be more than one):

1. **Reviews vs comments coverage.** Does the comment-watcher (`scripts/jobs/comment-watcher.sh` /
   `garden-comment-watcher@`) and its `skills/github-activity-poll` / activity-feed logic poll the
   **pull-request *reviews*** endpoint (`/pulls/<n>/reviews`, the `pullrequestreview` object), or only
   issue/PR **comments** and review-*comments*? A formal top-level review with no inline comment is a
   distinct API object; if the watcher never queries it, `CHANGES_REQUESTED`/`COMMENTED` reviews are
   invisible. This is the leading hypothesis.
2. **Leader-gating window.** The watcher is a leader-only singleton. From ~00:26 the host was mislabeled
   `endolinbot2` and evaluated as a follower, so every leader singleton (including the comment-watcher)
   was `ExecCondition`-skipped. Leadership was corrected around 10:11-10:27. Check whether the watcher
   was simply not running when the review landed (10:14:32), and whether its since-cursor then skipped
   past the review on resume (a cursor that advances by time rather than by unseen-review would drop it).
3. **Cursor / dedup.** If it does poll reviews, did an ETag/since cursor or a dedup key cause this review
   to be treated as already-seen?

## Deliverable

A journal `result` entry naming the concrete root cause with cited evidence (the exact code path that
does or does not query reviews; the watcher's run/skip state at 10:14:32Z). Then **close the gap**:

- If reviews are not polled, extend the watcher to detect maintainer **reviews** (`CHANGES_REQUESTED`
  and substantive `COMMENTED`) on open bot-authored PRs and post a **fixer** job (the same shape it uses
  for review-comments), respecting the existing sender/authorization gates. Land on `main2`.
- If the cause was purely the leader-gating outage, confirm the resume path does not skip
  already-landed-but-unseen reviews (cursor keyed on unseen items, not wall-clock), and fix if it does.

Note the specific #594 review is already being addressed separately (relayed to
`ebfb-lint-master-strategy-evidence`); this job is about the **detection gap**, not that one review.

## Definition of done

Root cause cited; a fix landed on `main2` (or, if no code change is warranted because it was solely the
leader outage and the resume path is already correct, a `result` entry proving that with the cursor
logic quoted). Include a test or documented manual repro that a maintainer review now produces a fixer
job. Journal a `result` entry.
