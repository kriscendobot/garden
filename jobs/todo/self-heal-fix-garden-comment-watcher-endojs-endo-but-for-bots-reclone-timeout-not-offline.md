---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`reclone_clone` in `scripts/jobs/common.sh` (~line 4302-4316) classifies a failed journal clone as "offline" (exit `GARDEN_OFFLINE_RC`, EX_TEMPFAIL) using ONLY `_fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"`. When `bounded_clone`'s internal `timeout` kills a hung `git clone` before it prints any DNS/connection-reset text, `GARDEN_CLONE_STDERR` is empty, the stderr-pattern check misses, and the function falls through to `die` — turning a plain network timeout into a FATAL crash instead of a quiet, retried tick.

Failure signature observed: `garden-comment-watcher@endojs-endo-but-for-bots` exit 1, log tail: "clone of git@github.com:kriscendobot/garden.git into .../comment-watcher/verify timed out (>45s) on attempt 1" → "failed after 1 attempt(s) (last rc=124)" → "FATAL: clone of ... (journal2) into .../verify failed".

Fix: after the `if GARDEN_CLONE_RETRIES=1 bounded_clone ...; then return 0; fi` line, capture `rc=$?` and change the offline check to `[ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || _fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"`, matching the established pattern already used at `common.sh:6820`, `6838`, and `6874` for the same rc-124/137-vs-empty-stderr gap. This makes a bare timeout classify as offline (EX_TEMPFAIL) rather than crashing the service.
