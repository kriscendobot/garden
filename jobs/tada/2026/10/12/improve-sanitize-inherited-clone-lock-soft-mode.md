**Completion report: improve-sanitize-inherited-clone-lock-soft-mode**

`self-heal-run.sh` no longer passes an inherited clone-lock soft mode into the services it wraps. The fix is pushed to main2 as `b13ef4cbd43`.

**What changed**
- **`scripts/jobs/self-heal-run.sh`:** right after it sources `common.sh`, the wrapper now runs `unset GARDEN_CLONE_LOCK_SOFT GARDEN_CLONE_LOCK_SOFT_COOLDOWN_KEY`. Every wrapped service, and the wrapper's own capture path, now starts in normal hard-lock mode. Mandatory journal syncs (bulletin, orchestrate) therefore wait for the lock again instead of giving up as "OPTIONAL" when it is busy.
  - `GARDEN_LOCK_SOFT_WAIT` is left alone. It is only a tuning value and does nothing unless the soft flag is set.
  - Scripts that turn on soft mode for one specific lock call (deadline-nudge, the comment and ci-watcher verify clones, the triager's pacing clone, namespace-clone-maintenance, the journal-contention remedy) set it themselves inside the handler, so they still work.
- **`scripts/jobs/test/run-test.sh`:** I added subtest (1b) to the self-heal block. It runs the wrapper with both variables set and checks that the handler sees neither, and that a soft mode set inside the handler is still honored.

**Verification**
- Running the wrapper directly with the soft-mode variables set prints `inherited=unset/unset` and `scoped=1`, exit code 0. `bash -n` passes on both files.
- New subtest (1b) never ran: the full `run-test.sh` hit my 580s limit before reaching the self-heal block.
- In that partial run, three earlier subtests failed: "deferral not logged", "inbox cold clone retry failed (rc=75)" and "maintainer unread not archived". All three come before the self-heal block, in inbox and deferral code this change doesn't touch.

**Follow-ups**
- I didn't find which parent process leaks `GARDEN_CLONE_LOCK_SOFT` into these services. This fix blocks it at the wrapper either way.
- The three failing subtests above may be worth a separate look.
- The fix only takes effect on each host after the next garden deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-sanitize-inherited-clone-lock-soft-mode.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (714390 cached reads)
- Output: 5107 tokens
- Cost: $0.70993
- Wall-clock: 660s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
