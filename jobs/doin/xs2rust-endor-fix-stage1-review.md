---
model: opus
---
# Fixer: wire the meter check points and tighten the dual-run acceptance predicate (PR #600 stage-1 review findings 1-3)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT). Workspace
`rust/engine/` (independent Cargo workspace; needs the `c/moddable` oracle pin — reproduction
procedure in `rust/engine/README.md`: shallow-fetch `48ee02d8cfe0` into `c/moddable`).

Fix the three defects from the supervisor's stage-1 review
(https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4870367815):

1. **Wire the meter check points in `endor-vm/src/interp.rs`.** `Meter::begin`/`Meter::check`
   are dead code; `Halt::MeterAbort` is unreachable. Port C-XS's placement exactly
   (`xs/sources/xsRun.c` at the pin, lines ~270-285): `mxBranch`-family opcodes run
   `mxCheckMeter` only when the branch offset is negative; returns and catches check too
   (stage-1 subset: wire negative-offset `BRANCH_1/2/4`, `BRANCH_ELSE_1/2`, `BRANCH_IF_1/2`
   and `RETURN`/`END`). `Interp` needs a public way to arm metering (interval + host callback)
   without changing the default un-metered behavior the differential harness uses. On
   `MeterCheck::Abort`, halt with `Halt::MeterAbort`.
2. **Port the overflow-wrap guard into `Meter::check`** (`fxCheckMetering`, `xsRun.c:4475`):
   after a continue, if the new `meterCount` wrapped below `meterIndex`, reset
   `meterIndex = 0; meterCount = interval`.
3. **Tighten `DualRun::is_bit_exact` in `endor-262/src/lib.rs`:** `Agreement::BothAbort` counts
   as bit-exact ONLY when `endor_halt` is `Halt::Throw`; an `Unsupported` or `Decode` halt is
   never bit-exact even when the oracle also aborted. Count such runs under
   `Summary.unsupported` (or a new divergence counter) so they can never pass silently.

Tests required: a hand-assembled backward-`BRANCH_1` loop bytecode proving (a) an armed meter
aborts with `MeterAbort` at the expected computron threshold and (b) an unarmed meter still
accumulates without checking; a unit test for the wrap guard; a predicate test that a
`BothAbort` with `Unsupported` is not bit-exact. The existing acceptance bar must stay green:
`cargo test --workspace` in `rust/engine/` and the harness's 86/86 bit-exact summary are the
regression gate (the check points add no meterIndex, so computron counts must not move).

Binding constraints: design `designs/xs2rust-endor-engine.md` § Resolved Questions;
`#![forbid(unsafe_code)]` stays on all crates except `endor-oracle`; PR stays draft; commit to
`xs2rust-endor` and push. Do NOT touch the `c/moddable` gitlink (supervisor ruling: deferred).

---
claim:
  host: endolinbot2
  gardener: 16
  claimed_at: 2026-07-02T20:53:07Z
