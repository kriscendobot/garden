All 34 tests green in the final committed state (25 keeper + 6 migration + 3 park). The work is complete: draft PR #14 is open, tests pass, typecheck/lint/prettier clean, no regressions.

Let me write the completion report.

---

## Completion report — `xst-park-on-fail-build`

**Deliverable: Draft PR [kriscendobot/agoric-sdk#14](https://github.com/kriscendobot/agoric-sdk/pull/14)** — *"feat(SwingSet): park a vat that fails to upgrade, resumable via its admin facet"* — base `master-37a4fa3` (frozen snapshot of fork master `37a4fa319`), head `kriskowal-park-on-upgrade-failure`, **draft**. Fork-only; upstream Agoric untouched.

**Issue spine (per job note):** issue_spine `issue-kriskowal-garden-33`, issue_url `https://github.com/kriskowal/garden/issues/33#issuecomment-4910381116`, submitter `kriskowal`.

### What I built (the kernel-first slice)

A reversible per-vat kernel state **`parked`**, sibling to `terminated`. Affected packages: **`@agoric/SwingSet`** only.

- **kernelKeeper** (`state/kernelKeeper.js`): `vats.parked` cache + `markVatAsParked`/`vatIsParked`/`getParkedVats`/`getParkedVatRecord`/`unparkVat`, a `${vatID}.parked` reason record, and a per-vat `${vatID}.parkQueue` (dedicated `[head,tail]` helpers, no stats, marker dropped when empty). Schema bump **v3→v4**; `createStartingKernelState` seeds `vats.parked`; `upgradeSwingset.js` gains a v4 migration.
- **kernel.js**: `onUpgradeFailure: 'rollback'|'park'` in `processUpgradeVat` (default rollback = today); a `park` field on `CrankResults` applied after `abortCrank` (mirroring `terminate`); `parkVat` helper; delivery routing that defers `send`/`notify`/GC events destined for a parked vat into its park queue (refcount-neutral — parking never decrefs, so explicit refcounts stay elevated); resume-by-upgrade (skip pre-upgrade BOYD, unpark, drain FIFO on success, re-park on repeat failure); `getAllVatIds` skips parked vats so reap/snapshot never force a parked worker online.
- **vat-warehouse.js**: `ensureVatOnline` refuses parked vats; preload skips them.
- **Admin facet** (`vat-vat-admin.js` + `device-vat-admin.js` + `vat-admin-hooks.js`): new `restart()` and `parkStatus()`, and `onUpgradeFailure` carried through `upgrade()`. No `assertRunningVat` relaxation was needed — parking never removes a vat from vatAdmin's `runningVats`, so the existing guard already admits parked vats.
- **Docs**: `packages/SwingSet/docs/parked-vats.md` (operator/developer page, modeled on `vat-upgrade.md`).

### Verification (real-execution evidence)

- **`test/upgrade/park-on-fail.test.js`** (new, local worker) — **3/3 pass**: rollback-is-default; park-on-failed-upgrade + `parkStatus` + a send that defers + resume-by-`upgrade` draining deferred deliveries FIFO (count→2); resume-by-`restart` via replay. **Regression-evidenced**: with the `park` CrankResults field forced off, both park tests fail at the `parked` assertion (rollback test still passes), then reverted.
- **`test/state.test.js`** — **25/25 pass** (incl. new `v4 upgrade` migration test; initial-activity-hash snapshot regenerated for the new consensus key).
- **`test/upgrade-swingset.test.js`** — migration tests pass (v0/v1/v2→v4, full-state deepEqual updated for `vats.parked`).
- **`test/upgrade/upgrade.test.js`** (existing regression suite) — **24 pass, 1 pre-existing known-failure, 0 new failures**.
- **`tsc` clean (0 errors)**; **eslint 0 errors**; **prettier clean** on all changed files.
- Environment note: the fork was a fresh checkout; I compiled `better-sqlite3` from source and built the `xsnap-lockdown` + `swingset-xsnap-supervisor` bundles (skipped by `enableScripts:false`) to run the kernel suite.

### Remaining work for the validation/follow-up jobs

1. **Detection hook 2 — NOT implemented.** The `ensureVatOnline` replay-divergence / worker-recreate **panic** paths still panic; converting them to park non-critical vats (critical keep panic) is the consensus-scariest piece and needs a doctored-transcript test. My warehouse change only *refuses* an already-parked vat; it does not turn a panic into a park.
2. **Critical-vat policy on the upgrade path.** I park any vat under `'park'` regardless of `critical`. The design recommends barring critical vats from parking in v1 — a validation job should decide and, if needed, gate the upgrade-park path on `vatKeeper.getOptions().critical`.
3. **Variant composition (#11031)** — `WorkerOptions.variant` plumbing, snapshot-variant keying, upgrade-time variant switch, divergence-fixture test. This is the second decomposed job (`xst-park-on-fail-build-variant`); the mirror branch `xst/xsnap-variants-11031` exists on the fork.
4. **`controller.restartVat`** — a thin wrapper; deferred because a testable static-vat park path needs hook 2.
5. **`terminateWithFailure` on a parked vat** — I did not implement park-queue splat-on-terminate; a terminate of a parked vat may leave deferred messages. Needs validation/handling.
6. **GC-delivery-to-parked** — I defer GC uniformly (design said "suppressed"); refcount-safe but wants validation.
7. **Structured `vat-parked`/`vat-resumed` slog events** (I used `console.log`) and **park-queue growth cap/metric** (design open question, v1 metric-only).
8. **Consensus/multi-node determinism** and **xs-worker** variants of the park tests — my tests are single-node, local-worker.

All work is committed to the fork PR; nothing was pushed to garden `main2` (this was a project build, not a garden-library change).
