Pushed to main2 on the first attempt. The job is complete.

## Completion report

**Job:** `improve-post-job-push-loop-wallclock-deadline` — add an overall wall-clock deadline to the producer push-CAS retry loops in `post-job.sh` and `post-plan.sh`.

**Starting state:** Fresh worktree off `origin/main2`; no prior attempt had committed anything. Re-derived from scratch.

**What I did (commit `5db2500cee`, pushed to `main2`):**
- **`scripts/jobs/common.sh`** — added a shared knob `GARDEN_POST_DEADLINE_SECS` (default **300s**, well under the comment-watcher's 900s `TimeoutStartSec`), documented next to `GARDEN_OFFLINE_RC`, so both producers stay in lockstep.
- **`scripts/jobs/post-job.sh`** — capture `post_loop_start=$SECONDS` before the retry loop; at the top of each attempt, if elapsed ≥ the deadline, log an offline-style line and `exit "$GARDEN_OFFLINE_RC"` (EX_TEMPFAIL) — the same clean skip `sync_clone` takes on a real outage, which `self-heal-run.sh` already normalizes (no Failed unit, no SIGKILL).
- **`scripts/jobs/post-plan.sh`** — identical fix (same loop shape), for consistency per the job spec.
- **`scripts/jobs/test/post-loop-wallclock-deadline-test.sh`** — new hermetic test (throwaway bare journal, modeled on `directive-identity-dedup-test.sh`): asserts both scripts bail with rc 75 and write no job when the deadline is already blown (`GARDEN_POST_DEADLINE_SECS=0`), and still succeed + land the job under the default. **8/8 pass.**

**Verification:** `shellcheck -S warning` (the CI gate) clean on all three production scripts; `bash -n` clean on all four files. The deadline check fires *before* `sync_clone`, so a degraded-connectivity episode bails within one fetch-timeout of the bound rather than grinding through 50 attempts (~tens of minutes). A design-intended push race (sub-second) never trips it.

**Note on process:** My first round of Edit/Write calls used absolute `/home/kris/garden/...` paths and inadvertently landed in the *deployed* garden root working tree. I ran **no git** there, so journal sync was never at risk; I restored those three files byte-for-byte from my pristine worktree copies (plain `cp`, no git) and removed the stray test file, then redid all work correctly inside the per-job worktree. Deployed root confirmed clean afterward.

**Follow-ups:** none required. The 300s default is a reasonable first cut; if any legitimate slow-but-healthy producer path is later observed hitting it, the knob is overridable per-caller without a code change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-post-job-push-loop-wallclock-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 82 tokens (2975737 cached reads)
- Output: 23688 tokens
- Cost: $2.9653194999999997 (1 engagement(s) unpriced)
- Wall-clock: 327s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
