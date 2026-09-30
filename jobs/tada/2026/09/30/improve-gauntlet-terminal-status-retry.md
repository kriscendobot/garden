## Completion report: improve-gauntlet-terminal-status-retry

**Result:** When the comment read or post fails, the gauntlet now saves a pending terminal-status receipt with the finish and retries it on later ticks. Pushed to `main2` as `69ba81510c3`.

**The defect:** `gauntlet_terminal_comment` skipped its post when the GitHub comment read failed, for example when the read was quota-cooled (seen 2026-09-30 07:23:22Z and 07:44:15Z). The finish then removed the gauntlet record, so the PR never got its receipt.

**What changed in `scripts/jobs/gauntlet.sh`:**
- **Failures are now retryable.** `gauntlet_terminal_comment` takes the PR fields as arguments. It returns 1 when the comment read or the post fails, and 0 when the comment was posted, was already there, or can never be posted.
- **A pending record is saved with the finish.** A new `gauntlet_terminal_receipt` writes the retry record to `jobs/gauntlet-terminal-pending/<base>--<state>.md`. It holds the base, state, repo, PR number, iteration, creation time and the halt reason. `finish_gauntlet` commits it in the same push as the tada report, so the finish and the pending receipt land together. The path is fixed, so re-running the same finish can't create a second record.
- **Each tick retries first.** A new `retry_terminal_pending` sweep runs before the main loop:
  - It skips everything while the host's GitHub API cooldown is active.
  - It re-reads the PR comments before posting, so the existing hidden-marker check still prevents duplicate comments.
  - It removes the pending record once the comment is posted or found already there.
  - It drops the receipt if the gauntlet was reopened with `--resume-from-stage`, since the terminal state no longer holds.
  - It gives up after `GARDEN_GAUNTLET_TERMINAL_PENDING_MAX_AGE_SECS` (default 7 days) and tells the maintainer.

**Tests:** I extended `gauntlet-test.sh` and added a read-failure switch to `gauntlet-gh-stub.sh`.
- **Subtest 13 (write failure):** the pending record lands with the finish; the next tick posts the comment once and clears the record; a further tick doesn't post again.
- **New subtest 14 (read failure):** the pending record lands with the finish and carries the PR details. It stays pending while reads keep failing. Once reads recover it is posted once, with the halt reason, and cleared. If a record is re-created after the comment already landed, the next tick clears it without a second post.
- With the fixture budget pool set to unmetered, the suite passed 63 of 63.

**Follow-ups:**
- **The unmodified test fails on this host.** The unmodified `gauntlet-test.sh` fails at subtest 1 on this host. That happens at HEAD too, before my change. `seed_calibrated_test_pool`'s measured fixture pool reads as at its budget limit, so `post-job.sh` parks every stage in `plan/` as budget-hold. The test apparently picks up the host's live usage, which it shouldn't. I got the 63/63 run from a private copy with an unmetered pool; the committed test still seeds the measured pool, so it will fail here until that leak is fixed.
- **Shared test directory.** The suite uses a fixed shared directory (`TR=/home/kris/.garden-gauntlet-test`), so two runs at once overwrite each other. `run-test.sh` already moved to a separate temp directory per run; this suite should do the same.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-terminal-status-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2467387 cached reads)
- Output: 19967 tokens
- Cost: $1.6703133999999997
- Wall-clock: 388s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
