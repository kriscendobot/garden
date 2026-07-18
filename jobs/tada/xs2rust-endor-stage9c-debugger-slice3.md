No messages. All achievable work is complete and pushed. Here is my completion report.

---

## Completion report — stage-9c child 7/9: debugger slice 3/3 (daemon bus integration + acceptance tests)

**Repo/branch:** `endojs/endo-but-for-bots` PR #600, branch `xs2rust-endor`. Synced to real remote tip `c1d6eb807d` (slice 2), pushed `c1d6eb807d..6452685a00`. PR kept draft; no comment posted.

### What I did

**1. End-to-end acceptance test over the endor in-memory transport (delivered, green).**
Added `rust/engine/endor-debug/tests/vm_lifecycle.rs` (2 tests). Unlike the existing `protocol_roundtrip.rs` (which drives a hand-rolled stand-in "VM"), this wires slice 1's `DebugTransport` and slice 2's `DebugSession` to a **live `endor_vm::Interp`** and runs real bytecode through the dispatch loop, so the `line`/`debugger` seam fires for real and `<frames>`/`<local>`/`<global>` are sourced from genuine machine state. It models the envelope-bus split (design layers 1–2) with a shared `Rc<RefCell<BufferTransport>>` — the bus owns the byte buffers, the session holds a handle. Coverage: `attach → <login> → set-breakpoint → break (debugger) → <frames>/<local>/<global> inspection → go → the armed line-10 breakpoint fires → resume`, plus a detach-is-dormant test proving a detached machine emits no debug bytes. Set-breakpoint's effect is proven end-to-end (the command arms the table, then a later `line` opcode actually breaks).

**2. 16 CapTP debugger tests — green, C-XS path unperturbed.** `packages/daemon/test/debugger-captp.test.js`: **16/16** (verified twice, on the default engine). Required generating the gitignored SES/worker/daemon boot bundles via `packages/daemon/scripts/bundle-*.mjs` and a `yarn install`.

**3. Daemon/worker envelope seam confirmed in place.** The `debug`/`debug-attach`/`debug-detach` verbs are already handled on both sides — daemon JS (`bus-manager-rust-xs.js`) and the Rust worker (`xsnap/src/lib.rs` + `powers/debug.rs`). `rust/engine` is a deliberately *excluded* workspace, so I did **not** entangle `xsnap` with `endor-debug`; the DebugTransport↔envelope-bus mapping is realized and demonstrated by the integration test rather than by a cross-workspace dependency.

### Verification bar (test-only change to endor-debug)
- `cargo test -p endor-debug`: **46/46** (41 unit + 3 roundtrip + 2 new lifecycle), every `test result` line 0 failed, EXIT=0.
- Engine `cargo build --workspace`: EXIT=0, **zero new Rust warnings** (the C-cc `-Wclobbered`/strict-aliasing lines from `endor-oracle` compiling `c/moddable` are the known baseline).
- `#![forbid(unsafe_code)]` intact at all **8** engine crate roots (incl. `endor-debug`); my test adds no `unsafe`.
- `c/moddable` clean at pin `23b4d6b0a6`, never staged; no bundles committed; only `vm_lifecycle.rs` in the commit.
- No engine **source** changed (tests-only), so compile-diff / boot-gate / SYMB are unchanged by construction — not re-run.

### Honest remainder (precisely named)
**The 11 xsnap Rust debug-protocol tests cannot be exercised headless in the sandbox.** They are C-XS/FFI tests (`rust/endo/xsnap/src/debug_protocol_tests.rs`) that skip unless built `--features debug` (which defines `mxDebug` and recompiles moddable XS). I built with `--features debug` (C compile succeeded) and root-caused the hang with step probes: **execution blocks inside `Machine::new` → `fxCreateMachine`** ("before Machine::new" prints, "after" never does). Because `debug_enable()` precedes creation, `fxConnect` marks the transport connected during machine boot, and XS's `mxDebug` boot debug loop then busy-waits on the non-blocking `fxReceive` for a live, interactive xsbug client the sandbox cannot host — exactly the "real-socket xsbug session" remainder the job sanctioned. Preloading a boot `<go/>` did not unblock it (the boot loop needs a live client, not just a resume byte). On the **default** build these tests **skip** (not hang), so the C-XS path is unperturbed.

Two follow-up paths for a future slice:
- **Make the C-XS tests headless-runnable** — teach `xsnap-platform.c`/`powers::debug` to defer the debugger connection past `fxCreateMachine` (create machine disconnected, activate lazily) so `mxDebug` boots without a live client. Requires C-XS debug-state internals and can't be validated without the very tests that hang; risks the default C-XS path, so out of slice-3 scope.
- **Port the 11 scenarios endor-native** — re-express them against `endor-vm` + `endor-debug` (as `vm_lifecycle.rs` begins to). Blocked today on unimplemented `DebugSession` commands that several scenarios need: eval-in-frame (`<script>`), the exceptions pseudo-breakpoint wired into the VM seam, and object `<toggle>` expansion (all currently parsed-but-inert per `session.rs`'s named remainder).
