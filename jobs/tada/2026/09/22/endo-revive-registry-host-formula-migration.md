The job is complete. Draining confirmed an empty inbox and all verification passed.

## Completion report

**Task:** Revive closed PR #899 ("migrate persisted host formulas missing registry") on `endojs/endo-but-for-bots`, rebase onto current `llm`, re-verify its test, open a fresh PR.

**What I did:**
- Fetched the stale branch (`build/registry-host-formula-migration`, 2 ahead / 2243 behind) and **cherry-picked the migration commit `aab982d93f` onto current `llm` HEAD `2d0f7fb7f0`** — it auto-merged cleanly into `packages/daemon/src/manager.js`'s `seedFormulaGraphFromPersistence`.
- **Dropped the second commit** from #899 (`fix(reminder): remove redundant global directive`) as obsolete: the `/* global setTimeout */` directive it removed no longer exists on current `llm` (already removed upstream), so it was a no-op.
- Verified all referenced helpers (`formulateNumberedRegistry`, `parseId`, `randomHex256`, `withFormulaGraphLock`, `persistencePowers.writeFormula`) and all test imports (`restart`, `makeDaemonDatabase`, `parseId`, `openTestDb` pattern) still resolve on current `llm`.
- **Re-verified the test** (`packages/daemon/test/registry-endo.test.js`): `ava --serial` → **4 passed**, including "a host formula persisted without registry is migrated on startup and resolves @registry" (2.7s).
- CI-parity checks: `yarn lint` → **0 errors**; `yarn lint:types` (tsc) → **clean**; `prettier --check` on changed files → **clean**. No new deps, so no composite-tsconfig drift.

**What changed / result:**
- Pushed rebased branch → `origin/build/registry-host-formula-migration-revive`.
- Created frozen base snapshot `llm-2d0f7fb` (ensure-pr.sh mandates a pinned base).
- Opened **draft PR endojs/endo-but-for-bots#1329** (base `llm-2d0f7fb`, single clean commit, durable job marker). Body cites kriscendobot/minion.town#111 (revert) and #110 (original pin bump) as the real-world occupant justifying the revival, per the job.

**Follow-ups:**
- PR #1329 is DRAFT by design (manual-gauntlet regime); maintainer promotes it with **run the gauntlet #1329**.
- **After #1329 merges to `llm`**, notify kriscendobot-minion.town over the bus so it can re-attempt the `89481580` daemon pin bump (PR #110). This can't happen now (pre-merge) and is owned by the merge event, not this attempt.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-revive-registry-host-formula-migration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1801426 cached reads)
- Output: 16078 tokens
- Cost: $1.946825
- Wall-clock: 375s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
