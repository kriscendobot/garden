Inbox is empty. The work is complete and pushed to `main2`.

## Completion report

**Job:** Harden `deploy-garden.sh` against the recurring fleet-wide rc=127 restart storm — the residual after the per-file rename, where a unit execing mid-swap sources a *mismatched common/helper version* across the multi-file release.

**Root cause addressed:** `atomic_advance_tree` (per-file `rename(2)`) gives each script *inode-level* atomicity — an opener never sees a half-written file. But a release is many files. A unit that execs during the multi-file swap opens its entrypoint and then, microseconds later, `source`s `common.sh` as a *separate* `open()`. If the swap straddles those opens, the process runs a **new entrypoint over an old common.sh** (or the reverse) and dies `command not found`/rc=127 on a helper only one release defines. Per-file rename cannot close this cross-file window.

**What I did:**
- **New `scripts/jobs/deploy-release-boundary.sh`** providing `freeze_timers` / `thaw_timers` / `verify_coherent_release`.
- **Wired it into `deploy-garden.sh`:** after the dirty/divergence checks and *before* the swap, freeze every active `garden-*.timer` (stop). The drain already quiesces the gardener fleet; this extends the boundary to the **non-gardener** timer-driven oneshots (reaper, foreman, scheduler, watchman, the gardener-scaler, issue-inbox, …) — the documented rc=127 vectors. The swap runs inside the frozen window, so no unit starts on a half-swapped release. After record + reconcile, **thaw** the timers onto the coherent new tree, then **verify** the fleet runs from one release (recorded sha == new sha, every restarted service + thawed timer active).
- **Recovery path:** if the boundary can't be established (a wedged manager makes a timer stop time out), the default **falls back** to the inode-safe per-file swap (never wedge undeployable) with a loud WARN + a maintainer `kind:error` alert; `GARDEN_DEPLOY_REQUIRE_BOUNDARY=1` selects the strict posture that aborts before touching the tree. The EXIT-trap belt thaws any frozen timers on an abnormal abort so a crashed deploy never strands them off.
- **Docs:** updated `designs/deliberate-deploy.md` with a "coherent-release boundary" section and the test summary.

**Tests (all green):**
- `deploy-release-boundary-test.sh` (new): 18/18 — helper edge cases (freeze records + stops; a failed stop reports un-established while still recording for thaw; thaw restarts + clears; verify catches sha mismatch and an inactive thawed timer).
- `deploy-garden-test.sh`: 108/0 (85 prior + 23 new) — freeze precedes swap+thaw+restart, no-timer trivial boundary, fallback recovery, strict abort.
- `deploy-tree-swap-test.sh`: 18/0 (unchanged, no regression). shellcheck-clean.

**Commit:** `27d2ad6cb5` pushed to `origin/main2`.

**Known residuals (documented, both narrow, left to per-file atomicity):** a long-running service that *crash*-restarts inside the sub-second swap window (fleet is drained + idle → vanishingly unlikely), and an in-flight oneshot that started *just before* the freeze and `source`s common.sh during the swap. Freezing the timers removes the dominant vector (a *new* oneshot starting mid-swap).

**Possible follow-up (not required):** the deploy stops timers serially; a wedged manager could cost up to `GARDEN_UNIT_CTL_TIMEOUT` per timer. Parallelizing the freeze wave (like the restart wave) would bound that — but timers stop instantly in the normal case, so it's a minor optimization.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-cross-file-release-atomicity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 105 tokens (7221281 cached reads)
- Output: 67367 tokens
- Cost: $6.8631185000000015
- Wall-clock: 1036s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
