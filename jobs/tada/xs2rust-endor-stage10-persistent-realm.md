All gates green, both commits pushed, working tree clean, no messages. Job complete.

---

## Completion report — `xs2rust-endor-stage10-persistent-realm` (PR #600 stage 10 child 3)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, kept DRAFT, not commented). Synced to real tip `5d8df81871` before starting.

### What I did

**1. Persistent guest realm (engine — `endor-vm`).** endor-vm can now hold one realm live across evaluations:
- New public `endor_vm::PersistentRealm` owns an `Interp` and drives a new `Interp::run_more_with_symbols(code, symbols)` incremental entry. Between programs it **carries top-level global own-properties by NAME** (`carry_globals_into`): snapshots them via the `symbol_ids` inverse, resets the per-program symbol tables, re-links the next program's intrinsics onto a fresh global object, then re-installs the carried globals under the new program's interned ids. So a `globalThis.handleCommand` installed by one turn is readable by the next.
- The metered single-shot path (`Compartment::evaluate_with_symbols`, `Interp::run`) is **untouched** — it still mints a fresh `Interp` per call, so dual-run byte-identity holds.

**2. Host-reply channel (engine).** `Interp::install_host_send_frame(name)` binds a `hostSendRawFrame`-shaped guest global (a bare function instance recorded in a new `host_send_fns` set, mirroring the `promise_functions` seam). A guest call is caught at the `RUN` dispatch (before the native/enter_call path) and enqueues its argument's `String()` bytes onto `host_outbox`; `drain_host_outbox()` returns them. It's host-only — an oracle/corpus program never references the name, so the branch never fires on the metered path.

**3. Side-table ledger.** Added `SideTable::HostReplyChannel` (`host_send_fns/host_outbox`) as `SnapshotExcluded` by contract (drained per turn → empty at a quiescent crank boundary; re-installed per session; GC-invisible), with `ALL`, `VARIANT_COUNT` 33→34, and two ledger tests.

**4. Worker surface (`endo` crate, `rust_worker.rs`).** `EndorGuest` now holds a `PersistentRealm` for the whole session instead of a fresh `Compartment` per deliver; `dispatch_deliver` drains the host outbox after each turn and surfaces frames as extra `deliver` replies. Added `eval_turn`/`drain_replies` seams and a **multi-turn test** proving the loop (turn 1 installs `handleCommand` state; turn 2 reads it back and replies via `hostSendRawFrame`), plus a deliver-surfaces-host-frames test. Module doc updated: remainder note 1 (persistent realm + host channel) is closed for state and replies.

### Verification (all EXIT=0)
- Engine `cargo test` (clean of the 3 crates first): **690 passed, 48 `test result` lines all 0 failed**.
- compile-diff curated: **1909 identical, 0 divergent**, full accept/reject agreement; **SYMB 1909 identical, 0 divergent**; module corpora **47 identical, 0 divergent**.
- Boot gate: **17 passed, 0 failed** (no skip→green changes).
- **Zero new Rust warnings** (346 warnings are all C `cc` moddable-source warnings); `#![forbid(unsafe_code)]` intact on all 8 engine lib roots incl. endor-vm.
- `c/moddable` clean at pin `23b4d6b0…`, never staged; no committed bundles.
- ROOT-workspace endo `cargo test -p endo --lib`: **82 passed, 0 failed** (80 at stage-9 close + my 2 worker tests). rust_worker subset: 10 passed.

Both commits pushed to `xs2rust-endor`: `fce3dce3aa` (engine) and `220dda50df` (worker).

### Named remainder (honest boundary)
- **Cross-turn function *invocation*** is NOT closed: a `handleCommand` installed as *data* survives and is readable, but one installed as a **function** does not survive as *callable* — the interpreter dispatches a function body by its byte offset into the *currently running* program's code buffer, so calling a prior turn's function would dispatch into this turn's bytes. This needs an append-only / rebased code buffer — a larger engine change for a later child. Documented in the module doc (remainder note 1) and on `run_more_with_symbols`.
- Persistent state must use `globalThis.X = …` (not a top-level eval `var`, which the coder may keep as a frame local); this is the correct realm idiom and is what the tests and worker use.
- SES worker bundle boot (note 2) and snapshot suspend/restore (note 3) remain as before, untouched.
- Env note: the `endo` crate build needs generated JS bundles (`ses_boot.js`/`worker_bootstrap.js`/`daemon_bootstrap.js`, produced by `packages/daemon/scripts/bundle-*.mjs`, requiring a full monorepo `yarn install`). I verified the worker with **gitignored placeholder bundles** (never committed) — no `endo` lib test needs the real bundles at runtime, so the 82-pass result is sound; a CI/full build regenerates them normally.
