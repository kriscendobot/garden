Work complete and pushed. Here is my completion report.

---

**Job `finbot-substrate-adapters` — complete.** Pushed to `kriscendobot/finbot` `main` as `bdf67ee`.

**What I did**

Built the Phase 2 executor signing adapters for real ymax substrates (Path A Agoric / Path C EVM+Solana), replacing the `route: 'sim:single-venue'` placeholder with real place/route identifiers, behind the live gate with a dry-run-proven build path.

**What changed**

- **`packages/pipeline/substrates.js`** (new) — `SUBSTRATES` registry (`sim`, `agoric`, `evm`, `solana`). Each adapter: (1) `resolveRoute` fills a step's real place/route (Agoric pool places `USDN`/`Aave_Arbitrum`/`Compound_Optimism` with chain+protocol+transport; EVM `evm:<chain>:<protocol>`; Solana `solana:<cluster>:<program>`); (2) `buildTransaction` emits the would-be transaction purely with no wallet (a `rebalanceTx`-shaped continuing offer `invitationMakerName: 'Rebalance'` for Path A; approve+supply / instruction batch for Path C); (3) `signAndSubmit` is live-only and fails closed without the wallet capability.
- **`planner.js`** — accepts `substrate` + `venueMap`, stamps each step's route via a resolver, records `substrate` on the proposal. Default stays `sim`, so the existing dry-run and the proposal hash are unchanged.
- **`rebalance.js`** — `deriveSteps` takes an optional `routeResolver` (default preserves the sim placeholder).
- **`executor.js`** — builds the substrate transaction in dry-run (unsigned, `walletTouched: false`); the gated live path signs+submits via the vended wallet cap. Result now carries `substrate` / `prepared_transaction` / `submission`.
- **`auditor.js`** — invariant #6 became a real `place-route-reachability` check (unmapped/unknown venues fail; deploy-config-only gaps pass).
- **`designs/ymax-integration.md`** — recorded the adopt-vs-mirror decision (kept the mirror; borrow vocabulary+offer shape, not `@agoric/portfolio-api`) and the provenance discipline.

**Safety bounds honored** — agoric-sdk untouched; no internal ymax-web dependency; every concrete deploy/runtime value (offer id, pool addresses, Axelar GMP channels, Solana program ids) flagged in each route's `needs_internal_detail`, never fabricated; no real signer/key/RPC; live signing stays gated (the executor still refuses `live` without `live_authorized: true`).

**Verification** — `packages/pipeline/test/substrates.test.js` (13 tests, including the dry-run proof that the fake signer is never called) plus the full pipeline suite and all-package suites are green; `bin/finbot-ooda` runs end-to-end with `place-route-reachability` passing and `WALLET TOUCHED: false`.

**Follow-ups** — A future, separately-authorized live-enable job fills the flagged `needs_internal_detail` from real deployment config and wires a real `makeSigningSmartWalletKit`-backed wallet capability for one substrate. Inbox was empty throughout. Scratch worktree torn down; `package-lock.json` from `npm install` was deliberately not committed (repo does not track one).

**Self-improvement:** nothing this time.
