---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/ci-watcher.sh` calls `ensure_clone_or_latch_outage "$VERIFY" ci-watcher-verify` (line 198) specifically so a clone/lock timeout is a quiet exit 75, not a FATAL — its own comment says so. But `ensure_clone` (common.sh) internally calls `clone_lock` (common.sh:4080-4147), whose give-up path (line 4142) `die`s with `"cannot acquire clone lock $lf after $n waits of ${wait}s and $steals reclaim attempt(s) (a live holder is still busy; ...)"`. `ensure_clone_or_latch_outage` (common.sh:4671-4687) only latches the quiet-skip path when `_fetch_stderr_is_offline` or `journal_bounded_fetch_is_ambiguous_outage` (common.sh:4647-4652) matches the captured diagnostic; that regex is `journal fetch in .* failed after [0-9]+ attempt|clone of .* failed` and never matches the clone-lock busy-holder message, so the die's diagnostic falls through to the loud `exit "$rc"` at line 4686 — exactly what happened for `garden-ci-watcher@kriscendobot-test262` at 01:55:12 (log: two backoff retries at 01:53/01:54, then FATAL, `0 reclaim attempt(s)` confirming the sibling holder was genuinely live, not stale).

Root cause: all `garden-ci-watcher@<slug>` systemd instances (~15, one per watched repo) share ONE unparameterized clone dir, `$GARDEN_CI_VERIFY_CLONE` = `$GARDEN_STATE/ci-watcher/verify` (ci-watcher.sh:82-83), so when their independent timers cluster, a sibling instance legitimately holding the lock for a whole tick makes every other instance exhaust the 3×60s wait ladder and fail the systemd unit — an otherwise self-resolving one-tick contention.

Fix: teach `journal_bounded_fetch_is_ambiguous_outage` (or add a sibling classifier called alongside it inside `ensure_clone_or_latch_outage`) to also match the clone-lock busy-holder diagnostic text (`cannot acquire clone lock .* after [0-9]+ waits of .*busy`), so this case latches the same quiet cooldown/exit-75 path as a network outage instead of re-raising loud — fulfilling the "timeout → quiet exit 75, not FATAL" contract `ci-watcher.sh` already documents at its call site. Confirm the new match text can't collide with `journal_diagnostic_is_definite_failure`'s local-failure regex (common.sh:4598-4601) — it doesn't (no `cannot lock ref`/`unable to create .*\.lock` overlap).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-27T01:57:46Z
