The job is complete. PR #600 is still draft, the stage-1 status section (with the 86/86 evidence) is present, both commits are pushed to `origin/xs2rust-endor`, and the full test suite is green.

---

**Completion report**

Implemented roadmap **stage 1 (thin slice)** of the xs2rust-endor engine port on PR #600 (branch `xs2rust-endor`, kept draft). Two commits pushed to `origin/xs2rust-endor` (`5eaf83e58`, `2b61b2deb`).

**What landed** — a Cargo workspace at `rust/engine/` (nested; excluded from the repo-root workspace):
- **`endor-vm`** (`#![forbid(unsafe_code)]`): `SlotIndex`/`ChunkOffset` index arenas with 32-byte slot records (resolved Q5), a `Vec`-backed slot stack, a `match`-dispatch interpreter over the arithmetic/logic/bitwise/comparison/unary/branch/stack opcode subset ported case-by-case from `xsRun.c` (i32 fast paths with checked-overflow→f64 promotion, XS `-0` handling, ToInt32 bitwise, NaN-aware comparison), and the 16.16 fixed-point meter (1<<16/dispatch, 1<<14/builtin, loop-closing check points). The opcode enum + size/name tables are **generated verbatim** from `xsCommon.h`/`xsCommon.c` at pin `48ee02d8cfe0`, so bytes/sizes/mnemonics match the oracle.
- **`endor-oracle`** (the only unsafe/FFI crate; dev/CI only): a C shim compiled alongside C-XS that compiles source to XS bytecode and runs it, returning `(bytecode, result, run-only computrons)`; `meterIndex` is reset after parse so parse metering can't contaminate the interpreter-parity number.
- **Compartment seam**: `Compartment.evaluate` over shared intrinsics with fresh per-compartment globals (proves the requirement-5 seam).
- **`endor-262`**: dual-run harness + curated corpus (`corpora/{arithmetic,logic,control-flow}.js`), four-valued + computron agreement.
- **`endor-fuzz`**: cargo-fuzz targets 1 (differential source, structure-aware) and 2 (bytecode decoder), logic as a testable `forbid(unsafe_code)` lib.

**Acceptance bar met, with evidence:** `total=86 bit_exact=86 result_div=0 computron_div=0 completion_div=0 unsupported=0` — bit-exact (result, computron) agreement with the C-XS oracle across the whole stage-1 corpus, including i32-overflow promotion, `-0`/Infinity/NaN, ToInt32 bitwise, short-circuit, and nested ternary. A 300-program differential fuzz sweep holds the same agreement; a 2000-input decoder sweep confirms no panics on arbitrary/truncated bytes. `forbid(unsafe_code)` holds on all crates except `endor-oracle`.

**Frictions flagged for the supervisor** (documented in `rust/engine/README.md` and the PR):
1. **Calls deferred to the next increment.** The subset landed bit-exact is arithmetic/logic/branch/stack; user function calls need the `function`/`constructor_function` opcodes + closure/scope/argument-binding + call/run frame machinery (~15 more opcodes) overlapping stage 2's "closures, full opcode coverage." Scoped out to avoid destabilizing the proven metering bar — a scope decision, not a divergence.
2. **`c/moddable` pin.** The oracle builds against the design's stated pin `48ee02d8cfe0`, but (a) the recorded submodule gitlink `5516726…` is not fetchable upstream (not bumped unilaterally), and (b) an API drift (`fxInitializeSharedCluster` arity) plus `xsnap`'s reliance on gitignored generated SES bundles led `endor-oracle` to link the C-XS sources directly (reusing xsnap's audited platform layer and identical feature defines) rather than as a Cargo path dependency on `xsnap` — a deviation from task item 4's "through the existing `xsnap` crate."

**Follow-ups:** supervisor ruling on the submodule-gitlink correction and the direct-link-vs-xsnap-path-dependency deviation; next build increment = function calls + the frame-geometry execution path.
