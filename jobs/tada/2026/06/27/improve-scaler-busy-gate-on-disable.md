Inbox empty. Work complete.

---

**Completion report: `improve-scaler-busy-gate-on-disable`**

**What I did**

Applied the same busy-marker gate `deploy-sync.sh` already uses for its restart path to `install-units.sh scale()`'s disable-extras loop, and centralized the "mid-job" definition so the two paths can never drift. Landed as commit `af274bcab` on `origin/main2`.

**What changed**

- **`scripts/jobs/common.sh`** — new shared helpers `gardener_busy_marker <idx>` (the one definition of the marker path, `$GARDEN_STATE/gardeners/<idx>/busy`) and `gardener_busy <idx>` (the predicate). This is now the single source of truth for "a gardener that must not be disturbed mid-job."
- **`scripts/jobs/install-units.sh`** — `scale()`'s disable-extras loop now gates on `gardener_busy`: an idle extra is still `disable --now`'d, but a **mid-job** extra is left running and **skipped** (logged), so the next 1-minute `garden-gardener-scaler` tick disables it once it has gone idle. The worker stops *between claims*, never mid-`claude -p`. This removes the `rc=143` transient-handler outages where a scale-down SIGTERM'd an in-flight handler that then requeued and burned a full TTL cycle.
- **`scripts/jobs/deploy-sync.sh`** — replaced its inline `[ -e "$GARDEN_STATE/gardeners/$idx/busy" ]` with the shared `gardener_busy` predicate (functionally identical; one definition now).
- **`scripts/jobs/gardener.sh`** — its `BUSY_MARKER` path now comes from `gardener_busy_marker` (was an inline duplicate of the same path string).
- **`scripts/jobs/gardener-scaler.sh`** — refreshed the now-stale "scale-0 SIGTERMs every handler (rc=143 storm)" rationale to note the disable is now busy-gated; the no-op-on-undeterminable-count behavior is unchanged and still correct.
- **`scripts/jobs/test/enable-services-test.sh`** — added a SCALE section: arm gardeners @1/@2/@3, mark @3 mid-job, `scale 1`; asserts the idle extra (@2) is `disable --now`'d, the busy extra (@3) is deferred and stays armed, and the deferral is logged.

**Verification**

- `bash -n` clean on all five touched scripts.
- `enable-services-test.sh`: 19/19 pass (5 new SCALE assertions).
- `deploy-sync-test.sh`: 30/30 pass (confirms the predicate refactor didn't change deploy behavior).
- Built and tested on a clean worktree off `origin/main2` (isolated-worktree convention), committed with explicit pathspecs, pushed `HEAD:main2`, then restored the shared tree to a clean state so it doesn't wedge the deploy-sync fast-forward.

**Follow-ups**

- None required. The fix relies on the existing recurring 1-minute scaler tick to catch deferred busy extras once idle — already in place (`garden-gardener-scaler.timer`). Deferred extras keep claiming jobs in the brief window before they go idle, which is correct (they finish their work cleanly rather than being killed); the scale-down converges within one or a few ticks.
