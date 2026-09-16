Done. Empty inbox, work committed and pushed to `main2` (commit `568e5d9eeb`).

## Completion report

**Job:** `improve-deadline-nudge-stage-failure-isolation` — wrap each tick stage of `scripts/jobs/deadline-nudge.sh` with explicit status handling, stage-specific error logging, and guaranteed clone-lock cleanup.

**Root cause found.** In `deadline_nudge_tick`, every stage (clone, sync, staging, push) ran as a *bare* call under `set -e`. A single transient failure aborted the whole tick and surfaced only as the opaque top-level `WARN: ...failed locally (rc=1)` — the failing stage was never named. Worse, the staging stage *relied on* `set -e` for fail-fast, but `set -e` is silently defeated deep inside `stage_due_messages` (nested command substitutions suspend errexit), so a failed `git add` continued and mis-reported the staged count. I proved this with a `bash -x` trace: the injected `git add` failure printed its error, yet `staged=1` and `stage_rc=0` still followed.

**What changed (`scripts/jobs/deadline-nudge.sh`):**
- Clone and sync stage calls are now `if ! prepare_clone` / `if ! sync_journal`, so their own bounded-retry loops own the outcome and a failure defers the tick cleanly (each already logs a stage-named ERROR) instead of `set -e` escaping.
- Both stages now recognize the EX_TEMPFAIL offline rc (`GARDEN_OFFLINE_RC`): a connectivity blip is logged concisely and deferred rather than retried to "exhausted" and mislabeled as a fault.
- `stage_due_messages` checks each fallible `git add` explicitly (`add_rc`) and returns non-zero with a stage-named diagnostic instead of leaning on `set -e`. The tick captures that status and, on failure, **discards partial writes** (`reset --hard` + `clean -fd inbox` in the scanner's own lock-held private clone) so the next tick recomputes and re-delivers every still-due warning — closing a latent data-loss path where half-written messages would be treated as already-delivered and orphaned forever.
- Guaranteed clone-lock cleanup via an `EXIT` trap on the tick subshell (`clone_unlock` is idempotent), backstopping every early-return and every set-e abort.
- Push-stage exhaustion still returns non-zero (preserving the existing fail-open "failed locally" surface) but now logs a stage-named ERROR too.

**Tests.** Added `scripts/jobs/test/deadline-nudge-stage-git-stub.sh` (injects a `git add` failure) and a new assertion verifying a staging fault is stage-named, discards partial writes, leaves the board unchanged, and fails open. Full suite now **47 passed, 0 failed**; shellcheck clean (only pre-existing SC1091/SC2016 infos); the `set -e`/lock semantics were verified empirically before landing.

**Follow-ups:** none required. (Noted but out of scope: `common.sh`'s `sync_clone` only `git clean`s `jobs/`, not `inbox/`, which is why the local discard was needed here — a broader clean-scope change would touch all callers and wasn't warranted.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-stage-failure-isolation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (8621168 cached reads)
- Output: 77613 tokens
- Cost: $7.920480000000001
- Wall-clock: 1276s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
