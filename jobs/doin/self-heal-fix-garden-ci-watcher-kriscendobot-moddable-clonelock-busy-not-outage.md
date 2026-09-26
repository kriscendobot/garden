---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In `scripts/jobs/common.sh`, `journal_bounded_fetch_is_ambiguous_outage()` (~line 4647) classifies `ensure_clone`/clone diagnostics as a transient/ambiguous outage (quiet rc=75 skip) vs. a loud die. Its regex `'journal fetch in .* failed after [0-9]+ attempt|clone of .* failed'` does not match `clone_lock`'s busy-holder die message from `common.sh:4131-4136`: `"cannot acquire clone lock $lf after $n waits of ${wait}s and $steals reclaim attempt(s) (a live holder is still busy...)"`.

Because `GARDEN_CI_VERIFY_CLONE` (ci-watcher.sh:82) and comment-watcher's `VERIFY` clone are each ONE clone shared by every repo-slug's watcher instance on a host, ordinary multi-repo contention (a sibling instance mid-reclone or mid-fetch holding the lock past `GARDEN_LOCK_WAIT`×`GARDEN_LOCK_RETRIES`=180s) currently produces a LOUD, unclassified failure that crash-loops the systemd unit and fires self-heal — observed 2026-09-26 23:54:29 on `garden-ci-watcher@kriscendobot-moddable` while `kriscendobot-ocapn`'s instance (pid 1938268) legitimately held `.garden-state/ci-watcher/verify.lock` mid-reclone.

Fix: extend the alternation to also match the clone_lock busy-holder shape, e.g. add `|cannot acquire clone lock .* after [0-9]+ waits`, so `ensure_clone_or_latch_outage` treats "a live sibling holder is still busy" the same as the other two already-covered transient shapes (latch cooldown, exit `GARDEN_OFFLINE_RC` quietly) instead of exiting loud. Confirm `journal_diagnostic_is_definite_failure` (common.sh:4609-4613) has no false-positive overlap with this new pattern (it doesn't: its lock-related signatures are `unable to create .*\.lock` / `cannot lock ref`, distinct git-internal-lock wording, not `clone_lock`'s "cannot acquire clone lock" phrasing). Add/update a common.sh test exercising `journal_bounded_fetch_is_ambiguous_outage` with a synthetic "cannot acquire clone lock ... after N waits" diagnostic to lock in the classification.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-26T23:57:17Z
