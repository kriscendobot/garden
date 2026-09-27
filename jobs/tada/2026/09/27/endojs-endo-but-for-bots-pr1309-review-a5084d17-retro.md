I recorded this as **not a review miss**. The maintainer's feedback on #1309 was a tuning preference that no written review rule covers, so no cluster was touched and no improvement job was posted.

**What the review contains.** Review 5271637936 by kriskowal (2026-09-21T20:41:43Z) is an APPROVAL. Its body only gives workflow instructions: respond, retcon, conduct. It has one inline comment (4066237599) on `packages/daemon/src/shutdown-signals.js`. That comment asks for the new orphan-check polling interval to be configurable and to run less often by default. The interval was hardcoded at 1000ms.

**Why it's a dismissal, checked against the PR and the board rather than the primary job's report:**
- **No gauntlet ran, and that wasn't a process failure.** #1309 was opened as a draft by `fix-endo-daemon-test-process-leak-20260919`. `journal/jobs/tada/` has no clean, panel or fix-loop job for pr1309. Under the manual-gauntlet-trigger rules the PR waits for "run the gauntlet #1309", and the maintainer chose to review and approve it directly instead.
- **No existing rule would have caught it.** I searched the juror seat briefs and found nothing about configurable polling intervals or default timer frequency. A 1s poll that only runs behind a test-only opt-in env flag is not a bug or a broken convention. The right default is the maintainer's call.
- **The primary job's fix really landed.** The merged diff (PR merged 2026-09-22T01:04:59Z) has the `orphanCheckMs` option and the `ENDO_ORPHAN_CHECK_MS` env var, defaulting to 5000ms. The inline thread has bot replies confirming the change. The primary's claim matches what's on GitHub.

**What changed:**
- Wrote `review-misses/dismissed/endojs-endo-but-for-bots-pr1309-review-a5084d17.md` on journal2 using `review-miss-record.sh`. It records the reasons in my own words plus the comment URL; none of the comment text is copied in.
- No garden code or library changes, so nothing was committed to main2.

**Follow-up comment in the job file.** It points at the same review URL (5271637936), so this one dismissal covers it too.

**Follow-ups:** none.

Self-improvement: nothing to note.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1309-review-a5084d17-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (568419 cached reads)
- Output: 4124 tokens
- Cost: $0.6656678
- Wall-clock: 68s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
