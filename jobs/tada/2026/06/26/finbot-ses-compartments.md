Work complete and pushed. Final report follows.

---

## Completion report: `finbot-ses-compartments`

**Goal met.** Replaced the in-process v0.5 capability attenuator in `kriscendobot/finbot` with real SES compartments and a real `@endo/exo` Far wallet. Pushed to `origin/feat/ses-compartments` (commit `ff56e0d`); branch left for review rather than force-landed on `main` (substantial security-surface change; reversible path).

### What changed
- **`packages/pipeline/cap-attenuation.js`** — now pulls in SES/@endo:
  - `lockdown()` once per process (guarded on `Object.isFrozen(Object.prototype)`, idempotent); `@endo/exo`/`@endo/patterns` imported *after* lockdown so they bind the SES `harden`.
  - `buildRolePolicy` turns each role's `ambient` column (formerly documentary) into the exact host globals it may name; `makeRoleCompartment` / `evaluateInRoleCompartment` run role code in a real `Compartment` whose `globalThis` is that policy plus its attenuated vended caps — ambient authority is the empty set.
  - `makeWalletCapability` now vends an `@endo/exo` Far behind a dynamic `InterfaceGuard` (`passStyleOf === 'remotable'`), fronted by a **revocable forwarder** (caretaker pattern) so `revoke()` still throws `CapabilityError` — needed because errors are flattened across the Exo membrane.
  - `attenuateForRole` / `runInAttenuatedCompartment` semantics unchanged.
- **`packages/pipeline/signing-worker.js`** (new) — the § Process-boundary CapTP machinery. Worker side holds the backing signer and offers the wallet Exo as a CapTP bootstrap; the executor operates it purely as a remote `E(wallet)` presence. `connectSigningWorkerInProcess` is the tested protocol reference; `spawnSigningWorker` is a gated stub (refuses without `live_authorized` + keystore; transport is a deferred open question).
- **Tests** — `test/cap-compartment.test.js` (14) proves ambient-authority denial: a forecaster compartment cannot name `process`/`require`/`fetch`, cannot escape via `Function("…")()`, has `Math.random` denied, direct `eval` censored (`SES_EVAL_REJECTED`); granted ambients reachable; real Far+InterfaceGuard wallet; vended-only-to-live-executor. `test/signing-worker.test.js` (5) proves the remote CapTP path, off-interface rejection across the boundary, and teardown revocation.
- **`designs/cap-attenuation.md`** — added a v1 "Notes from the field" section documenting lockdown, real compartments, the Far+forwarder, the CapTP worker, and the compartment-mapper deviation.
- Deps added to `packages/pipeline/package.json`: `ses`, `@endo/{exo,pass-style,patterns,eventual-send,captp}`. Index/exports updated.

### Verification
- All tests green: **375 across packages, 0 fail** (existing 72 pipeline tests untouched, +19 new).
- `bin/finbot-ooda` dry-run runs end-to-end under lockdown and still reports `WALLET TOUCHED: false`.

### Safety bounds honored
Dry-run only; no real wallet/key/funds wired; live executor stays gated (`spawnSigningWorker` refuses). No agoric-sdk work. Fake in-memory signers only in tests.

### Follow-ups (deliberate deferrals, recorded in the design)
- **`@endo/compartment-mapper` not adopted** — it loads on-disk *module-graph archives*; finbot roles are in-memory functions, so direct `new Compartment({ globals })` is the faithful realization. The mapper belongs with the harness `compartmentAttenuator` hook (still a throwing stub) once role code is loaded from `roles/<role>/` archives.
- **CapTP cross-process transport unchosen** (Unix socket vs. `MessageChannel` child; persistent vs. spawn-fresh) — `spawnSigningWorker` stays a gated stub until the first live paper-wallet run picks one.
- `package-lock.json` left untracked (repo tracks no lockfile; caret ranges resolve).

Inbox drained, empty. Worktree torn down.
