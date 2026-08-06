---
model: opus
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T15:10:00Z cleared=none -->

---
model: opus
---
# End-state: decommission C-XS — drop `c/moddable`, remove the C-binding Endor, make the Rust VM default, establish parity via Moddable-downloaded `xst` in CI

**Repo:** `endojs/endo-but-for-bots`, PR arc `xs2rust-endor` (#600). **Gate: go-ahead**
— the terminal cleanup, to run **only once the XS→Rust port is complete** (the
charter finish line: endor daemon integration + green `test:rust` + test262
parity closure). Directive: @kriskowal (liaison relay, 2026-07-26). **Do not
promote before the port is done.**

## Target end-state (maintainer's words, 2026-07-26)

> "When the port of XS to Rust Endo VM is complete, I would like to relieve the
> repository of its `c/moddable` submodule, remove the C binding variant of
> Endor, make the Rust VM default, and establish parity only through the version
> of `xst` downloaded from Moddable in CI, running under harness262 to maintain
> parity or at least observable deviation from parity. I would then like to
> continue manual validation of the two things that currently work: endor with
> C-XS and the stand-alone `endor-xst`."

## What this entails (scope, to be refined at promotion)

1. **Make the Rust VM the default engine.** Today `xsnap` (which compiles
   `c/moddable`) is a **non-optional** dependency of the `endo` crate and the
   worker/daemon/run paths call it directly; the Rust `endor_engine::Machine`
   bridge is defined but **never dispatched**. This step reverses that: the Rust
   VM becomes the default `endor` engine (`daemon`/`worker`/`run`), requiring the
   engine to actually be wired into the daemon/worker CapTP loop (charter
   finish-line #1) first.
2. **Remove the C-binding Endor variant.** Feature-gate then delete the `xsnap`
   dependency and all its call sites (`inproc.rs`, `execute.rs`, `cas_archive.rs`,
   `bin/endor.rs`, `engine.rs`, `endo.rs`); remove `rust/endo/xsnap` and the
   `endor-oracle` in-tree C-XS compile.
3. **Relieve the repo of `c/moddable`.** Remove the submodule (pin
   `23b4d6b0a65f`, 8.3.1) once nothing in-tree compiles C-XS.
4. **Establish parity via Moddable-downloaded `xst` in CI.** Replace the in-tree
   C-XS oracle with CI that **downloads `xst` from Moddable** and runs it under
   `test262-harness` (the `test262:xs` host) alongside the Rust-default `endor`
   host, so parity — or observable deviation from parity — is maintained without
   a vendored C engine. Depends on the annotation-driven single corpus +
   parameterized expectation lists from the groundwork plan
   `consolidate-test262-fixtures`.

## Dependencies / ordering

- **Blocked on port completion** (endor daemon integration; green `test:rust`;
  test262 parity closure). Not before.
- **Depends on** `consolidate-test262-fixtures` (single annotation-driven corpus
  with parameterized pass/fail expectations) — that refactor is the CI-parity
  substrate this end-state relies on.
- Preserve, throughout, the two surfaces the maintainer validates by hand:
  **endor-with-C-XS** (until removal) and the **stand-alone `endor-xst`** binary.

## Acceptance

- `endor` runs the Rust VM by default across `daemon`/`worker`/`run`; `xsnap`,
  `rust/endo/xsnap`, `endor-oracle`, and `c/moddable` are gone from the tree.
- CI proves parity/deviation using Moddable-downloaded `xst` under
  `test262-harness` against the single consolidated corpus.
- The build no longer requires `c/moddable` (the README's C-XS build dependency
  is removed).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T15:10:23Z
