---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/common.sh, `reclone_clone()` (~line 4302) calls `die()` on any `bounded_clone` failure that `_fetch_stderr_is_offline` doesn't recognize, including when `rc` is 124 or 137 — a self-imposed `GARDEN_FETCH_TIMEOUT` wall-clock kill (SIGTERM at deadline / SIGKILL escalation), not a real repository error. Observed failure: garden-comment-watcher@kriscendobot-garden's re-clone of git@github.com:kriscendobot/garden.git into `.garden-state/comment-watcher/verify` timed out at 45s during checkout (git stderr: "Clone succeeded, but checkout failed..."), rc=124, which does not match any `GARDEN_OFFLINE_SIGNATURES` pattern, so it fell through to `die()` and crashed the service (exit 1) instead of skipping the tick.

`sync_clone()` in the same file (~line 6817 and ~6833) already treats this exact rc=124/137 shape as a clean transient skip (`exit "$GARDEN_OFFLINE_RC"`) alongside its stderr-signature check, with rationale that this is "the commonest symptom under ~100-gardener contention." `reclone_clone()` is missing that same `[ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] ||` clause before its `_fetch_stderr_is_offline` check (~line 4311), so a wall-clock timeout during a fresh/re-clone (as opposed to an ordinary fetch) still hard-dies.

Fix: in `reclone_clone()`, change the offline-check condition to also treat rc 124/137 as transient, mirroring `sync_clone`'s existing idiom exactly (including the `exit "$GARDEN_OFFLINE_RC"` clean-skip path and log line). Add a short comment cross-referencing why (mirrors sync_clone's rationale) so the two call sites don't drift again. This affects every caller of `ensure_clone`/`reclone_clone` fleet-wide (comment-watcher, mention-watcher, pages-watcher, ci-watcher, dependabot-watcher, issue-inbox-watcher, approval-reconciler), all of which currently hard-crash-loop under the same contention pattern instead of skipping the tick.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T21:54:40Z
