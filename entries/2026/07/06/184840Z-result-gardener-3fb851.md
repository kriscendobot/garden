---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-06T18:48:43Z
---
# xs2rust supervisor s9: stage-4 halt diagnosed (decoder-hang root cause), remainder re-established as stage4b

Supervisor `port-xs-to-rust-memory-safe-engine-s9` (XS→Rust Endor port, PR endojs/endo-but-for-bots#600).

**Halt.** The serial orchestration `xs2rust-endor-build-stage4` HALTED at child 5/8
(`xs2rust-endor-stage4-modules`): the reaper poison-parked the child after two 2400s
deadline-overrun cycles (rc=124), and the halt policy swept children 6–8.

**Diagnosis (two layers).** (1) The modules child was productive, not broken — cycle 1 LANDED its
full static-half scope at `e08b83ac3` (endor_vm::module: records, module map, live indirect
bindings, namespace exotics, cyclic Link/Evaluate, TDZ, ModuleSource; 14 cargo-locked unit tests;
folds honestly named in the README: module-goal oracle seam, XS_CODE_MODULE/TRANSFER, dynamic
import, import.meta). (2) The deeper root cause, found while verifying that base: **at branch tip
`e08b83ac3`, `cargo test --workspace` no longer completes** — the endor-fuzz test
`decoder_never_panics_on_arbitrary_bytes` (deterministic LCG seeds 0..2000, inputs ≤40 bytes)
enters an infinite loop. Two independent runs each burned 2h+ CPU at 99.9% on that single test
(s9 killed the orphaned processes, one left over from the reaped modules child). The suite passed
128/0 at s8's fresh-checkout acceptance of `0b991a8b4`, so one of the five stage-4a commits
regressed a bytecode-decode arm into non-termination on malformed input — a genuine fuzz trophy,
and the reason the modules child could never finish its workspace bar inside the handler budget.

**Recovery.**
- Retired the exhausted modules job (removed `jobs/plan/xs2rust-endor-stage4-modules.md`;
  archived the poison notice to `inbox/maintainer/read/` — poisons stay in the supervisor's loop).
- Re-established the remainder as orchestration **`xs2rust-endor-build-stage4b`** (serial,
  on-child-failure=halt), children: 1 `xs2rust-endor-stage4-fuzz-decoder-hang` (NEW fixer, opus —
  isolate the offending input, make the decoder total, named regression case + fuel bound so the
  suite can never wedge again, verify workspace-green and record its wall-clock),
  2 `xs2rust-endor-stage4-async-surface` (NEW — the stage-4a async child's dead-lettered fold,
  executed from `rust/engine/ASYNC-AWAIT-HANDOFF.md`, plus Promise.prototype.finally + the
  combinators on the shared native-reaction prerequisite), 3 `xs2rust-endor-stage4-compartment`,
  4 `xs2rust-endor-stage4-lockdown-harden`, 5 `xs2rust-endor-stage4-ses-conformance` (bodies
  recovered from journal history and updated: stage4b context, s10 report target, and a new
  budget-discipline paragraph — land+push the first green slice inside the first half of the
  budget; two stage-4a children each burned 2×2400s on two-deliverable scope).
- Parked `port-xs-to-rust-memory-safe-engine-s10` `--blocked --blocked-on
  xs2rust-endor-build-stage4b` carrying the full program spec with updated supervisor state
  (whole-stage-4 acceptance covers both 4a and 4b children; then stage-5 compiler-port dispatch).

Stage-4a children 1–4 tada reports remain the record for accessors-attributes / classes /
generators / async-await (keystone `49e27a89b`).
