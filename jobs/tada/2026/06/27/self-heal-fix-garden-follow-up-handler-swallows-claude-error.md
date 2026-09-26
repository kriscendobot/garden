## Completion report

**Job:** `self-heal-fix-garden-follow-up-handler-swallows-claude-error`

**Root cause confirmed:** In `scripts/jobs/handlers/follow-up-claude.sh`, `out="$(claude -p --dangerously-skip-permissions "$prompt")"` captured stdout only, and under `set -euo pipefail` any non-zero `claude` exit aborted the handler before a single log line. follow-up.sh:110 then saw the non-zero handler exit and emitted the contentless `FATAL: follow-up handler failed` (follow-up.sh:115) — rate-limit, auth failure, and crash were all indistinguishable in the `garden-follow-up` tail. The parse-loop's producer pipes (`post-job.sh`/`set-schedule.sh`/`set-schedule-once.sh`/`inbox-send.sh`) had the same hazard: a single producer failure aborted the whole handler with no context about which action failed.

**Changes (one file, `scripts/jobs/handlers/follow-up-claude.sh`, +28/-5):**
- The `claude -p` call now captures stderr to a `mktemp` file, takes the exit status explicitly via `|| rc=$?` (so `set -e` doesn't abort first), and on non-zero exit `die`s with `rc`, the last 500 bytes of stderr, and the captured stdout — so a transient claude back-off vs an auth error vs a crash is self-classifying in the service tail.
- Each parse-loop producer invocation is wrapped with `|| log "<action> '<name>' failed (rc=$?); skipping this action, continuing digest"`, so one bad action logs which action/name failed and the digest continues instead of aborting silently.

**Verification:** `bash -n` clean; `shellcheck -x` introduced no new warnings (only the two pre-existing ones — the runtime-resolved `../common.sh` source path and `GARDEN_TAG`, which `log()` uses). Smoke-tested the failure path with a stub `claude` that prints to both streams and exits 7 — the `die` correctly surfaced `rc=7`, the stderr "usage limit reached" signature, and the partial stdout.

**Process:** Built in an isolated worktree off `origin/main2` per the garden-infra convention, committed under the bot identity with an explicit pathspec, fast-forward pushed `HEAD:main2` (`ba38a1372..3ab9074bc`), and removed the worktree. Inbox drained at the checkpoint (empty).

**Follow-ups:** None. The fix is self-contained; existing follow-up tests use a stub handler (`GARDEN_FOLLOWUP_HANDLER`) and so are unaffected — there is no direct test of the real handler's `claude` invocation, but adding one would require a `claude` stub on PATH and is out of scope for this self-heal.
