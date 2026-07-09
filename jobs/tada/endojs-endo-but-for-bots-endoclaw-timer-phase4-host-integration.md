All work is complete, verified, and pushed. Inbox empty, working tree clean.

## Completion Report

**Job:** Build Phase 4 (Host Integration) of the endoclaw-timer design in `endojs/endo-but-for-bots`, stacking on the interval-scheduler work in PR #609.

**Pushed:** commit `c84fb80ed` → `build/endoclaw-timer-daemon-formula-integration` (PR #609's head branch).

### What changed
- **Facet-pair split** (`packages/daemon/src/daemon.js`): the `interval-scheduler` formula now incarnates as the `{ scheduler, schedulerControl }` facet pair (design § Maker Function) instead of a single combined capability. `scheduler` is the agent-facing facet (`makeInterval`/`list`/`help`); `schedulerControl` is the host-retained `IntervalControl` facet (`pause`/`resume`/`revoke`/`setMaxActive`/`setMinPeriodMs`/`listAll`). The daemon-internal `stop` teardown stays latched to `context.onCancel` and is not exposed.
- **Host method** (`host.js` + `src/types.d.ts`): `makeIntervalScheduler(petName, options?)` resolves to and stores the facet pair; the `EndoHost` type is tightened from `Promise<unknown>` to the pair.
- **`pause()`/`resume()`/`revoke()` on `IntervalControl`**: already implemented in the exo from #609; the split makes them reachable as the host-facing control facet (rather than flattened onto one combined cap that the agent would also hold).
- **CLI** (`@endo/cli`): new `endo interval list|pause|resume <name>` under a new "Scheduling" help group; `commands/interval.js` carries a pure, offline-testable `renderIntervalList`.
- **`IntervalEntry`** is now exported from `@endo/daemon` for the CLI renderer.
- **Changeset** added (`@endo/daemon` + `@endo/cli`, minor).

### Verification (all executed here)
- `interval-scheduler` unit suite: **13 passed** (exo untouched).
- **2 new e2e daemon tests** (`test/endo.test.js`): **passed** — the host method returns/stores the facet pair; `IntervalControl` pause/resume/revoke + the `maxActive` limit drive the scheduler; revoke is permanent. (Verified over a live daemon + CapTP, confirming the record-return marshals correctly.)
- **5 new CLI tests** (`test/interval-command.test.js`): **passed** — help wiring, required-arg failures, and the pure renderer.
- `tsc`: **clean** on `@endo/daemon` and `@endo/cli`.
- `eslint`: **0 errors** on both packages (only pre-existing-style warnings).

### Notes / follow-ups
- **PR shape decision for maintainer:** I extended PR #609's branch directly, so #609 now carries both "Phase 1 remainder" and Phase 4. If a separate stacked PR is preferred, `c84fb80ed` cherry-picks cleanly onto a new branch.
- **Phase 2** (tick delivery as mail messages + a `TickResponse` exo) remains open, as noted in the incarnation comments. The facet split follows the design shape but doesn't cryptographically separate agent from host in the current host-bound model (both facets live under one pet name); full agent-granting is a larger follow-up.
- **Environment:** the daemon e2e tests hit a Unix-socket-path-length limit (171 chars) from this long scratch worktree path — even the pre-existing `lifecycle` test fails for this reason. I gathered real execution evidence via a temporary, **reverted** `ENDO_TEST_SHORT_ROOT` harness override (not committed). Also, `better-sqlite3`'s native build fails under the sandbox (permission-denied on `prebuild-install`/`node-gyp` shims); I built it manually via `node-gyp` to run the daemon suite.
