Worktree clean, commit complete. The job is done: a green, verified draft PR is open, stacked on the Phase-1 branch, with the builder's work handed off to the gardening gauntlet's panel stage.

## Completion report

**Job:** Build endoclaw-timer Phase 2 (Tick Delivery and Response) in `endojs/endo-but-for-bots`, stacked on the green Phase-1 branch (PR #609).

**Delivered:** Draft PR **#617** (`build/endoclaw-timer-tick-delivery` → base `build/endoclaw-timer-daemon-formula-integration`), affecting the **`@endo/daemon`** package.

**What I did**
- **Tick delivery as mail (replacing `onTick`):** the daemon's `interval-scheduler` incarnation now posts each tick as an `interval-tick` message into the agent's inbox via the agent mailbox's `deliver`, observable through `followMessages()`. The scheduler gained its own mail **`handle`** (the tick `from` identity), formulated without incarnation to break the scheduler↔handle cycle and resolved via a new `handle()` method on the scheduler exo.
- **`TickResponse` as a guarded exo:** converted from a plain `harden({…})` record to `makeExo('EndoTickResponse', TickResponseInterface, …)` with `M.interface()` guards (new `TickResponseInterface` in `interfaces.js`).
- **Formula-backed one-shot capability:** new `tick-response` formula type + maker; its `resolve()`/`reschedule()` forward to the live tick through an in-memory registry the issuing scheduler owns. Superseded/timed-out/post-restart responses are inert. Transiently pinned and released on supersession so they don't accumulate. Added GC edges (`interval-scheduler`→`handle`, `tick-response`→`scheduler`) and formula-type allowlisting.
- **`interval-tick` as a first-class `MessageFormula` type** end to end in `mail.js`: envelope assertion, message-formula persistence, stamp/replay reconstruction, and locator externalization of `tickResponseId`. New envelope/message types in `types.d.ts`.

**Verification (real execution)**
- New **daemon integration test** (`test/interval-scheduler-daemon.test.js`) boots a real daemon: a tick arrives in the host inbox as an `interval-tick` carrying a `tickResponseId`; resolving it through the delivered capability advances the schedule to tick 2. **Passed** (`1 test passed`, ~1.2s). (Required building `better-sqlite3` native bindings via `prebuild-install` and using a short `/tmp` socket path — the worktree path exceeds the unix-socket length limit; noted as an environment workaround, not a code issue.)
- **Unit test** added asserting each tick's `TickResponse` is a remotable exo whose interface rejects unknown methods (regression evidence for the `M.interface()` requirement).
- Full suites green: `interval-scheduler.test.js` (14) + `formula-type.test.js` (5) + integration (1) = **20 passed**; `envelope.test.js` (13) passed.
- **`tsc` clean (exit 0, 0 errors)**; **`eslint` 0 errors** (warnings only, matching existing file density); `prettier` applied.
- Added a `.changeset` (minor) for `@endo/daemon`; no dependency/lockfile changes.

**For the panel to weigh (flagged in the PR body):** the `tick-response` is a per-tick formula (transiently pinned, released on supersession), mirroring the promise/resolver precedent for carrying a capability in a persisted mail message. It adds per-tick formula churn; a registry-only capability with no disk formula is a possible alternative if preferred.

**Follow-ups:** Phase 3 (startup-recovery catch-up ticks) and Phase 4 (host `makeIntervalScheduler` facet split + CLI) remain per the design. The builder does not run the panel; the gardening gauntlet takes #617 from here.
