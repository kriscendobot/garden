---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-29T01:41:50Z
---
# xs2rust-endor bin 1/3 — daemon integration: DONE

Job: `xs2rust-endor-s1-daemon-integration` (child 1 of the serial
orchestration `xs2rust-endor-finish-line`).

PR endojs/endo-but-for-bots#600, branch `xs2rust-endor`, base `llm`, still DRAFT.

## Branch HEAD

- Before: `b6a48c7d13` (181 behind `llm`, 350 ahead)
- After:  `3b602b2037` (0 behind `llm`, 351 ahead) — rebased onto latest `llm`
  and force-pushed, then my integration commit on top.
- The whole 351-commit rebase produced exactly ONE conflict (root `Cargo.toml`:
  `llm` added `rust/thixotrope-xs-worker` to `members`, the branch adds
  `exclude = ["rust/engine"]`); resolution keeps both.

## The bar: met

The bar was NOT met before. `rust/endo/src/endor_engine.rs` existed but was
inert: behind an off-by-default `endor-engine` feature, referenced by nothing
but `pub mod` in lib.rs, and its `Machine` was a stub (`id()` -> -1, all
metering methods returning 0). It also evaluated via `Compartment::evaluate`,
which never links intrinsics, so its own path could not have resolved them.

Now the engine crates are a real, selectable engine of the `endor` binary:

- `endor-engine` is a DEFAULT cargo feature — the daemon genuinely builds
  against `endor-vm` + `endor-compile`. `--no-default-features` still yields an
  XS-only binary that reports `-e endor-rs` as an unknown engine.
- Compiles via `compile_atoms_with` and evaluates via `evaluate_with_symbols`,
  so intrinsics are linked; reports the engine's real meter
  (computrons/dispatched/meter_raw) and halt reason instead of placeholder zeros.
- `endor run -e endor-rs <script.js>` runs real JavaScript on the Rust engine.
- `endor worker -e endor-rs` reports its named gap (host-function surface +
  SES boot bundle, roadmap stages 4/7) rather than pretending to work.

## Evidence

    cargo build -p endo --bin endor                       # ok
    cargo build -p endo --bin endor --no-default-features # ok (XS-only)
    cargo test -p endo --lib                              # 178 passed
    endor run -e endor-rs demo.js
      -> 385, "269 computrons (261 dispatched, meter_raw 17680712)"

(demo.js = sum of squares 1..10; 385 is correct.)

An unlanded surface halts with a NAMED gap and non-zero exit — endor declines
rather than returning a wrong answer.

## Notes for bins 2 and 3

1. **A fresh checkout cannot build the daemon.** Three `include_str!`ed JS
   bundles are gitignored build artifacts. Generate with:
       git submodule update --init c/moddable   # C-XS sources, also absent
       node packages/daemon/scripts/bundle-bus-worker-xs.mjs           # ok
       node packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs  # ok
       node packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs      # FAILS
2. **The manager bundle generator is broken** (pre-existing, identical on
   `llm`). `bus-manager-rust-xs.js` -> `manager.js` imports Node-only
   `@endo/platform/fs/lite`, `@endo/git`, `@endo/host-spawner`;
   compartment-mapper cannot bundle them for XS. Adding them to
   `EXCLUDED_PACKAGES` only moves the failure, since `manager.js` really uses
   them (commits 8bffda4504/49a0dec24e tried stubs; b6a48c7d13 reverted them).
   I used a local, gitignored, deliberately-throwing placeholder
   `daemon_bootstrap.js` purely to compile; it is NOT committed and the
   `-e endor-rs` path never touches it. Fixing this properly = XS-compatible
   implementations of those subpaths — separate work from the engine port.
3. **Known flaky test** for bin 2 (`test:rust` green):
   `execute::tests::nested_module_relative_imports_resolve_against_referrer`
   fails intermittently (~1 in 3) with "entry module import did not settle
   (async work still pending)". Present both before and after the rebase, and
   passes in isolation — a timing flake, not a regression.
