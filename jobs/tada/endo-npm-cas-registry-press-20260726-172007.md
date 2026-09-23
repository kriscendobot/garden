# Press report — npm-via-CAS registry proxy (tick 2026-07-26)

## Assessment

The arc has crossed its functional finish line. All five design phases (`designs/endor-npm-registry-proxy.md`) are implemented and **merged to `llm`**: registry table, HTTP fetch (PR #276 merged), MVS semver, compartment-mapper assembly + XS execution, and offline/.npmrc support. The known-gap follow-ups from prior press ticks — #857 (peer/optional deps), #859 (process shim), #860 (.npmrc auth), #862 (registry CLI) — are all open drafts, fully green in CI, held draft per press policy. No live peer was on any shared branch.

## Real-execution evidence (finish line re-verified)

Built `endor` from `llm` HEAD and ran a fresh-state end-to-end proof with a real npm dependency:

- `endor run entry.js` with `semver@7.5.4` walked the transitive graph, fetched **semver → lru-cache@6.0.0 → yallist@4.0.0** from registry.npmjs.org, stored them content-addressed in the CAS, recorded `(name, version) → hash` rows in `registry.db`, and executed the real CJS chain in XS with correct output (`maxSatisfying: 1.2.0`). No `npm` CLI, no `node_modules` (confirmed absent), no lockfile.
- MVS confirmed live: `^7.5.4` selected `semver@7.8.5` (greatest of major 7); a pin of `7.5.4` coexists as a separate registry row.
- Offline lifecycle proven three ways: cold state + `--offline` refuses with a typed error; online run populates; `--offline` re-run then executes from the CAS in ~12ms.
- One false alarm en route: an entry file without `"type": "module"` fails with `invalid import` — correct Node-parity behavior (CJS scripts can't use `import`), not a defect.

## What I pressed: found and fixed a real race in the arc's execution path

Stress-running the `execute` suite exposed a genuine flake: 3 of 5 parallel runs failed with `entry module import did not settle (async work still pending)`, different victim test each time, every test green in isolation. Root cause: `Machine::quiesce` and the worker pump polled `fxHasPendingJobs()`, a check-and-reset **process-global** C flag (`gHasPendingJobs`) shared by all XS machines — one machine's drain steals another's pending signal, leaving its microtask queue undrained (also an unsynchronized data race). This sits on `endor run`'s async entry-import drain (top-level-await path), so it intermittently poisons CI for every PR in this arc.

Fix: replaced the global with per-machine `fxMachineHasPendingJobs(the)` over `the->promiseJobs` (the flag `fxRunLoop` already uses) and deleted the global. Evidence: 10/10 parallel `execute` runs green after (vs 3/5 failing before); full `endo` suite (170 tests) green. Opened **draft PR endojs/endo-but-for-bots#864** (`fix/xsnap-quiesce-per-machine`), CI running at completion time.

## Follow-ups for the next tick

- Shepherd #864's CI to green.
- The one unaddressed known gap is **workspace-protocol resolution** (`workspace:*` ranges for monorepo members) — the natural next feature increment; no PR covers it yet.
- The four green gap drafts (#857/#859/#860/#862) are ready whenever the maintainer wants them run through the gauntlet.
