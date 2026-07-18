In `scripts/jobs/triager.sh`, the steady-state fetch at line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) hard-`die`s (exit 1) on ANY fetch failure, so a transient/terminated fetch marks the unit failed and fires self-heal. Observed signature: a two-line log `Terminated` followed by `FATAL: fetch failed for kriscendobot-garden`, i.e. a hung fetch killed by SIGTERM — a transient connectivity event, not a bug.

Fix: make this fetch transient-aware, mirroring the existing pattern in `ci-watcher.sh:258`, `comment-watcher.sh:1153`, and `pages-watcher.sh:189`, and consistent with triager.sh's OWN clone-provision skip philosophy (lines 95–104):
1. Capture the fetch's stderr to a temp file (e.g. `ERRF`) instead of discarding it.
2. On non-zero exit, if `is_transient_net_error "$ERRF"` (`common.sh:296`) matches, `log "WARN: transient fetch failure for $slug; skipping this tick (retry next tick)"` and `exit 0` — do NOT advance the cursor, do NOT die. Only `die` on a structural failure that the matcher does not recognize.
3. Because the observed kill is an external SIGTERM/`Terminated` on a stalled fetch (a signature `is_transient_net_error` does not currently match), also wrap the fetch in a bounded timeout (reuse the bounded/timeout helper the clone path uses, or `timeout <N>`) so a hung fetch fails fast under our own control, and treat that timeout/terminated exit as transient (WARN + exit 0) as well — either by adding a `Terminated|timed out|killed` signature to `is_transient_net_error` or by treating the timeout wrapper's dedicated exit code as transient at the call site. A bare-clone `git fetch` failure is essentially always network/remote (ref-resolution structural cases are handled separately downstream at lines 128–137), so degrading it to skip-and-retry cannot mask a real logic bug.

Definition of done: a transient or terminated fetch in triager.sh exits 0 (WARN + skip, cursor unadvanced) instead of exit 1, so a network blip no longer marks `garden-triager@<slug>` failed or trips self-heal; add/extend the triager test guards to cover the transient-fetch-skip path alongside the existing missing/corrupt-clone skip cases.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: cleric
  claimed_at: 2026-07-18T14:45:27Z
