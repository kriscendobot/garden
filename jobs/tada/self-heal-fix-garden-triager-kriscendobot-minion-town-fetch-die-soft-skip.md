The job is already fully resolved on `main2`. Every requirement in the spec is present in the current tree:

- **triager.sh:121** — the steady-state refresh is now `if ! bounded_fetch "$BARE" --all --prune; then`, bounded via `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` with `GARDEN_FETCH_RETRIES` (common.sh:712–730), so a SIGTERM-ignoring transport child can't wedge the fetch.
- **triager.sh:122–127** — on ultimate failure it does *not* `die`: it logs a WARN and `exit 0` (skip tick, retry next), and escalates through `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}"` (throttled dedup), exactly mirroring the provision-failed path.
- The shared helper was factored as `bounded_fetch` in common.sh (used by both clone-keeper and triager), matching the spec's "factor a shared helper" suggestion.
- The consecutive-failure circuit breaker (triager.sh:223–226) is untouched.

No changes are needed and nothing to commit.

---

**Completion report**

The requested fix was already landed on `main2` before this job ran, across commits `457ba8a7 fix(triager): skip failed refresh ticks`, `8d83681e fix(triager): soft-skip every steady-state fetch failure`, `9730e562 fix(triager): classify transient gh fetch failures`, `79d5fb96 fix(triager): alert on transient bounded fetch failure`, `a335cf0a fix(triager): skip and alert on every fetch failure`, and `0c940939 fix(triager): share bounded fetch helper`.

- **What I did:** Verified the current worktree (HEAD `03833819`, = origin/main2) against every requirement in the spec.
- **What changed:** Nothing — the fix is already present. `triager.sh:121` uses the bounded, retrying `bounded_fetch` helper (common.sh:712, `timeout --kill-after=$GARDEN_FETCH_KILL_AFTER $GARDEN_FETCH_TIMEOUT`, `GARDEN_FETCH_RETRIES` attempts); `triager.sh:122–127` soft-skips (`log WARN` + `exit 0`) and escalates a persistent failure via `alert_maintainer` with the throttled `triager-fetch-failed-<slug>` dedup key; the handler circuit breaker is untouched.
- **Divergence from spec (intentional, already merged):** the shared helper is named `bounded_fetch` (generic, `git -C "$dir"` also works on a bare dir) rather than a separate `bounded_bare_fetch`; this fulfills the "factor a shared helper" intent and is already used by clone-keeper too.
- **Follow-ups:** none. No commit/push required; the `garden-triager@kriscendobot-minion.town` crash-loop signature (bare `Terminated` + `FATAL: fetch failed` `die`) can no longer occur from this code path.
