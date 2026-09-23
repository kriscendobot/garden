All done. Writing the completion report.

Completion report:

## Job: xs2rust-endor-stage9b child 3/5 — endor-vm path-dep + daemon spawn wiring (probe step 5)

**Repo:** endojs/endo-but-for-bots, PR #600, branch `xs2rust-endor` (kept DRAFT, no PR comments). Two commits pushed (verified by git exit code; local == `origin/xs2rust-endor` == `0c7b35bdd25`).

### Item 1 — Path dependency (commit `021a53036fc`)
- Added `endor-vm = { path = "../engine/endor-vm" }` to `rust/endo/Cargo.toml` (transitively pulls `endor-regexp`).
- ROOT workspace builds clean (`cargo build --workspace`, EXIT=0); no new warnings (identical to the pre-change baseline: the single pre-existing xsnap `fn_addr_eq` warning only). `Cargo.lock` updated (endo → endor-vm → endor-regexp).

### Item 2 — Spawn wiring behind the engine-selection seam (commit `0c7b35bdd25`)
Wired the daemon's worker-spawn path to the endor-vm boot surface behind an explicit selection seam mirroring the `better-sqlite3-xs.js` powers-injection seam. **C-XS (xsnap) stays the default; the Rust engine is opt-in.**
- New `rust/endo/src/rust_engine.rs`: `boot_probe()` (constructs `endor_vm::Machine` + root compartment — proves the safe interpreter initializes) and `run_rust_worker_probe()` (child-process entry; boots then reports the protocol gap).
- `engine.rs`: `SharedEngine{Xs,Rust}` + pure `shared_engine_for(sel)` + `shared_engine_from_env()` (`ENDO_ENGINE` seam; unset/`xs`→C-XS, `rust`/`endor`/`endor-vm`→Rust, else error). 4 new unit tests.
- `endo.rs`: the `spawn` handler routes `Engine::Shared` through `shared_engine_from_env()` → `inproc::spawn_shared_worker` (xsnap) or `inproc::spawn_shared_rust_worker` (endor-vm).
- `inproc.rs`: `spawn_shared_rust_worker` reuses the engine-agnostic channel scaffolding, completes the transport init handshake, and boots endor-vm in a real worker slot.
- `bin/endor.rs`: `endor worker -e rust` arm + help/env-var docs (`ENDO_ENGINE`).
- `README.md`: new "Selecting the engine" section + `ENDO_ENGINE` env-var row.
- Build clean (EXIT=0, no new warnings). Unit tests green: `engine` 11/11, `rust_engine` 2/2. Selection round-trips at runtime: `endor worker -e rust` → boots endor-vm, reports the CapTP gap, exit 1; `endor worker -e wasm` → unknown engine, exit 2.

### Item 3 — Smoke measurement (report-only; RELEASE binary, serial, short path `~/tmp/s8cxs`, len 28)

| Test | C-XS (default) | Rust engine | broken worker-bin | Reads |
|---|---|---|---|---|
| graph.test.js | 17/17 ✔ | — | — | pure graph unit tests, no worker |
| debugger-captp.test.js | 16/16 ✔ | 16/16 ✔ | 16/16 ✔ | mock debug target, no real worker |
| channel (1 match) | ✔ | — | ✔ | no worker for that path |
| cross-supervisor.test.js | 4/4 ✔ | — | 4/4 ✔ | no separate worker |
| error-trace.test.js | 2✔/5✘ | 2✔/5✘ | 2✔/5✘ | spawns workers; **identical across all three** |
| invite-retention.test.js | — | — | 10 skipped | env-gated |

**Findings (the first real gaps named):**
1. **The default C-XS path is unregressed by the seam.** My binary reproduces the stage-8 baseline exactly (graph/debugger-captp/cross-supervisor pass; error-trace's 5 failures are precisely the documented "error-trace worker-assertions" sandbox divergence). The seam is additive and inert unless explicitly selected.
2. **The Rust worker boots but cannot yet serve the protocol.** endor-vm exposes only a bytecode interpreter + `Machine`/`Compartment` boot surface — it does **not** decode the netstring/CBOR CapTP `deliver` envelopes the daemon routes, nor host the SES worker bundle. So a guest worker on the Rust engine (via `-e rust` for separate, or `ENDO_ENGINE=rust` for shared) boots endor-vm then cannot complete the CapTP handshake. This is the deterministic finding, proven at the CLI/unit level.
3. **This sandbox cannot discriminate a full-daemon Rust-engine run.** The only probe tests that actually spawn a separate guest worker (error-trace) are exactly the ones already sandbox-divergent on C-XS (broken-bin ≡ C-XS ≡ rust, byte-identical), consistent with the documented `endo.test.js` sandbox-unrunnable / error-trace divergences. A clean full daemon-hosted Rust-worker measurement therefore needs a non-sandbox host **and** the CapTP/SES transport — which is the finish-line child's job (5/5).

### Verification bar
- Root workspace builds clean (EXIT=0, no new warnings). ✔
- Engine workspace untouched (no `rust/engine` edits; no `cargo test` there required). ✔
- `forbid(unsafe_code)` intact at all 7 engine crate roots (verified). ✔
- Smoke subset per-test table with exit codes above. ✔

### Follow-ups for the finish-line child (5/5)
- Implement endor-vm's worker surface: a CapTP `deliver`-envelope decoder + SES worker-bundle host so `spawn_shared_rust_worker` / `endor worker -e rust` can service a live session (today they boot-and-report).
- Run the Rust-engine `test:rust` measurement on a non-sandbox host where separate-guest-worker evaluation succeeds on C-XS, so failures are engine-attributable.
- Optionally teach the XS manager (`bus-manager-rust-xs.js` `encodeSpawnPayload`) to carry an engine/platform hint so the daemon can select the Rust engine per worker-formula without the process-wide `ENDO_ENGINE`/`-e` knob.
