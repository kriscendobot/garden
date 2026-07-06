Phase 3 is complete. Draft PR #619 is open, based on the Phase-2 branch, with the bot identity; all gates pass and my inbox is empty.

## Completion report

**Job:** Build endoclaw-timer **Phase 3 (startup recovery)** in `endojs/endo-but-for-bots`, stacked on the green Phase-2 branch.

**What I found:** The tick-recovery *logic* already existed on the Phase-2 branch — `makeIntervalScheduler`'s `recover()` re-reads persisted entries, computes `missedTicks`, delivers a coalesced catch-up tick, and re-arms. The **missing seam** was that `recover()` only ran when a scheduler was incarnated, and `seedFormulaGraphFromPersistence()` only seeds the GC graph — it does **not** incarnate formulas. So on restart a scheduler stayed dormant (timers unarmed, missed ticks silently lost) until an agent happened to look it up. That gap is exactly Phase 3.

**What I changed** (package: `@endo/daemon`):
- `packages/daemon/src/daemon.js` — after the unreachable sweep in `seedFormulaGraphFromPersistence()`, eagerly `provide()` every surviving `interval-scheduler` formula, so `recover()` runs at boot. Placed after the sweep (no resurrecting orphans) and isolated per scheduler (one failure logged, not fatal; idempotent with later lookups).
- `packages/daemon/test/interval-scheduler-daemon.test.js` — new **real daemon-restart** integration test: boots a daemon, creates a 1s host-bound interval, observes tick 1, stops the daemon with the tick left in the past, waits past the period, restarts the **same state directory**, and — *without ever looking the scheduler up on the second incarnation* — asserts a coalesced catch-up `interval-tick` with `missedTicks >= 1`, `tickNumber === 2` arrives in the host inbox.
- `.changeset/daemon-interval-startup-recovery.md` — minor changeset for the observable restart-recovery behavior.

**Verification (real execution):**
- New daemon-restart test passes (9.5s); full suite `interval-scheduler` + `interval-scheduler-daemon` + `formula-type` → **21 tests passed**.
- **Regression evidence:** with the eager-incarnation pass disabled, the new test fails (catch-up tick never arrives → times out); re-enabled → passes. Load-bearing for the Phase-3 change specifically.
- `tsc` clean; `eslint` **0 errors** on changed files; `prettier --check` clean.

**Output:** Draft PR **#619** (`build/endoclaw-timer-startup-recovery` → base `build/endoclaw-timer-tick-delivery`), draft confirmed, bot identity (`endolinbot`). Affected package: `@endo/daemon`.

**Notes / follow-ups:**
- Env quirk: this fresh worktree had no `node_modules` and the sandbox blocked native-build scripts (`prebuild-install`/`node-gyp` → "permission denied"), so `better-sqlite3` didn't build. I copied the prebuilt `better_sqlite3.node` from a sibling worktree's pnpm store (identical store hash) to run the daemon tests. Purely a local test-harness workaround — no repo changes.
- Next in the chain (not part of this build job): the gauntlet's panel review of #619, then un-draft. Phase 4 (host integration: `pause`/`resume`/`revoke` on `IntervalControl`, CLI `endo interval …`) remains per the roadmap.
