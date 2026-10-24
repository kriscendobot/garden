---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/foreman.sh` (around line 509, the "pumped next milestone step" branch) runs `printf '%s' "$body" | "$HERE/post-job.sh" "${post_args[@]}" "$base"` under `set -e`.

**Failure signature:** `garden-foreman` exits 79. The log's last line is `[post] WARN: job 'endojs-endo-but-for-bots-pr1349-fix' collides with a COMPLETED job in tada/ — NOT re-posted (rc=79)`.

**Cause:** 79 is `GARDEN_COMPLETED_COLLISION_RC`. `post-job.sh` returns it when a basename matches a completed job in `tada/` and no directive identity is supplied. `scripts/jobs/deadmail.sh:222` already handles this rc. The foreman does not, so a deliberate refusal kills the service.

**Fix:**
- Wrap the `post-job.sh` call so rc 79 is handled instead of aborting the tick. Capture the rc with `|| rc=$?`.
- On rc 79, skip writing `LAST_STEP`.
- Also on rc 79, log it, call `decide completed-collision "base=$base"`, and surface it once with `note_once "collision:$base" ...`.
- Do not post. The foreman's next-step handler must not re-propose a base that is already in `tada/`. Either give the step an ISO-date suffix (`-YYYYMMDD`) or skip it as already done.
- Any other nonzero rc should still fail loudly.
- Add a regression test next to `scripts/jobs/test/directive-identity-dedup-test.sh`: a foreman pump whose base collides with `tada/` must exit 0 and not post.
