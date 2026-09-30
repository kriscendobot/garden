## Gauntlet FIX round 5: endojs/endo-but-for-bots#1383 (daemon lifecycle idempotency design)

I applied the panel's round-5 fixes and pushed them as one follow-up commit. CI is green: 28 of 28 checks passed (`ci-wait-merge.sh` returned rc 0).

**Where it landed:** commit `1f77b37d01` (moved the head from `984880f7ad` to `1f77b37d01`), pushed with `safe-push-pr-head.sh`. Every change is in `designs/daemon-lifecycle-idempotency.md`, plus an edit to the PR body.

**Must-fix items:**
- **Critic #1 and decomplector (the owner record could be read half-written):** the design now says the marker is written to a temp file and then hard-linked to `endo.lock`, which fails if a marker already exists, so it is still an exclusive create. It says why `rename` is not used, and how reclaiming a stale marker still lets only one claimant win.
- **Critic #1 (a marker that doesn't parse):** the design now says the checker treats it as "still starting" for the startup wait window and as "stale" after that, never as "absent". An absent result would let a second daemon start.
- **Novice #1 (the five states were used before being defined):** "One owner record" now opens section 2. The pid-recycling material follows under a new heading, "Owner identity and recycled pids". Section 1 also gives a short meaning for each of the five states.

**Should-fix items:**
- **Critic #2:** `stop` now prints its own message when it stops a daemon serving a different socket from the one requested.
- **Skeptic #1:** the design covers the reverse upgrade direction (an older binary run against a newer daemon). It accepts that gap and gives a rollback procedure: stop the daemon with the newer binary before installing the older one.
- **Skeptic #2:** added the missing tests:
  - Phase 1: a marker that doesn't parse.
  - Phase 2: the `status` first line that reports the state.
  - Phase 3: `stop` exiting 70, `restart` after a 70, and `stop` against a daemon serving another socket.
- **Ergonomist #1:** exit code 3 is now defined as "not reachable at the requested socket". The design explains why a daemon serving another socket still gets 3 from the query commands.
- **Ergonomist #2:** `start --force` is rejected with a hint pointing to `--force-clean`. I did not make it an alias, and the design says why.
- **Decomplector note:** section 6 now says that on Windows the checker can only return "live" or "absent".
- **Novice #2:** reworded the forward reference to Open Question 3.
- **Copyeditor #1–#3:** split the three sentences flagged.
- **Pruner:** the PR body now says "documentation only" once instead of in each section. I dropped the empty Scaling and Upgrade sections, refreshed the test list, and corrected `--force` to `--force-clean` in the Compatibility section.

**Not done:** the pedant's heading-capitalization comment was optional, so I left the headings as they are. I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1116182 cached reads)
- Output: 10149 tokens
- Cost: $1.0738004
- Wall-clock: 857s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
