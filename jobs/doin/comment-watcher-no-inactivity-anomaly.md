# Comment-watcher: stop reporting human inactivity as an anomaly; make blindness a deterministic self-test

Map: **build** (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2; commit explicit pathspecs; push HEAD:main2 via
a git-rebase CAS loop.

Maintainer directive 2026-06-27: **"let's not treat maintainer inactivity as a
report-worthy anomaly. People sleep sometimes."** The comment-watcher's silent-blind
detector pages the maintainer ("0 comments for N consecutive ticks, but <repo> IS
active … may be silently blind") and fired repeatedly on 2026-06-27 during a normal
quiet period.

## The flaw
`scripts/jobs/comment-watcher.sh` (the zero-result-streak block, ~lines 117-132 +
~520-532): it tracks a consecutive-zero-result streak and, past a threshold,
cross-checks an "activity probe" (`GARDEN_COMMENT_ACTIVITY` / the default that asks
whether the repo has had a comment since the cursor). It conflates "the watcher is
BLIND" with "no NEW comments": the probe sees an OLD already-seen comment (e.g. from
~36h ago) and declares the repo active, so zero new results "must" mean blindness —
but the real cause is just that nobody has commented (people are asleep). Absence of
human activity is normal and must NEVER reach the maintainer as an anomaly.

## Required behavior
- REMOVE the inactivity-based anomaly: never page the maintainer because there are
  no new comments / the maintainer is quiet / a PR is idle. Delete the
  "0-comments-for-N-ticks-while-active → maintainer alert" path.
- The underlying concern (the watcher going silently blind — the 2026-06-24 jq
  outage dropped comments for ~16h) is REAL, so REPLACE inactivity-inference with a
  DETERMINISTIC POSITIVE SELF-TEST: periodically confirm the comment SOURCE PATH can
  actually FETCH a KNOWN-EXISTING comment (e.g. fetch a specific known comment id /
  the most recent comment via the same handler path the watcher uses, and assert a
  non-empty, well-formed result). If the self-test PASSES, zero new comments is just
  quiet → report nothing. Only a FAILED self-test (the source returns nothing for a
  comment that demonstrably exists) is a genuine-blindness anomaly worth a throttled
  maintainer alert.
- Keep the existing `require_tools` hard-dependency guard (the correct, deterministic
  defense that fails LOUD on a missing binary like jq) — that stays.
- Tests: extend run-test.sh / the comment-watcher test — a quiet repo (no new
  comments, self-test passes) produces NO maintainer alert regardless of streak
  length; a genuinely-blind source (self-test fails to fetch a known comment) DOES
  alert (throttled). Stub the self-test deterministically.

Deliverable: the comment-watcher never reports inactivity; blindness is detected by
a positive self-test, not by the absence of new comments.

---
claim:
  host: endolinbot
  gardener: 84
  claimed_at: 2026-06-27T15:27:45Z
