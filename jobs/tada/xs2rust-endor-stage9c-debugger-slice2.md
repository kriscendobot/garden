Remote tip confirms `c1d6eb807d` landed on `xs2rust-endor`. Inbox empty. The slice is complete and verified.

## Completion report

**Job:** Stage-9c child 6/9 — Debugger slice 2/3: VM-side inspection hooks behind `DebugTransport`, on `endojs/endo-but-for-bots` PR #600 branch `xs2rust-endor`.

**Measured base:** synced to the real remote tip `85131468b1` (child 5 had landed since the body was written — further along than the body's `8865953620`). Pushed `c1d6eb807d` on top; PR kept DRAFT, no PR comment.

**What I built (all landed, one commit):**
- **endor-vm debug seam (`endor-vm/src/debug.rs`, new):** `DebugHook` (the VM→debugger callback at the `line`/`debugger` opcodes) and `DebugCtx` (read-only frames/locals/globals inspection), plus the `Binding`/`FrameInfo` data model. Acyclic layering: `endor-debug` → `endor-vm`.
- **Interpreter wiring (`interp.rs`):** `Option<Box<dyn DebugHook>>` field (dormant by default), the **single dormant branch** at `XS_CODE_LINE`/`XS_CODE_DEBUGGER`/`XS_CODE_FILE` (take/put re-entrancy so the hook borrows `self` as `DebugCtx`), `attach_debugger`/`detach_debugger`, and the `DebugCtx` impl sourcing the live `call_stack`/`locals`/`global_props` arenas.
- **endor-debug VM-side layer:** `BreakpointTable` (set/clear/clear-all/set-all + `exceptions` pseudo-breakpoint), `StepMode` (go/step/step-into/step-out depth machine), and `DebugSession` implementing `DebugHook` — on a stop it emits the `<xsbug>` frames/local/global/break batch through slice-1's byte-exact `Echo` escaping, then runs the `fxDebugLoop` command loop.
- **Ledger (`endor-snapshot/sidetable.rs`):** new `Coverage::SnapshotExcluded` + `SideTable::DebuggerState` row stating explicitly the debugger is **snapshot-EXCLUDED by contract** and **GC-invisible** (roots no arena slots); `VARIANT_COUNT` 32→33; a test asserting it.

**Acceptance bar (full, since debug code now reaches metered dispatch):**
- Fresh `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, `c/moddable` at pin `23b4d6b0a6` clean and never staged.
- Workspace `cargo test --workspace` EXIT=0, every `test result:` 0 failed (endor-vm 88→91, endor-debug 28→41, endor-snapshot +2).
- Curated compile-diff **1878/1878 identical, 0 divergent**; SYMB **1878/1878 identical** (grew from 1759).
- Boot gate **17 passed**, 0 skipped (no skip→green conversions).
- Metering-neutral proven: targeted test asserts identical computrons+dispatch for an attached auto-continue debugger over a LINE-bearing program vs disarmed; the corpus emits no LINE opcodes so the branch is provably never taken there.
- **Zero new Rust warnings** (only pre-existing moddable C warnings).
- `#![forbid(unsafe_code)]` intact — **7** active engine crate roots (incl. endor-debug and endor-vm; endor-oracle remains the audited FFI seam).

**Honest remainder (named precisely):**
- **Break-on-uncaught firing:** the `exceptions` pseudo-breakpoint is parsed + tabled, but the interpreter-side `firstJump`-empty (`self.jumps.is_empty()`) walk at the throw/unwind sites is deferred (would touch multiple `Halt::Throw` escape sites and wants pre-unwind frame capture).
- **eval-in-frame** (`<eval>`), **frame select/toggle expansion** (`<select>`/`<toggle>`), and **profiling** (`<start/stop-profiling>`) — all parsed (slice 1) and accepted by the command loop as no-op stays, not yet acted on.
- **Live LINE-driven stepping against real programs:** unit-tested on synthetic bytecode only, since the covered-grammar corpus emits no `line` opcodes; driving it end-to-end awaits a debug-compiled bytecode path.
