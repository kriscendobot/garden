The work is complete. PR #1039 is open (draft) against `llm`, all tests pass, inbox is clear.

## Completion report

**Job:** endojs/endo-but-for-bots PR #600 follow-up — make Ironhorse's engine-raised errors unwind through the jump chain.

**What this was:** PR #600 (the Ironhorse Rust engine) merged without the debugger row. The maintainer's `designs/ironhorse-debugger-recovery-and-uncaught.md` decomposes the recovery into 5 phases; this job is **Phase 4** — the hard prerequisite for native break-on-uncaught. Before it, engine-internal errors (`f()` on a non-callable, TDZ reads, undefined variables, `JSON.stringify` of a cyclic value) built `Halt::Throw(..)` inline and escaped straight to the host, so a surrounding JS `try/catch` could **not** catch them and a break-on-uncaught classifier built on the handler chain could never see one.

**What I did (PR #1039, `fix/ironhorse-engine-raise-unwind` → `llm`, draft):**
- Added `Interp::raise` in `rust/engine/ironhorse-vm/src/interp.rs` — routes an engine error through the same `unwind_to_jump` path `XS_CODE_THROW` uses (XS's `fxThrowMessage` → `fxJump`). With a live handler it sets `self.exception` and unwinds to the `catch`; with an empty chain it escapes as `Halt::Throw(msg)` — **byte-identical to the prior behavior** (no allocation, no meter change on the escape path, so uncaught engine-raises stay bit-exact).
- Added a `settle_halt!` macro at the dispatch-loop top and applied it uniformly to the engine-raise sites (the reference/TDZ/iterator-result direct throws and the call/native-helper `Err(h)` returns). Only `Halt::Throw` unwinds; every other `Halt` (meter abort, stack overflow, `Unsupported` skip) propagates unchanged. Unwinding from inside a native is sound because `unwind_to_jump` fully restores stack/scope/call-depth to the catch's recorded cut.
- Added `ironhorse-compile` as a dev-dependency (pure Rust, no cycle, oracle-free) and 9 acceptance tests: each engine-raise class caught (not-a-function `TypeError`, undefined-variable + TDZ `ReferenceError`s, native cyclic-value `TypeError`) with an escapes-when-uncaught companion proving the `jumps.is_empty()` premise, plus two `finally` tests pinning the transit/outer-catch subtleties.

**Verification:** `cargo test -p ironhorse-vm -p ironhorse-snapshot` (the exact `test-ironhorse` CI job) is green — 101 vm tests (92 prior + 9 new), 0 failures. No fmt/clippy gate exists for these crates (confirmed in `ci.yml`); I did **not** run local rustfmt since the repo uses a different pinned version (213 baseline diffs in untouched code).

**Scope note / follow-up:** The caught value is the diagnostic string, not a real XS `Error` instance — bit-exact caught-value/metering parity is deliberately out of scope for this VM-parity slice (design § accuracy over parity). Upgrading engine-raise values to real `Error` objects is tracked as message parity. Phase 5 (the `uncaughtExceptions` break mode + `caught` attribute) can now build on this. Left as draft for maintainer review, per the design's convention for VM-parity PRs the debugger row depends on.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-xs2rust-endor-debugger-caught-vs-uncaught-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 171 tokens (11696375 cached reads)
- Output: 79976 tokens
- Cost: $9.6742185
- Wall-clock: 1217s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
