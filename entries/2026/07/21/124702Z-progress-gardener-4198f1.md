---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-21T12:47:04Z
---
# Progress: xs2rust-endor assessment — finish line status

## Branch HEAD (as of dispatch)

sha: 949c9cb1d6 (origin/xs2rust-endor)
test(endor-compile): replace should_panic with expect_err for CoverInitializedName test

Last 5 commits on xs2rust-endor:
949c9cb1d6 test(endor-compile): replace should_panic with expect_err for CoverInitializedName test
4b1f2df36f fix(endor-compile): replace three compile-time panics with ParseError reports
88b210b7c0 docs(xs2rust-endor): spell out exception handling — reified jump chain, not longjmp
f76f93531c feat(endor-vm): bind Map.groupBy (PR #600 s10p F2 s46)
676a43465f feat(endor-vm): bind RegExp.escape (PR #600 s10p F2 s46)

## Finish Line Assessment

### Bar 1: Integrated with endor — VERIFIED YES
The Rust engine is wired into the endo daemon:
- `rust/engine/` contains all crates (endor-vm, endor-oracle, endor-compile, endor-regexp, endor-snapshot, endor-debug, endor-fuzz)
- `rust/endo/src/rust_engine.rs` provides `boot_probe()` and `run_rust_worker()` 
- `rust/endo/src/rust_worker.rs` serves the CapTP envelope stream
- `rust/endo/src/engine.rs` exposes SharedEngine::Rust selectable via ENDO_ENGINE env var ("rust"/"endor"/"endor-vm")
- endo Cargo.toml lists endor-vm and endor-compile as dependencies

### Bar 2: All test:rust daemon tests — NOT VERIFIED
Cannot build the endo daemon due to missing boot bundles (ses_boot.js, worker_bootstrap.js, daemon_bootstrap.js). These are gitignored artifacts from bundle-source that must be generated before building xsnap. The Rust engine workspace itself builds cleanly and all unit tests pass.

### Bar 3: test262 parity — NOT MET
Rust engine cargo tests: 102 passed, 0 failed (all green).
endor-xst dual-run results on key subtrees:
- expressions: 9446 total, 2331 covered, **16 failed**, 7099 skipped
  - 1 over-acceptance on assignment/S11.13.1_A5_T5 (PutValue after delete)
  - 11 over-acceptance on compound-assignment/A5.{1-11}_T5 (same pattern)
  - 4 over-acceptance on increment/decrement A5_T5 variants (same pattern)
  - All 16 are "endor completed a source the oracle rejected" — endor completes successfully but C-XS throws. The tests say "No ReferenceError is thrown" per spec, so this may indicate C-XS divergence from ES spec on PutValue for configurable own properties deleted during evaluation.
- built-ins/Boolean: 49 total, 16 covered, 0 failed
- built-ins/String: 1111 total, 233 covered, 0 failed
- built-ins/Array: 2625 total, 534 covered, 0 failed
- built-ins/Math: 275 total, 155 covered, 0 failed
- built-ins/Map: 144 total, 47 covered, 0 failed
- built-ins/Promise: 474 total, 132 covered, **3 failed**, 339 skipped
  - built-ins/Promise/all/species-get-error.js — result divergence (oracle=[object Object], endor=[object Promise])
  - built-ins/Promise/allSettled/species-get-error.js — same pattern
  - built-ins/Promise/race/species-get-error.js — same pattern
- All remaining subtrees checked: passed (0 failures) on Boolean, String, Array, Math, Map

## Remaining Work for Finish Line
1. Fix 16 over-acceptance in expressions PutValue edge cases (compound assignment / increment/decrement where environment binding is deleted during evaluation)
2. Fix 3 Promise species-get-error results (Promise.all/allSettled/race should use Object fallback when species getter throws, not return a Promise)
3. Generate boot bundles to verify test:rust

## Concurrent Agents
Other live agents on inbox-list: xs2rust-endor-build-stage2, minion-town-agenda-review-20260721-122001, self-heal agents. No active pusher on xs2rust-endor currently.
