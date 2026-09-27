The change is landed on `origin/main2`. Work complete.

## Completion report

**Job:** `improve-ci-watcher-outage-latch-flap-dedup` — add hysteresis to `scripts/jobs/ci-watcher.sh`'s journal-outage latch so intermittent connectivity can't flap the episode open→closed→open across the ~15 per-repo watchers.

**Root cause:** `note_journal_recovered` removed the latch and logged "closed" on the *first* successful `verify_fetch` after an outage. During a flaky (not fully down) window, watchers on the 90s cadence landed on different sides of brief recoveries, so a success closed the episode and the next failure re-opened it with a fresh loud "opened" WARN — exactly the 2026-09-19 04:53–05:20Z evidence (6 "opened" WARNs across 4 slugs in one window).

**What changed (`scripts/jobs/ci-watcher.sh`):**
- Added two config knobs near the latch definition: `GARDEN_CI_JOURNAL_OUTAGE_RECOVERY_TICKS` (default 3) and `GARDEN_CI_JOURNAL_OUTAGE_QUIET_SECS` (default 180).
- `note_journal_recovered` now accumulates recovery progress in the latch dir (`recovery_epoch`, `recovery_count`) under the *same* sibling flock, and closes only once recovery is **durable**: N consecutive successes **OR** a quiet period elapsed since the first success. The first success is silent, not a close. Degenerate `ticks<=1` preserves the old close-on-first-success behavior.
- `note_journal_outage`, when a failure arrives while an episode is already open, drops the recovery progress and silently extends the *same* episode (`exit 1`, no new WARN) instead of closing then re-opening.
- The open path, the host-scoped (no-slug-key) latch, and the flock serialization are untouched.

**Tests (`scripts/jobs/test/ci-watcher-test.sh`):** threaded the two knobs through the `run_ci_outage` helper (defaulting to count-based close after 2 for determinism) and rewrote section R to assert: first success is silent/pending, a mid-recovery failure does not re-open a loud episode and resets progress, and two consecutive successes close with exactly one notice. Concurrent open/close cases still hold. **All 97 ci-watcher tests pass; shellcheck shows only pre-existing info-level notes in unchanged code.**

**Landed:** commit `5b0a95ac0b` on `origin/main2`.

**Follow-ups:** none. (Note: the test hardcodes `TR=/home/kris/...`; on this worktree host I had to recreate `/home/kris` to run it — a pre-existing environment assumption, not something this change introduced.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-outage-latch-flap-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 66 tokens (2778038 cached reads)
- Output: 28281 tokens
- Cost: $3.0251040000000007 (2 engagement(s) unpriced)
- Wall-clock: 656s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
