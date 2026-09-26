Inbox empty. The work is complete.

---

## Completion report

**Job:** Wire the `@endo/genie` interval-scheduler prototype into `@endo/daemon` as a proper formula type — the endoclaw-timer "Phase 1 remainder" — and open a DRAFT PR.

**Delivered:** DRAFT PR **endojs/endo-but-for-bots#609** (base `llm`, head `build/endoclaw-timer-daemon-formula-integration`).

### What I did
Graduated the prototype (`packages/genie/src/interval/`) into the daemon as a first-class `interval-scheduler` formula:

- **`packages/daemon/src/interval-scheduler.js`** (new) — SES-safe port of the genie scheduler. Swapped `node:fs` for the daemon's `filePowers` (write-then-rename, one JSON file per interval), `node:crypto` for an injected id generator, and made `setTimeout`/`clearTimeout`/`now` injectable for deterministic testing. Start-to-start scheduling, resolve/reschedule + exponential backoff, tick-timeout auto-resolve, host limits, pause/resume/revoke, and startup recovery with missed-tick coalescing all carried over.
- **`formula-type.js` / `types.d.ts`** — registered the type, the formula record (`{ agent, maxActive, minPeriodMs, paused }`), and the powers/facet/entry typedefs.
- **`daemon.js`** — `extractLabeledDeps` case (strong `agent` GC edge), maker-table entry (per-formula persistence dir; `thisDiesIfThatDies(agent)` + `onCancel` disarm), and `formulateIntervalScheduler`.
- **`host.js` / `interfaces.js`** — a lean `makeIntervalScheduler(petName, opts?)` host command + interface guard so an agent can hold the capability end-to-end.
- **`test/interval-scheduler.test.js`** (new, 7 cases) + updated `formula-type.test.js` registry list.

### Verification (real runs)
- **12 tests green** (`interval-scheduler.test.js` 7 + `formula-type.test.js` 5), executed via ava.
- **tsc clean** for all changed files (the only remaining error is a pre-existing broken `@libp2p/kad-dht` `.d.ts` in `node_modules`, unrelated trunk drift).
- **eslint: 0 errors / 0 warnings** in the new source.
- Full daemon module graph (`daemon.js`+`host.js`+`interfaces.js`+`interval-scheduler.js`) imports and evaluates cleanly under SES lockdown.
- **Not verified:** a booted-daemon end-to-end run (host command → formulate → maker → tick), because this sandbox can't build the daemon's native dep `better-sqlite3` to boot a live daemon. The path typechecks and the module graph evaluates, but I did not execute it live — stated plainly in the PR.

### Follow-ups (deferred per the design, noted in the PR)
- **Phase 2:** tick delivery as daemon mail with a `TickResponse` exo + the scheduler's own `handle` (currently ticks flow through an injected `onTick`; formula carries only the `agent` edge).
- **Phase 4:** the full `makeIntervalScheduler(agentName, opts)` host method returning the `IntervalScheduler`/`IntervalControl` facet split written to the agent's pet store, plus CLI commands.
