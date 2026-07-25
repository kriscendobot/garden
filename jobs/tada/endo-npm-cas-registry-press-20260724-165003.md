CI doesn't build `rust/endo` at all (only the `ocapn_noise` wasm artifact job), so the Rust-only change can't break CI and the local `cargo test` run is the operative gate — 181 passing. The tick's work is complete.

---

## Completion report — endo-npm-cas-registry-press-20260724-165003

**Assessment.** Phase 2 (HTTP fetch, PR #276) is **merged**; the design doc now records all five phases implemented at `llm` HEAD `e2c6ff853`, including Phase 4 assembly/execution and Phase 5 offline/.npmrc. No live peer was working this press (older press inboxes are lingering dirs of completed dispatches; the board's `doing/` had no npm-registry job).

**Finish-line evidence (real execution, fresh state, no npm CLI / node_modules / lockfile).** Built `endor` from `llm` HEAD (required `git submodule update --init c/moddable` plus the xsnap JS bundles, copied from the stage10p worktree since `bundle-bus-worker-xs.mjs` remains an out-of-tree gap):
- `ENDO_STATE_PATH=<fresh> endor run entry.js` with `"semver": "7.5.4"` in a `"type": "module"` entry package: fetched `semver@7.5.4` + `lru-cache@6.0.0` + `yallist@4.0.0` from registry.npmjs.org into the CAS, assembled the compartment map, executed in XS — correct output (`semver sorted: ["0.0.1","1.2.3",…]`, `satisfies: true`, exit 0). `^7.5.4` → MVS-selects 7.8.5, also runs.
- `endor run --offline` on the warm state succeeds entirely from CAS + registry table; on a cold state it refuses with the typed error `offline: network access to https://registry.npmjs.org/semver refused`. (An early "invalid import" failure was my own fixture missing `"type": "module"` — Node rejects the same entry; not a regression.)

**Press: peer/optional dependencies (next unblocked known gap) → draft PR [#857](https://github.com/endojs/endo-but-for-bots/pull/857)** (`feat/endor-npm-peer-optional-deps`, base `llm`, DRAFT, three commits):
1. `semver.rs`: fixed `||` ranges to true union semantics — previously OR alternatives were flattened into one AND set, so `^17 || ^18` (the peer staple) matched neither major.
2. `npm_resolve.rs`: non-optional `peerDependencies` fold as required edges (MVS-unified); `optionalDependencies` are attempt-and-skip with skips reported (`ResolveOutcome::skipped_optional`, surfaced by both CLIs); `peerDependenciesMeta`-optional peers are constrain-only; npm precedence (optional over dependencies) and required-edge un-skip retry handled.
3. `assemble.rs`: peer edges now bind in the compartment map so `require('peer')` links at runtime (previously peers produced no edge even when resolved); skipped-optional edges are omitted for a clean cannot-find.

Evidence: live-registry `endor npm-resolve 'react-redux@^9.0.0'` selects `react` purely via peer edges (18.3.1 from `^18.0 || ^19`; 16.14.0 from use-sync-external-store's `^16.8 || ^17 || ^18` — distinct MVS anchors coexisting), optional peers `redux`/`@types/react` unactivated; `endor run` of a `graphql-tag` entry shows the peer edge to `graphql` linking and loading, stopping only at the pre-existing confined-runtime `process` gap. `cargo test -p endo --lib`: 181 passed (9 new tests). Clippy-clean in touched code; the design doc marks the gap done and records the new gap.

**Follow-ups for the next tick:**
- **`process.env.NODE_ENV` gap** (recorded in the design's known gaps): real CJS packages (react, graphql) die on `get process: undefined variable` even though their edges now link — deciding a frozen shim vs. rejection is the next runtime increment.
- PR #857 awaits review/gauntlet; CI has no rust/endo job so it cannot go red from this change.
- The xsnap JS bundles (`ses_boot.js` etc.) still aren't generatable in-tree (`bundle-bus-worker-xs.mjs` missing) — a standing build-reproducibility gap worth its own job.
